function leader = findLeaderInSublane(veh, snapshot, targetSublane, network, lookAhead)
% Return nearest vehicle ahead in target sublane within lookAhead. [] if none.
    leader = [];
    minDist = inf;
    for k=1:length(snapshot)
        c = snapshot(k);
        if c.y ~= targetSublane, continue; end
        if c.x <= veh.x, continue; end
        d = c.x - c.length - veh.x;
        if d >= 0 && d <= lookAhead && d < minDist
            minDist = d; leader = c;
        end
    end
end
