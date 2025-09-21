function [offsetAccepted, info] = lateralDecisionAdvanced(veh, snapshot, network, params)
% Decide lateral move (-maxOffset..+maxOffset) with safety + incentive + stochastic acceptance.
% Robust to empty leader/follower returns.

% defaults
L = params.lateral;
if ~isfield(L,'maxOffset'); L.maxOffset = 1; end
if ~isfield(L,'lookAhead'); L.lookAhead = 50; end
if ~isfield(L,'lookBack');  L.lookBack = 10; end
if ~isfield(L,'frustrationThresh'); L.frustrationThresh = 0.12; end
if ~isfield(L,'safetyHeadwayFront'); L.safetyHeadwayFront = 6; end
if ~isfield(L,'safetyHeadwayBack');  L.safetyHeadwayBack  = 4; end
if ~isfield(L,'timeGapFront'); L.timeGapFront = 1.0; end
if ~isfield(L,'timeGapBack');  L.timeGapBack  = 0.5; end
if ~isfield(L,'probBase'); L.probBase = 0.6; end
if ~isfield(L,'allow2WGapFactor'); L.allow2WGapFactor = 0.5; end

offsetAccepted = 0;
info = struct('frustration',0,'candidates',[],'chosen',0,'reason','none');

% desired speed
v_desired = veh.vmax;

% leader in current sublane
leaderCurr = findLeaderInSublane(veh, snapshot, veh.y, network, L.lookAhead);
if isempty(leaderCurr)
    v_lead_curr = v_desired;
else
    v_lead_curr = leaderCurr.v;
end

% normalized frustration (0..1)
info.frustration = max(0, (v_desired - v_lead_curr) / max(1e-3, v_desired));
if info.frustration < L.frustrationThresh
    info.reason = 'no_incentive';
    return;
end

% candidate offsets (exclude 0)
candidates = -L.maxOffset:L.maxOffset;
candidates(candidates==0) = [];

% compute gap metrics safely
gapMetric = -inf(size(candidates));
info.candidates = struct([]);
for i=1:length(candidates)
    off = candidates(i);
    tgt = veh.y + off;
    if tgt < 1 || tgt > network.numSublanes
        gapMetric(i) = -inf;
        info.candidates(i).offset = off; info.candidates(i).gapAhead = -inf; info.candidates(i).gapBack = -inf;
        continue;
    end

    leadT = findLeaderInSublane(veh, snapshot, tgt, network, L.lookAhead);
    if isempty(leadT)
        gapAhead = inf;
    else
        gapAhead = leadT.x - leadT.length - veh.x;
    end

    backT = findFollowerInSublane(veh, snapshot, tgt, network, L.lookBack);
    if isempty(backT)
        gapBack = inf;
    else
        gapBack = veh.x - backT.x - backT.length;
    end

    gapMetric(i) = min(gapAhead, gapBack); % conservative metric
    info.candidates(i).offset = off;
    info.candidates(i).gapAhead = gapAhead;
    info.candidates(i).gapBack  = gapBack;
end

% sort candidates by gap descending
[~, ord] = sort(gapMetric, 'descend');
for jj=1:length(ord)
    j = ord(jj);
    if gapMetric(j) == -inf, continue; end
    off = candidates(j);
    tgt = veh.y + off;

    % adaptive safety thresholds
    sf = L.safetyHeadwayFront + veh.v * L.timeGapFront;
    sb = L.safetyHeadwayBack  + veh.v * L.timeGapBack;

    % class factor for 2W
    classFactor = 1.0;
    if strcmpi(veh.type,'tw') || strcmpi(veh.type,'2w')
        classFactor = L.allow2WGapFactor;
    end

    % recompute lead/back safely
    leadT = findLeaderInSublane(veh, snapshot, tgt, network, L.lookAhead);
    if isempty(leadT)
        gapAhead = inf;
    else
        gapAhead = leadT.x - leadT.length - veh.x;
    end
    backT = findFollowerInSublane(veh, snapshot, tgt, network, L.lookBack);
    if isempty(backT)
        gapBack = inf;
    else
        gapBack = veh.x - backT.x - backT.length;
    end

    safeAhead = (gapAhead >= sf * classFactor);
    safeBack  = (gapBack  >= sb * classFactor);

    info.candidates(j).safe = (safeAhead && safeBack);

    if ~(safeAhead && safeBack)
        continue;
    end

    % acceptance probability
    driverProp = 0.5;
    if isfield(veh.driverProfile,'laneChangeProb')
        driverProp = veh.driverProfile.laneChangeProb;
    end
    p = L.probBase * (1 + (driverProp - 0.5)) * (1 + info.frustration);
    if any(strcmpi(veh.type,{'truck','bus','hcv'}))
        p = p * 0.5;
    end
    p = min(1, p);

    info.candidates(j).acceptedProb = p;
    if rand() < p
        offsetAccepted = off;
        info.chosen = off;
        info.reason = 'accepted';
        return;
    else
        info.candidates(j).accepted = false;
    end
end

info.reason = 'no_safe_candidate';
end
