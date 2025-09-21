function follower = findFollowerInSublane(veh, snapshot, targetSublane, network, lookBack)
% Return nearest vehicle behind in target sublane within lookBack. [] if none.
    follower = [];
    minDist = inf;
    for k=1:length(snapshot)
        c = snapshot(k);
        if c.y ~= targetSublane, continue; end
        if c.x >= veh.x, continue; end
        d = veh.x - c.x - c.length;
        if d >= 0 && d <= lookBack && d < minDist
            minDist = d; follower = c;
        end
    end
end

