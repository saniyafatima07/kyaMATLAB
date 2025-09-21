% visualizeTraffic.m
% Animates traffic simulation with vehicles as rectangles on a road network
% Assumes sim.logs contains: time, ids, x, y, v, types
% Requires network (RoadNetwork or struct) and params (simulation parameters)

function visualizeTraffic(sim, network, params)
    % Input validation
    if nargin < 3
        error('Not enough input arguments. Usage: visualizeTraffic(sim, network, params)');
    end
    if ~isfield(sim, 'logs') || isempty(sim.logs)
        error('sim.logs is empty or missing. Ensure simulation has run.');
    end
    if ~isfield(network, 'numSublanes') || ~isfield(network, 'sublaneWidth') || ~isfield(network, 'length')
        error('network must have numSublanes, sublaneWidth, and length fields.');
    end
    if ~isfield(params, 'dt') || ~isfield(params, 'spawn') || ~isfield(params.spawn, 'protos')
        error('params must have dt and spawn.protos fields.');
    end

    % Extract logs
    logs = sim.logs;
    numSteps = length(logs);
    disp(['Visualizing ', num2str(numSteps), ' simulation steps.']);

    % Initialize figure
    fig = figure('Position', [100, 100, 800, 400]);
    hold on;
    axis equal;
    xlabel('Longitudinal Position (m)');
    ylabel('Sublane Index');
    title('Traffic Simulation Animation');
    grid on;

    % Draw road (gray background)
    roadWidth = network.numSublanes * network.sublaneWidth;
    rectangle('Position', [0, 0, network.length, roadWidth], ...
              'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');

    % Draw sublane lines
    for y = 0.5:1:network.numSublanes
        plot([0, network.length], [y * network.sublaneWidth, y * network.sublaneWidth], ...
             'k--', 'LineWidth', 0.5);
    end
    axis([0, network.length, -0.5, roadWidth + 0.5]);

    % Vehicle type styles (color and size from params.spawn.protos)
    types = fieldnames(params.spawn.protos);
    vehicleStyles = struct();
    colors = [0 0 1; 1 0 0; 0 0.5 0; 0 1 1; 1 0 1]; % Blue, Red, Green, Cyan, Magenta
    for i = 1:length(types)
        vtype = types{i};
        vehicleStyles.(vtype).color = colors(mod(i-1, size(colors,1))+1, :);
        vehicleStyles.(vtype).length = params.spawn.protos.(vtype).length;
        vehicleStyles.(vtype).width = params.spawn.protos.(vtype).width;
    end

    % Animation loop
    for step = 1:numSteps
        % Clear previous vehicle patches
        cla;
        % Redraw road and sublane lines
        rectangle('Position', [0, 0, network.length, roadWidth], ...
                  'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');
        for y = 0.5:1:network.numSublanes
            plot([0, network.length], [y * network.sublaneWidth, y * network.sublaneWidth], ...
                 'k--', 'LineWidth', 0.5);
        end

        % Get current step data
        data = logs{step};
        if isempty(data) || ~isfield(data, 'x') || ~isfield(data, 'y') || ~isfield(data, 'types')
            warning(['Invalid data at step ', num2str(step), '. Skipping.']);
            continue;
        end
        x = data.x;
        y = data.y;
        types = data.types;
        t = data.time;

        % Plot vehicles as rectangles
        for i = 1:length(x)
            vtype = types{i};
            if ~isfield(vehicleStyles, vtype)
                vtype = types{1}; % Default to first type if unknown
            end
            style = vehicleStyles.(vtype);
            % Center rectangle at (x, y * sublaneWidth)
            xPos = x(i) - style.length / 2;
            yPos = y(i) * network.sublaneWidth - style.width / 2;
            rectangle('Position', [xPos, yPos, style.length, style.width], ...
                      'FaceColor', style.color, 'EdgeColor', 'k', 'LineWidth', 0.5);
        end

        % Update title with current time
        title(sprintf('Traffic Simulation at t = %.2f s', t));

        % Set axis limits
        axis([0, network.length, -0.5, roadWidth + 0.5]);

        % Pause for animation
        pause(params.dt * 0.5); % Adjustable speed
        drawnow limitrate;
    end

    hold off;
    disp('Animation complete.');
end