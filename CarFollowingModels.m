classdef CarFollowingModels
    methods(Static)
        function a = IDM(veh, leader, params)
            % Intelligent Driver Model
            % params: [s0, T, a, b, delta]
            if isempty(leader)
                s = inf;
                dv = 0;
                v_lead = veh.vmax;
            else
                s = leader.x - leader.length - veh.x;
                dv = veh.v - leader.v;
                v_lead = leader.v;
            end
            s0 = params.s0; T = params.T; a = params.a; b = params.b; delta = params.delta;
            v = veh.v;
            s_star = s0 + max(0, v*T + v*dv/(2*sqrt(a*b)));
            accel = a * (1 - (v/veh.vmax)^delta - (s_star / max(s,0.01))^2);
            a = accel;
        end
        function a = Gipps(veh, leader, params)
            % Minimal placeholder for Gipps formula; replace with full form later
            a = min(veh.amax, (veh.vmax - veh.v)/params.reactionTime);
        end
    end
end
