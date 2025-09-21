classdef RoadNetwork
    properties
        length
        numSublanes
        sublaneWidth
        obstacles % struct array with fields x_start,x_end,effect (speedFactor)
    end
    methods
        function obj = RoadNetwork(len, nsub, sw)
            obj.length = len;
            obj.numSublanes = nsub;
            obj.sublaneWidth = sw;
            obj.obstacles = struct('x_start',{},'x_end',{},'factor',{});
        end
        function f = obstacleFactor(obj, x)
            f = 1.0;
            for i=1:length(obj.obstacles)
                o = obj.obstacles(i);
                if x >= o.x_start && x <= o.x_end
                    f = f * o.factor;
                end
            end
        end
    end
end
