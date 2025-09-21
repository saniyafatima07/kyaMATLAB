classdef Vehicle < handle
    properties
        id
        type            % 'car','2w','truck',...
        length
        width
        vmax
        amax
        bmax
        desiredHeadway
        driverProfile   % struct with aggressiveness, laneChangeProb
        x               % longitudinal position (m)
        y               % lateral position (sublane index)
        v               % speed (m/s)
        lane            % logical lane or sublane index
        state
        entryTime
        
        % --- ADDED FOR JITTER FIX ---
        laneChangeCooldown % Timer to prevent rapid lane changes
    end
    methods
        function obj = Vehicle(id, type, params)
            obj.id = id;
            obj.type = type;
            fn = params.(type);
            obj.length = fn.length;
            obj.width  = fn.width;
            obj.vmax   = fn.vmax;
            obj.amax   = fn.amax;
            obj.bmax   = fn.bmax;
            obj.desiredHeadway = fn.headway;
            obj.driverProfile = fn.driver;
            obj.x = fn.x0;
            obj.y = fn.y0;
            obj.v = fn.v0;
            obj.state = 'moving';
            obj.entryTime = fn.t0;
            
            % --- ADDED FOR JITTER FIX ---
            obj.laneChangeCooldown = 0; % Initialize cooldown to 0
        end
        
        function updateKinematics(obj, a, dt)
            % simple Euler update
            obj.v = max(0, min(obj.vmax, obj.v + a * dt));
            obj.x = obj.x + obj.v * dt;
        end
    end
end