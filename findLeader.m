function leader = findLeader(veh, allVehicles, network, lateralTol, lookAhead)
% findLeader - returns the nearest vehicle ahead within lateralTol and lookAhead distance
% If none found returns [].
% Handles non-lane discipline by checking lateral distance (m).
%
% Inputs:
%   veh         Vehicle object
%   allVehicles array of Vehicle objects
%   network     RoadNetwork object
%   lateralTol  lateral tolerance in meters
%   lookAhead   max longitudinal search distance (m)
%
% Outputs:
%   leader      Vehicle object or []

    candidates = allVehicles([allVehicles.x] > veh.x); % ahead only
    leader = [];
    minDist = inf;
    if isempty(candidates), return; end

    for k=1:length(candidates)
        c = candidates(k);
        lateralDist = abs((c.y - veh.y) * network.sublaneWidth);
        if lateralDist <= lateralTol
            dist = c.x - c.length - veh.x;
            if dist >= 0 && dist <= lookAhead && dist < minDist
                minDist = dist;
                leader = c;
            end
        end
    end
end
