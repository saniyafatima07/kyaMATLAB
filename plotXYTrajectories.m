% run_animation.m
% This script runs a full traffic simulation and then creates a bird's-eye
% view animation where vehicles are color-coded by their real-time
% acceleration and deceleration.

clearvars; close all;

%% =====================================================================
%  PART 1: SIMULATION SETUP (Based on run_mixed.m)
%  =====================================================================
fprintf('--- Part 1: Setting up the traffic simulation ---\n');

% --- Simulation Parameters ---
params.dt = 0.1;   % Time step in seconds
params.T  = 120;   % Total simulation time in seconds
params.lateralTol = 1.6; % Lateral tolerance for leader finding

% --- Behavioral Model Parameters ---
params.IDM.s0 = 1.0; params.IDM.T = 1.2; params.IDM.a = 1.0; params.IDM.b = 2.0; params.IDM.delta = 4;
params.IDM.lookAhead = 200;
params.lateral.maxOffset = 1;
params.lateral.safetyHeadwayFront = 3; 
params.lateral.safetyHeadwayBack  = 2;
params.lateral.timeGapFront = 0.8;
params.lateral.timeGapBack = 0.4;
params.lateral.probBase = 0.6;
params.lateral.lookAhead = 50;
params.lateral.lookBack = 10;
params.lateral.frustrationThresh = 0.12;
params.lateral.allow2WGapFactor = 0.35;
params.lateral.incentiveSpeedDelta = 1.5;

% --- Spawning Parameters ---
params.spawn.lambda = 0.7;
params.spawn.composition.car = 0.60;
params.spawn.composition.tw  = 0.40;

% --- Vehicle Prototypes ---
protos.car.length = 4.5; protos.car.width = 1.8; protos.car.vmax = 13.9; protos.car.amax=2; protos.car.bmax=4; protos.car.headway=1.2; protos.car.driver = struct('laneChangeProb',0.6);
protos.tw.length = 2.0; protos.tw.width = 0.8; protos.tw.vmax = 8.0; protos.tw.amax=1.5; protos.tw.bmax=3; protos.tw.headway=0.8; protos.tw.driver = struct('laneChangeProb',0.8);
params.spawn.protos = protos;

% --- Build Road Network ---
road = RoadNetwork(400, 5, 10);
road.obstacles(1) = struct('x_start',300,'x_end',320,'factor',0.4);

% --- Create Simulator and Seed Vehicles ---
sim = TrafficSimulator(road, params);
sim.addVehicle(Vehicle(1, 'car', struct('car',struct('length',4.5,'width',1.8,'vmax',13.9,'amax',2,'bmax',4,'headway',1.2,'driver',struct('laneChangeProb',0.6),'x0',50,'y0',2,'v0',10,'t0',0))));
sim.addVehicle(Vehicle(2, 'tw', struct('tw',struct('length',2.0,'width',0.8,'vmax',8.0,'amax',1.5,'bmax',3,'headway',0.8,'driver',struct('laneChangeProb',0.8),'x0',30,'y0',3,'v0',7,'t0',0))));
sim.nextId = 3;

%% =====================================================================
%  PART 2: RUN THE SIMULATION
%  =====================================================================
fprintf('--- Part 2: Running simulation for %.1f seconds... ---\n', params.T);
sim.run();
fprintf('Simulation complete. Found %d log steps.\n', numel(sim.logs));

%% =====================================================================
%  PART 3: BIRD'S-EYE VIEW VISUALIZATION (MODIFIED)
%  =====================================================================
fprintf('--- Part 3: Starting bird''s-eye view animation with acceleration coloring... ---\n');

% --- Setup the Figure and Static Background ---
fig = figure('Name', 'Bird''s-Eye Traffic Animation', 'Position', [100, 100, 1200, 500]);
ax = axes('Parent', fig);
hold(ax, 'on');

roadWidth = sim.network.numSublanes * sim.network.sublaneWidth;
rectangle(ax, 'Position', [0, 0, sim.network.length, roadWidth], 'FaceColor', [0.6 0.6 0.6], 'EdgeColor', 'none');
for i = 1:sim.network.numSublanes-1
    y_line = i * sim.network.sublaneWidth;
    plot(ax, [0, sim.network.length], [y_line, y_line], 'w--', 'LineWidth', 0.5);
end
for i = 1:numel(sim.network.obstacles)
    obs = sim.network.obstacles(i);
    patch(ax, [obs.x_start, obs.x_end, obs.x_end, obs.x_start], [0, 0, roadWidth, roadWidth], 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
end

axis(ax, 'equal');
xlabel(ax, 'Longitudinal Position (m)');
ylabel(ax, 'Lateral Position (m)');
grid(ax, 'on');
axis(ax, [0, sim.network.length, 0, roadWidth]);

% --- NEW: Define an acceleration colormap ---
% Red (braking) -> Green (coasting) -> Yellow (accelerating)
accel_colors = [1 0 0; 0.1 1 0.1; 1 1 0]; 
accel_map = interp1([-3, 0, 2], accel_colors, linspace(-3, 2, 256), 'linear');
colormap(ax, accel_map);
c = colorbar(ax);
c.Label.String = 'Acceleration (m/s^2)';
caxis(ax, [-3 2]); % Set color limits for braking and acceleration

% --- Main Animation Loop ---
vehiclePatches = [];
timeText = text(ax, 10, roadWidth * 0.9, '', 'Color', 'white', 'FontSize', 14);
v_prev = containers.Map('KeyType','double','ValueType','double'); % Map to store previous velocities

for step = 1:numel(sim.logs)
    if ~isempty(vehiclePatches), delete(vehiclePatches); vehiclePatches = []; end
    
    data = sim.logs{step};
    if isempty(data) || ~isfield(data, 'x'), continue; end
    
    for i = 1:length(data.x)
        id = data.ids(i);
        
        % --- MODIFIED: Calculate acceleration and determine color ---
        accel = 0; % Default for first appearance
        if isKey(v_prev, id)
            accel = (data.v(i) - v_prev(id)) / params.dt;
        end
        v_prev(id) = data.v(i); % Store current velocity for the next step
        
        % Clamp acceleration value for stable coloring
        accel_clamped = max(-3, min(2, accel));
        
        % Map the acceleration to a color
        color_idx = round(1 + 255 * (accel_clamped - (-3)) / (2 - (-3)));
        veh_color = accel_map(color_idx, :);
        
        % --- Draw the vehicle patch with the dynamic color ---
        proto = params.spawn.protos.(data.types{i});
        x_center = data.x(i);
        y_center = (data.y(i) - 0.5) * sim.network.sublaneWidth;
        
        half_len = proto.length / 2;
        half_wid = proto.width / 2;
        
        x_corners = [x_center-half_len, x_center+half_len, x_center+half_len, x_center-half_len];
        y_corners = [y_center-half_wid, y_center-half_wid, y_center+half_wid, y_center+half_wid];
        
        h = patch(ax, x_corners, y_corners, veh_color, 'EdgeColor', 'k', 'LineWidth', 1);
        vehiclePatches(end+1) = h;
    end
    
    set(timeText, 'String', sprintf('Time: %.2f s', data.time));
    pause(params.dt * 0.1);
    drawnow;
end

title(ax, sprintf('Animation Complete (t = %.2f s)', sim.t));
fprintf('--- Animation finished ---\n');