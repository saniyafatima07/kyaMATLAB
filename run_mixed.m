% Mixed scenario runner with lateral moves & arrivals
clearvars; close all;
% simulation params
params.dt = 0.2;
params.T  = 300; % 5 minutes
params.lateralTol = 1.6; % m
% IDM params
params.IDM.s0 = 1.0; params.IDM.T = 1.2; params.IDM.a = 1.0; params.IDM.b = 2.0; params.IDM.delta = 4;
params.IDM.lookAhead = 200;
% lateral params
params.lateral.maxOffset = 1;
params.lateral.safetyHeadwayFront = 6;
params.lateral.safetyHeadwayBack = 4;
params.lateral.incentiveSpeedDelta = 1.5;
params.lateral.probBase = 0.6;
params.lateral.lookAhead = 50;
params.lateral = params.lateral;
params.lateralTol = 1.6;
params.lateral.maxOffset = 1;
params.lateral.lookAhead = 50;
params.lateral.lookBack = 10;
params.lateral.frustrationThresh = 0.12;
params.lateral.safetyHeadwayFront = 3; % meters
params.lateral.safetyHeadwayBack  = 2; % meters
params.lateral.timeGapFront = 0.8; % s
params.lateral.timeGapBack = 0.4;  % s
params.lateral.probBase = 0.55;
params.lateral.allow2WGapFactor = 0.35;

% spawn settings
params.spawn.lambda = 0.6; % veh/sec ~2160 veh/hr (total)
% composition (must sum to 1)
params.spawn.composition.car = 0.5;
params.spawn.composition.tw  = 0.5;
params.spawn.composition.truck= 0.15;
params.spawn.composition.bus  = 0.10;

% prototypes
protos.car.length = 4.5; protos.car.width = 1.8; protos.car.vmax = 13.9; protos.car.amax=2; protos.car.bmax=4; protos.car.headway=1.2; protos.car.driver = struct('laneChangeProb',0.6);
protos.tw.length = 2.0; protos.tw.width = 0.8; protos.tw.vmax = 8.0; protos.tw.amax=1.5; protos.tw.bmax=3; protos.tw.headway=0.8; protos.tw.driver = struct('laneChangeProb',0.8);
protos.truck.length = 10; protos.truck.width = 2.4; protos.truck.vmax = 10.0; protos.truck.amax=1; protos.truck.bmax=2.5; protos.truck.headway=2.0; protos.truck.driver = struct('laneChangeProb',0.2);
protos.bus.length = 12; protos.bus.width = 2.5; protos.bus.vmax = 10.0; protos.bus.amax=1; protos.bus.bmax=2.5; protos.bus.headway=2.0; protos.bus.driver = struct('laneChangeProb',0.25);
params.spawn.protos = protos;

% build network
road = RoadNetwork(1000, 4, 1.6);
% add an obstacle patch (pothole lane-specific effect implemented as factor)
road.obstacles(1) = struct('x_start',200,'x_end',220,'factor',0.5);
road.obstacles(2) = struct('x_start',500,'x_end',520,'factor',0.7);

% create simulator
sim = TrafficSimulator(road, params);

% seed a few mixed vehicles at t=0
types = fieldnames(params.spawn.composition);
weights = cellfun(@(t) params.spawn.composition.(t), types);
weights = weights / sum(weights); % normalize

for i=1:12
    % pick a random type based on weights
    t = types{find(rand <= cumsum(weights),1,'first')};
    p = protos.(t);
    
    % create prototype struct for Vehicle
    S = struct(); 
    S.(t) = p; 
    S.(t).x0 = -(i-1)*8;
    S.(t).y0 = randi(road.numSublanes);
    S.(t).v0 = p.vmax*0.7;
    S.(t).t0 = 0;
    
    v = Vehicle(sim.nextId, t, S);
    sim.nextId = sim.nextId + 1;
    sim.addVehicle(v);
end


% run
sim.run();
disp('Vehicle types at first timestep:');
disp(sim.logs{1}.types);

% simple analysis plots
% plot trajectories of first N vehicles
N = min(40, length(sim.logs{1}.ids));
figure; hold on;
% reconstruct per vehicle trajectories
allIds = unique( cell2mat( cellfun(@(s) s.ids, sim.logs, 'UniformOutput', false) ) );
N = min(40, numel(allIds));

% Define colors for vehicle types
cmap = containers.Map( ...
    {'tw','car','lcv','truck','bus'}, ...
    {[0.2 0.8 1.0],[0 0.7 0],[0.9 0.5 0],[0.8 0 0],[0.5 0 0.9]} );

figure; hold on;

for id = allIds(1:N)
    tt = [];
    xx = [];
    col = [0 0 0]; % default black
    
    for k = 1:numel(sim.logs)
        ids_k = sim.logs{k}.ids;
        idx = find(ids_k == id,1);
        if ~isempty(idx)
            tt(end+1) = sim.logs{k}.time;
            xx(end+1) = sim.logs{k}.x(idx);
            
            if k == 1  % capture vehicle type from first timestep
                vehType = sim.logs{k}.types{idx};
                if isKey(cmap, vehType)
                    col = cmap(vehType);
                end
            end
        end
    end
    
    if ~isempty(xx)
        plot(tt, xx, 'Color', col, 'LineWidth', 1.2);
    end
end

xlabel('Time (s)');
ylabel('Position x (m)');
title('Vehicle trajectories (colored by type)');
grid on;