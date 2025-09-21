% visualizeTraffic.m
% Animates vehicles from TrafficSimulator logs as rectangles on a road network
% Includes obstacles from RoadNetwork and vehicle types from run_mixed.m
% Assumes sim.logs contains time, ids, x, y, v, types from TrafficSimulator
% Requires RoadNetwork properties (numSublanes, sublaneWidth, length, obstacles)

function visualizeTraffic(sim, frameRate)
    % Default frame rate (frames per second)
    if nargin < 2
        frameRate = 10;
    end
    dtDisplay = 1 / frameRate;

    % Extract network properties
    numSublanes = sim.network.numSublanes;
    sublaneWidth = sim.network.sublaneWidth;
    roadLength = sim.network.length;
    obstacles = sim.network.obstacles;

    % Vehicle visualization properties (aligned with run_mixed.m)
    vehicleProps = struct(...
        'car', struct('color', [0, 0.7, 0], 'length', 4.5, 'width', 1.8), ... % Green
        'tw', struct('color', [0.2, 0.8, 1.0], 'length', 2.0, 'width', 0.8), ... % Cyan
        'truck', struct('color', [0.9, 0.5, 0], 'length', 10, 'width', 2.4), ... % Orange
        'bus', struct('color', [0.5, 0, 0.9], 'length', 12, 'width', 2.5)); % Purple

    % Initialize figure
    figure('Name', 'Traffic Simulation Visualization', 'Position', [100, 100, 1200, 400]);
    hold on;
    axis equal;
    axis([0, roadLength, 0, numSublanes * sublaneWidth]);
    xlabel('Longitudinal Position (m)');
    ylabel('Lateral Position (m)');
    title('Traffic Simulation');
    
    % Draw road (gray background)
    rectangle('Position', [0, 0, roadLength, numSublanes * sublaneWidth], ...
              'FaceColor', [0.7, 0.7, 0.7], 'EdgeColor', 'none');
    
    % Draw obstacles (semi-transparent red patches)
    for i = 1:length(obstacles)
        rectangle('Position', [obstacles(i).x_start, 0, obstacles(i).x_end - obstacles(i).x_start, numSublanes * sublaneWidth], ...
                  'FaceColor', [1, 0, 0, 0.3], 'EdgeColor', 'none');
        text(obstacles(i).x_start + 10, numSublanes * sublaneWidth / 2, sprintf('Obstacle (%.1f)', obstacles(i).factor), ...
             'Color', 'r', 'FontSize', 8);
    end
    
    % Draw sublane lines
    for i = 1:numSublanes-1
        y = i * sublaneWidth;
        plot([0, roadLength], [y, y], 'k--', 'LineWidth', 0.5);
    end
    grid on;
    box on;

    % Animation loop
    for t = 1:length(sim.logs)
        % Clear previous vehicle patches (except road, obstacles, and lines)
        children = get(gca, 'Children');
        for c = children'
            if strcmp(get(c, 'Type'), 'rectangle') && ~strcmp(get(c, 'FaceColor'), [0.7, 0.7, 0.7]) && ~any(get(c, 'FaceColor') == [1, 0, 0, 0.3])
                delete(c);
            elseif strcmp(get(c, 'Type'), 'text') % Remove previous text labels
                delete(c);
            end
        end

        % Current time step data
        log = sim.logs{t};
        x = log.x;
        y = log.y;
        types = log.types;
        v = log.v;

        % Plot each vehicle as a rectangle
        for i = 1:length(x)
            vtype = types{i};
            if ~isfield(vehicleProps, vtype)
                warning('Unknown vehicle type: %s, using default car properties', vtype);
                vtype = 'car';
            end
            props = vehicleProps.(vtype);
            
            % Convert sublane index (y) to lateral position (meters)
            y_pos = (y(i) - 0.5) * sublaneWidth; % Center of sublane
            x_pos = x(i); % Rear of vehicle
            
            % Draw vehicle as rectangle (position is bottom-left corner)
            rectangle('Position', [x_pos, y_pos - props.width/2, props.length, props.width], ...
                      'FaceColor', props.color, 'EdgeColor', 'k');
            
            % Display speed and ID
            text(x_pos + props.length/2, y_pos, sprintf('ID:%d\n%.1f m/s', log.ids(i), v(i)), ...
                 'HorizontalAlignment', 'center', 'FontSize', 8, 'Color', 'k');
        end

        % Update title with current time
        title(sprintf('Traffic Simulation at t = %.2f s', log.time));

        % Pause for animation
        pause(dtDisplay);
        drawnow;
    end

    hold off;
end