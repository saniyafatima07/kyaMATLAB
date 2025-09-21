classdef TrafficSimulator < handle
    properties
        dt
        T
        network
        vehicles % array of Vehicle objects
        t
        logs
        laneChanges
        params
        nextId
        spawnBuffer % vehicles waiting to be inserted (struct)
    end
    methods
        function obj = TrafficSimulator(network, params)
            obj.network = network;
            obj.dt = params.dt;
            obj.T  = params.T;
            obj.vehicles = Vehicle.empty();
            obj.t = 0;
            obj.logs = {};
            obj.laneChanges = struct('time',{},'id',{},'from',{},'to',{}); 

            obj.params = params;
            obj.nextId = 1;
            obj.spawnBuffer = [];
        end
        
        function addVehicle(obj, veh)
            obj.vehicles(end+1) = veh;
        end
        
        function run(obj)
            nsteps = ceil(obj.T / obj.dt);
            for step=1:nsteps
                obj.t = obj.t + obj.dt;
                % spawn arrivals
                obj.handleArrivals();

                % leader detection + longitudinal update
                vehiclesCopy = obj.vehicles; 
                for i=1:length(obj.vehicles)
                    v = obj.vehicles(i);
                    leader = findLeader(v, vehiclesCopy, obj.network, obj.params.lateralTol, obj.params.IDM.lookAhead);
                    a = CarFollowingModels.IDM(v, leader, obj.params.IDM);
                    
                    factor = obj.network.obstacleFactor(v.x);
                    a = a * factor;
                    v.updateKinematics(a, obj.dt);
                end

                % --- MODIFIED LATERAL DECISION LOOP (WITH COOLDOWN) ---
                vehiclesCopy = obj.vehicles; % update snapshot after longitudinal moves
                for i=1:length(obj.vehicles)
                    v = obj.vehicles(i);
                    
                    % --- JITTER FIX PART 1: Check and decrement cooldown ---
                    if v.laneChangeCooldown > 0
                        v.laneChangeCooldown = max(0, v.laneChangeCooldown - obj.dt);
                        continue; % Skip lane change evaluation for this vehicle
                    end
                    
                    [offsetAccepted, ~] = lateralDecisionAdvanced(v, vehiclesCopy, obj.network, obj.params);
                    
                    if offsetAccepted ~= 0
                        oldY = v.y;
                        newY = v.y + offsetAccepted;
                        if newY >=1 && newY <= obj.network.numSublanes
                            v.y = newY;
                            
                            % --- JITTER FIX PART 2: Set cooldown on successful change ---
                            v.laneChangeCooldown = 3.0; % Set a 3-second cooldown
                            
                            % Log the lane change event
                            obj.laneChanges(end+1) = struct('time',obj.t,'id',v.id,'from',oldY,'to',newY);
                        end
                    end
                end
                
                % remove vehicles that left network
                obj.vehicles = obj.vehicles([obj.vehicles.x] <= obj.network.length + 50);

                % logging
                obj.logStep();
            end
        end

        function handleArrivals(obj)
            lam = obj.params.spawn.lambda;
            p = lam * obj.dt;
            if rand() < p
                types = fieldnames(obj.params.spawn.composition);
                probs = cell2mat(struct2cell(obj.params.spawn.composition));
                % Ensure probabilities sum to 1 for robust selection
                probs = probs / sum(probs); 
                
                r = rand();
                idx = find(cumsum(probs) >= r, 1, 'first');
                vtype = types{idx};
                proto = obj.params.spawn.protos.(vtype);
                
                S = struct();
                S.(vtype) = proto;
                S.(vtype).x0 = -5; S.(vtype).y0 = randi(obj.network.numSublanes);
                S.(vtype).v0 = proto.vmax * (0.7 + 0.2*rand()); S.(vtype).t0 = obj.t;
                
                veh = Vehicle(obj.nextId, vtype, S);
                obj.nextId = obj.nextId + 1;
                obj.addVehicle(veh);
            end
        end

        function logStep(obj)
            s.time  = obj.t;
            s.ids   = [obj.vehicles.id];
            s.x     = [obj.vehicles.x];
            s.y     = [obj.vehicles.y];
            s.v     = [obj.vehicles.v];
            s.types = {obj.vehicles.type};
            
            obj.logs{end+1} = s;
        end
    end
end