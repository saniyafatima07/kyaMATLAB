function india_twin_builder_app()
% IndiaTwinBuilder_app_v2
% Recreates the "India Digital Twin Builder" UI closely to the provided mockup.
% Adjusted to be full-screen and resize content dynamically.

    % ---------------------------
    % Colors (hex -> rgb)
    % ---------------------------
    bg      = hex2rgb('#0C1B3D');    % background dark
    panel   = hex2rgb('#15294C');    % panel bg
    primary = hex2rgb('#2B7FFF');    % primary button
    accent  = hex2rgb('#1E62D0');    % accent button
    white   = [1 1 1];
    grayTxt = hex2rgb('#A3B2CC');
    mapBg   = hex2rgb('#213753');    % NEW: Blueish background for map
    
    % ---------------------------
    % Get Screen Size for dynamic layout
    % ---------------------------
    scr_sz = get(0, 'ScreenSize');
    figW = scr_sz(3);
    figH = scr_sz(4);

    % ---------------------------
    % Create UIFigure (Full-screen)
    % ---------------------------
    fig = uifigure('Name','SimuTwin', ...
                   'Position',[1 1 figW figH], ...
                   'Color', bg, 'Resize', 'off');

    % Title bar area (large)
    topH = 96;
    topPanel = uipanel(fig, 'Position', [0 figH-topH figW topH], ...
                       'BackgroundColor', panel, 'BorderType', 'none');

    % Title label centered
    titleLabel = uilabel(topPanel, 'Text', '‍SimuTwin', ...
        'Position', [0 18 figW 60], 'HorizontalAlignment', 'center', ...
        'FontSize', 30, 'FontWeight', 'bold', 'FontColor', white, 'BackgroundColor', panel);

    % ---------------------------
    % Panels: Left / Center / Right
    % ---------------------------
    panelY = 20;
    panelH = figH - topH - (2 * panelY);
    leftW = 300;
    rightW = 280;
    centerW = figW - leftW - rightW - (4 * panelY);
    leftX = panelY;
    centerX = leftX + leftW + panelY;
    rightX = centerX + centerW + panelY;

    leftPanel = uipanel(fig, 'Position', [leftX panelY leftW panelH], ...
                        'BackgroundColor', panel, 'BorderType', 'none');
    centerPanel = uipanel(fig, 'Position', [centerX panelY centerW panelH], ...
                          'BackgroundColor', panel, 'BorderType', 'none');
    rightPanel = uipanel(fig, 'Position', [rightX panelY rightW panelH], ...
                         'BackgroundColor', panel, 'BorderType', 'none');

    % ---------------------------
    % LEFT PANEL content
    % ---------------------------
    % Import button
    importBtn = uibutton(leftPanel, 'push', 'Text', 'Import map', ...
        'Position', [20 panelH-84 260 64], 'FontSize', 20, 'FontWeight', 'normal');
    importBtn.BackgroundColor = primary; importBtn.FontColor = white;
    
    % --- BEGIN ASSET UI ---
    addAssetBtn = uibutton(leftPanel, 'push', 'Text', 'Add Asset', ...
        'Position', [20 panelH-168 260 64], 'FontSize', 20, 'FontWeight', 'normal');
    addAssetBtn.BackgroundColor = primary; addAssetBtn.FontColor = white;

    lblAssets = uilabel(leftPanel, 'Text', 'Select an Asset', ...
        'Position', [20 panelH-210 260 22], 'FontSize', 16, 'FontColor', white);
    
    assetList = uilistbox(leftPanel, ...
        'Position', [20 panelH-400 260 180], ...
        'Items', {'Pothole','Barricade','Rickshaw','Car', 'Two-wheeler', 'Road'}, ...
        'FontSize', 16, 'FontColor', white);
    assetList.BackgroundColor = hex2rgb('#213753');
    assetList.ValueChangedFcn = @(s,e) onAssetSelected(fig, e);
    % --- END ASSET UI ---

    % Load Scene Dropdown
    lblScenes = uilabel(leftPanel, 'Text', 'Load Scene', 'Position', [20 panelH-440 260 22], 'FontSize', 16, 'FontColor', white);
    ddScenes = uidropdown(leftPanel, 'Position', [20 panelH-480 260 36], 'BackgroundColor', hex2rgb('#213753'), 'FontColor', white);
    ddScenes.ValueChangedFcn = @(s,e) onSceneSelected(fig, e);

    % Log Panel at bottom of leftPanel
    logLeftPanel = uipanel(leftPanel, 'Position', [20 20 260 160], 'Title', 'Log', 'BackgroundColor', panel, 'FontSize', 16, 'FontWeight', 'bold');
    logArea = uitextarea(logLeftPanel, 'Position', [8 8 244 120], 'Editable', 'off', 'FontColor', grayTxt, 'Value', {'[--] App started'});

    % ---------------------------
    % CENTER Panel content
    % ---------------------------
    % --- Preview Heading and Axes ---
    pvLabel = uilabel(centerPanel, 'Text', 'Preview', ...
        'Position', [18 panelH-50 200 36], 'FontSize', 22, 'FontWeight', 'bold', 'FontColor', white);
    
    axesH = panelH - 50 - 36 - 20 - 150 - 18;
    ax = uiaxes(centerPanel, 'Position', [18 18+150 centerW-36 axesH], 'BackgroundColor', mapBg);
    ax.XTick = []; ax.YTick = []; ax.Box = 'on';

    % Initial preview content
    cla(ax);
    text(ax, 0.5, 0.5, 'Run RoadRunner to begin', 'HorizontalAlignment', 'center', ...
         'FontSize', 24, 'FontWeight', 'bold', 'Color', grayTxt);
    ax.XLim = [0 1]; ax.YLim = [0 1];
    axis(ax, 'off');
    
    % Asset table at bottom of center panel
    assetTablePanel = uipanel(centerPanel, 'Position', [18 18 centerW-36 150], ...
                              'BackgroundColor', hex2rgb('#213753'), 'Title', 'Assets Added', ...
                              'FontWeight', 'bold', 'FontSize', 14);
    
    assetTable = uitable(assetTablePanel, 'Position', [10 10 centerW-56 120], ...
                         'ColumnName', {'Asset', 'Property 1', 'Property 2', 'Property 3'}, ...
                         'ColumnFormat', {'char', 'char', 'char', 'char'}, ...
                         'ColumnWidth', {'auto', 'auto', 'auto', 'auto'}, ...
                         'RowName', {}, 'Data', []);
    assetTable.BackgroundColor = hex2rgb('#15294C');
    assetTable.ForegroundColor = white;

    % ---------------------------
    % RIGHT Panel content
    % ---------------------------
    simLabel = uilabel(rightPanel, 'Text', 'Simulation', 'Position', [20 panelH-50 220 36], 'FontSize', 22, 'FontWeight', 'bold', 'FontColor', white);

    lblTime = uilabel(rightPanel, 'Text', 'Time of day', 'Position', [20 panelH-90 120 22], 'FontSize', 16, 'FontColor', white);
    ddTime = uidropdown(rightPanel, 'Items', {'Day','Dawn','Night'}, 'Value', 'Day', 'Position', [20 panelH-130 220 36]);

    lblWeather = uilabel(rightPanel, 'Text', 'Weather', 'Position', [20 panelH-168 120 22], 'FontSize', 16, 'FontColor', white);
    ddWeather = uidropdown(rightPanel, 'Items', {'Clear','Rain','Fog'}, 'Value', 'Clear', 'Position', [20 panelH-208 220 36]);

    lblFidelity = uilabel(rightPanel, 'Text', 'Fidelity', 'Position', [20 panelH-246 120 22], 'FontSize', 16, 'FontColor', white);
    ddFidelity = uidropdown(rightPanel, 'Items', {'Kinematic','Dynamics'}, 'Value', 'Kinematic', 'Position', [20 panelH-286 220 36]);
    
    % New Sections for future use
    lblSettings = uilabel(rightPanel, 'Text', 'Settings', 'Position', [20 panelH-324 120 22], 'FontSize', 16, 'FontColor', white);
    settingsPanel = uipanel(rightPanel, 'Position', [20 panelH-390 220 60], 'BackgroundColor', hex2rgb('#213753'), 'BorderType', 'none');
    % -- UI and label change as requested --
    settingsBtn = uibutton(settingsPanel, 'push', 'Text', 'Project Settings', 'Position', [10 10 200 40], ...
        'ButtonPushedFcn', @(s,e) appendLog(logArea, 'Project Settings button pressed. (Non-functional)'));
    settingsBtn.BackgroundColor = accent; settingsBtn.FontColor = white;

    lblBatch = uilabel(rightPanel, 'Text', 'Batch Operations', 'Position', [20 panelH-420 200 22], 'FontSize', 16, 'FontColor', white);
    batchPanel = uipanel(rightPanel, 'Position', [20 panelH-490 220 60], 'BackgroundColor', hex2rgb('#213753'), 'BorderType', 'none');
    % -- UI and label change as requested --
    batchBtn = uibutton(batchPanel, 'push', 'Text', 'Batch Export', 'Position', [10 10 200 40], ...
        'ButtonPushedFcn', @(s,e) appendLog(logArea, 'Batch Export button pressed. (Non-functional)'));
    batchBtn.BackgroundColor = accent; batchBtn.FontColor = white;

    expBtn = uibutton(rightPanel, 'push', 'Text', 'Export to RoadRunner', 'Position', [20 112 220 48], 'FontSize', 17);
    expBtn.BackgroundColor = primary; expBtn.FontColor = white;

    runBtn = uibutton(rightPanel, 'push', 'Text', 'Run RoadRunner', 'Position', [20 42 220 48], 'FontSize', 17);
    runBtn.BackgroundColor = primary; runBtn.FontColor = white;

    % ---------------------------
    % Attach callbacks
    % ---------------------------
    % store handles in appdata
    appdata.ax = ax; 
    appdata.logArea = logArea; 
    appdata.assetTable = assetTable;
    appdata.Assets = {}; 
    appdata.RoadData = []; % Initializing RoadData in appdata
    appdata.LoadedFile = ''; % Initializing LoadedFile in appdata
    appdata.mapBg = mapBg;
    setappdata(fig, 'AppData', appdata);

    importBtn.ButtonPushedFcn = @(s,e) onImport(fig);
    addAssetBtn.ButtonPushedFcn = @(s,e) onAddAsset(fig, assetList);
    expBtn.ButtonPushedFcn    = @(s,e) onExport(fig);
    runBtn.ButtonPushedFcn    = @(s,e) onRun(fig);
    
    % Final UI setup and log update
    appendLog(logArea, 'UI ready. Use Import scenario or Batch add to populate preview.');
    
    try
        scenesFolder = fullfile(pwd, 'Scenes');
        if ~isfolder(scenesFolder)
            appendLog(logArea, 'WARNING: Scenes folder not found.');
            ddScenes.Items = {'No scenes found'};
            ddScenes.Enable = 'off';
        else
            sceneFiles = dir(fullfile(scenesFolder, '*.rrscene'));
            fileNames = {sceneFiles.name};
            if isempty(fileNames)
                appendLog(logArea, 'WARNING: No .rrscene files found in Scenes folder.');
                ddScenes.Items = {'No scenes found'};
                ddScenes.Enable = 'off';
            else
                ddScenes.Items = fileNames;
                ddScenes.Value = fileNames{1};
                appendLog(logArea, sprintf('Found %d scene files. Ready to load.', numel(fileNames)));
            end
        end
    catch ME
        appendLog(logArea, ['Error populating scenes: ' ME.message]);
        ddScenes.Items = {'Error'};
        ddScenes.Enable = 'off';
    end
end

% ---------------------------
% NEW CALLBACK FOR ASSETS
% ---------------------------
function onAssetSelected(fig, event)
    appdata = getappdata(fig, 'AppData');
    logArea = appdata.logArea;
    assetType = event.Value;
    
    appendLog(logArea, ['Selected asset type: ' assetType]);
    
    popFig = uifigure('Name', ['Configure ' assetType], 'Position', [0 0 400 300], 'Visible', 'off');
    centerfig(popFig);

    delete(popFig.Children);
    
    popPanel = uipanel(popFig, 'Position', [10 10 380 280], 'BorderType', 'none', 'BackgroundColor', hex2rgb('#15294C'));
    
    switch assetType
        case 'Pothole'
            lbl1 = uilabel(popPanel, 'Text', 'Hole Width:', 'Position', [20 220 120 22], 'FontColor', hex2rgb('#A3B2CC'));
            ef1 = uieditfield(popPanel, 'numeric', 'Position', [140 220 200 28]);
            lbl2 = uilabel(popPanel, 'Text', 'Area:', 'Position', [20 180 120 22], 'FontColor', hex2rgb('#A3B2CC'));
            ef2 = uieditfield(popPanel, 'numeric', 'Position', [140 180 200 28]);
            
            applyBtn = uibutton(popFig, 'push', 'Text', 'Apply', 'Position', [100 20 200 40]);
            applyBtn.ButtonPushedFcn = @(s,e) onApply_AddAsset(fig, popFig, assetType, ef1, ef2);

        case 'Barricade'
            lbl1 = uilabel(popPanel, 'Text', 'Type:', 'Position', [20 220 120 22], 'FontColor', hex2rgb('#A3B2CC'));
            dd1 = uidropdown(popPanel, 'Items', {'Single', 'Multiple'}, 'Position', [140 220 200 28]);
            lbl2 = uilabel(popPanel, 'Text', 'Distance:', 'Position', [20 180 120 22], 'FontColor', hex2rgb('#A3B2CC'));
            ef2 = uieditfield(popPanel, 'numeric', 'Position', [140 180 200 28]);
            
            applyBtn = uibutton(popFig, 'push', 'Text', 'Apply', 'Position', [100 20 200 40]);
            applyBtn.ButtonPushedFcn = @(s,e) onApply_AddAsset(fig, popFig, assetType, dd1, ef2);
            
        case {'Rickshaw', 'Car', 'Two-wheeler'}
            lbl1 = uilabel(popPanel, 'Text', 'Vehicle Count:', 'Position', [20 220 120 22], 'FontColor', hex2rgb('#A3B2CC'));
            ef1 = uieditfield(popPanel, 'numeric', 'Position', [140 220 200 28]);
            lbl2 = uilabel(popPanel, 'Text', 'Behaviour:', 'Position', [20 180 120 22], 'FontColor', hex2rgb('#A3B2CC'));
            dd1 = uidropdown(popPanel, 'Items', {'Normal', 'Aggressive', 'Erratic'}, 'Position', [140 180 200 28]);
            lbl3 = uilabel(popPanel, 'Text', 'Vehicle Color:', 'Position', [20 140 120 22], 'FontColor', hex2rgb('#A3B2CC'));
            dd2 = uidropdown(popPanel, 'Items', {'Red', 'Blue', 'Green'}, 'Position', [140 140 200 28]);

            applyBtn = uibutton(popFig, 'push', 'Text', 'Apply', 'Position', [100 20 200 40]);
            applyBtn.ButtonPushedFcn = @(s,e) onApply_AddAsset(fig, popFig, assetType, ef1, dd1, dd2);

        case 'Road'
            lbl1 = uilabel(popPanel, 'Text', 'Road Width:', 'Position', [20 220 120 22], 'FontColor', hex2rgb('#A3B2CC'));
            ef1 = uieditfield(popPanel, 'numeric', 'Position', [140 220 200 28]);
            lbl2 = uilabel(popPanel, 'Text', 'Number of Lanes:', 'Position', [20 180 120 22], 'FontColor', hex2rgb('#A3B2CC'));
            ef2 = uieditfield(popPanel, 'numeric', 'Position', [140 180 200 28]);

            applyBtn = uibutton(popFig, 'push', 'Text', 'Apply', 'Position', [100 20 200 40]);
            applyBtn.ButtonPushedFcn = @(s,e) onApply_AddAsset(fig, popFig, assetType, ef1, ef2);
    end
    
    popFig.Visible = 'on';
end

% Helper function to center a figure
function centerfig(fig)
    scr_sz = get(0, 'ScreenSize');
    fig_pos = fig.Position;
    fig_pos(1) = scr_sz(3)/2 - fig_pos(3)/2;
    fig_pos(2) = scr_sz(4)/2 - fig_pos(4)/2;
    fig.Position = fig_pos;
end

function onApply_AddAsset(mainFig, popFig, assetType, varargin)
    % Added try-catch for robustness without changing functionality
    try
        appdata = getappdata(mainFig, 'AppData');
        logArea = appdata.logArea;
        assetTable = appdata.assetTable;
        
        appendLog(logArea, ['--- Asset added: ' assetType ' ---']);
        
        % Fetch properties from pop-up and display in table
        property1 = 'N/A';
        property2 = 'N/A';
        property3 = 'N/A';
        
        % Store all properties in a struct
        assetData = struct('Type', assetType, 'x', [], 'y', []);
        
        switch assetType
            case 'Pothole'
                holeWidth = varargin{1}.Value;
                area = varargin{2}.Value;
                
                assetData.Properties = struct('HoleWidth', holeWidth, 'Area', area);
                
                property1 = sprintf('Width: %.2f', holeWidth);
                property2 = sprintf('Area: %.2f', area);
                
            case 'Barricade'
                barricadeType = varargin{1}.Value;
                distance = varargin{2}.Value;
                
                assetData.Properties = struct('BarricadeType', barricadeType, 'Distance', distance);
                
                property1 = ['Type: ' barricadeType];
                property2 = sprintf('Distance: %.2f', distance);
                
            case {'Rickshaw', 'Car', 'Two-wheeler'}
                vehicleCount = varargin{1}.Value;
                vehicleBehaviour = varargin{2}.Value;
                vehicleColor = varargin{3}.Value;

                assetData.Properties = struct('Count', vehicleCount, 'Behaviour', vehicleBehaviour, 'Color', vehicleColor);
                
                property1 = sprintf('Count: %d', vehicleCount);
                property2 = ['Behaviour: ' vehicleBehaviour];
                property3 = ['Color: ' vehicleColor];
            
            case 'Road'
                roadWidth = varargin{1}.Value;
                numLanes = varargin{2}.Value;
                
                assetData.Properties = struct('Width', roadWidth, 'Lanes', numLanes);
                
                property1 = sprintf('Width: %.2f', roadWidth);
                property2 = sprintf('Lanes: %d', numLanes);
        end
        
        % Generate random coordinates and add to assetData
        if isfield(appdata, 'RoadData') && ~isempty(appdata.RoadData) && ~isempty(appdata.RoadData.x)
            roadData = appdata.RoadData;
            
            % Flatten the cell array of road data to find bounds for a random point
            all_x_flat = vertcat(roadData.x{:});
            all_y_flat = vertcat(roadData.y{:});
            
            if ~isempty(all_x_flat)
                min_x = min(all_x_flat);
                max_x = max(all_x_flat);
                min_y = min(all_y_flat);
                max_y = max(all_y_flat);
                
                assetData.x = min_x + (max_x - min_x) * rand;
                assetData.y = min_y + (max_y - min_y) * rand;
            else
                assetData.x = rand;
                assetData.y = rand;
            end
        else
            assetData.x = rand;
            assetData.y = rand;
        end
        
        % Append new asset to the appdata
        appdata.Assets{end+1} = assetData;
        setappdata(mainFig, 'AppData', appdata);

        % Update table
        currentData = assetTable.Data;
        newData = {assetType, property1, property2, property3};
        
        if isempty(currentData)
            assetTable.Data = newData;
        else
            assetTable.Data = [currentData; newData];
        end
        
        % Add a log message to confirm table update
        appendLog(logArea, 'Table data updated.');
        
        % Force UI update
        drawnow;

        % Update the preview
        updatePreview(mainFig);
        
        % Add a log message to confirm preview update
        appendLog(logArea, 'Preview updated with new asset.');
        
        appendLog(logArea, '-----------------------------');
        delete(popFig);

    catch ME
        appendLog(appdata.logArea, ['ERROR: Apply button failed. ' ME.message]);
        delete(popFig);
    end
end

% NEW FUNCTION: Handles all preview updates in one place
function updatePreview(fig)
    appdata = getappdata(fig, 'AppData');
    ax = appdata.ax;
    
    cla(ax);
    
    if isfield(appdata, 'RoadData') && ~isempty(appdata.RoadData)
        % Redraw the imported map
        roadData = appdata.RoadData;
        
        hold(ax, 'on');
        all_x = cell2mat(roadData.x);
        all_y = cell2mat(roadData.y);
        
        min_x = min(all_x); max_x = max(all_x);
        min_y = min(all_y); max_y = max(all_y);
        
        pad = 0.05 * max([max_x - min_x, max_y - min_y]);
        if pad == 0, pad = 10; end
        
        ax.XLim = [min_x - pad, max_x + pad];
        ax.YLim = [min_y - pad, max_y + pad];
        
        for i = 1:numel(roadData.x)
            plot(ax, roadData.x{i}, roadData.y{i}, 'Color', hex2rgb('#3A4E6C'), 'LineWidth', 15);
            plot(ax, roadData.x{i}, roadData.y{i}, '--', 'Color', hex2rgb('#A3B2CC'), 'LineWidth', 2);
        end
        
        % Plot all existing assets from the appdata struct
        for i = 1:numel(appdata.Assets)
            asset = appdata.Assets{i};
            plot(ax, asset.x, asset.y, 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'MarkerSize', 10);
            text(ax, asset.x, asset.y, asset.Type, 'Color', 'r', 'FontSize', 12, 'VerticalAlignment', 'bottom');
        end
        
        hold(ax, 'off');
        axis(ax, 'equal');
        axis(ax, 'off');
        
    else
        % No map loaded, show default message
        text(ax, 0.5, 0.5, 'Run RoadRunner to begin', 'HorizontalAlignment', 'center', ...
             'FontSize', 24, 'FontWeight', 'bold', 'Color', appdata.mapBg);
        ax.XLim = [0 1]; ax.YLim = [0 1];
        axis(ax, 'off');
    end
    
    drawnow;
end


% ---------------------------
% Callbacks (simple, safe)
% ---------------------------
function onSceneSelected(fig, event)
    appdata = getappdata(fig, 'AppData');
    logArea = appdata.logArea;
    ax = appdata.ax;
    
    selectedSceneFile = event.Value;
    
    cla(ax);
    text(ax, 0.5, 0.5, 'Loading Scene...', 'HorizontalAlignment', 'center', ...
         'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#A3B2CC'));
    axis(ax, 'off');
    ax.XLim = [0 1]; ax.YLim = [0 1];
    drawnow;

    if isequal(selectedSceneFile, 'No scenes found')
        appendLog(logArea, 'No scene selected. Aborting.');
        return;
    end
    
    scenePath = fullfile(pwd, 'Scenes', selectedSceneFile);
    
    appendLog(logArea, ['Calling Python backend to load scene: ' selectedSceneFile]);
    
    try
        pythonScriptPath = 'C:\ILoveCoding\kyaMATLAB\kyaMATLAB';
        if count(py.sys.path, pythonScriptPath) == 0
            insert(py.sys.path, int64(0), pythonScriptPath);
        end
        
        py.importlib.invalidate_caches();
        
        control_rr = py.importlib.import_module('control_rr');
        result = control_rr.load_scene_from_file(scenePath);
        
        isSuccessful = logical(result{1});
        message = char(result{2});
        
        appendLog(logArea, 'SUCCESS: Scene loaded and processed.');
        cla(ax);
        text(ax, 0.5, 0.5, 'Scene Loaded!', 'HorizontalAlignment', 'center', ...
             'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#3CCF4E'));
        axis(ax, 'off');
        ax.XLim = [0 1]; ax.YLim = [0 1];
        
    catch ME
        appendLog(logArea, ['Python Load Scene Error: ' ME.message]);
        cla(ax);
        text(ax, 0.5, 0.5, 'An error occurred.', 'HorizontalAlignment', 'center', ...
             'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#E03C32'));
        axis(ax, 'off');
        ax.XLim = [0 1]; ax.YLim = [0 1];
    end
end

function onImport(fig)
    appdata = getappdata(fig, 'AppData');
    logArea = appdata.logArea;
    ax = appdata.ax;
    
    cla(ax);
    text(ax, 0.5, 0.5, 'Waiting for file selection...', 'HorizontalAlignment', 'center', ...
         'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#A3B2CC'));
    axis(ax, 'off');
    ax.XLim = [0 1]; ax.YLim = [0 1];
    drawnow;
    appendLog(logArea, 'Importing new map. Select a file.');

    [f,p] = uigetfile({'*.osm;*.xodr', 'OpenDRIVE/OpenStreetMap Files (*.osm, *.xodr)'}, ...
        'Select Road Network');
    
    if isequal(f, 0)
        appendLog(logArea, 'Import canceled.');
        cla(ax);
        text(ax, 0.5, 0.5, 'Import canceled.', 'HorizontalAlignment', 'center', ...
             'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#A3B2CC'));
        axis(ax, 'off');
        ax.XLim = [0 1]; ax.YLim = [0 1];
        return;
    end
    
    filePath = fullfile(p, f);
    appendLog(logArea, ['Selected file: ' filePath]);
    disp(['[DEBUG] File Path after import: ' filePath]); % DEBUG
    
    try
        appendLog(logArea, 'Reading file...');
        cla(ax);
        text(ax, 0.5, 0.5, 'Parsing Map Data...', 'HorizontalAlignment', 'center', ...
             'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#A3B2CC'));
        axis(ax, 'off');
        ax.XLim = [0 1]; ax.YLim = [0 1];
        drawnow;
        
        [~, ~, ext] = fileparts(filePath);
        roadData = [];
        
        if strcmpi(ext, '.osm')
            xdoc = xmlread(filePath);
            nodes = xdoc.getElementsByTagName('node');
            ways = xdoc.getElementsByTagName('way');
            
            lat_lon_map = containers.Map;
            for i = 0:nodes.getLength-1
                node = nodes.item(i);
                id = char(node.getAttribute('id'));
                lat = str2double(node.getAttribute('lat'));
                lon = str2double(node.getAttribute('lon'));
                lat_lon_map(id) = [lat, lon];
            end
            
            roadData.x = {};
            roadData.y = {};
            for i = 0:ways.getLength-1
                way = ways.item(i);
                nd_refs = way.getElementsByTagName('nd');
                x_pts = []; y_pts = [];
                for j = 0:nd_refs.getLength-1
                    nd_ref = nd_refs.item(j);
                    node_id = char(nd_ref.getAttribute('ref'));
                    if isKey(lat_lon_map, node_id)
                        lat_lon = lat_lon_map(node_id);
                        [x, y] = deg2utm(lat_lon(1), lat_lon(2));
                        x_pts = [x_pts, x];
                        y_pts = [y_pts, y];
                    end
                end
                if ~isempty(x_pts)
                    roadData.x{end+1} = x_pts;
                    roadData.y{end+1} = y_pts;
                end
            end
            appendLog(logArea, sprintf('OSM file parsed: %d nodes, %d ways', lat_lon_map.Count, ways.getLength));
            
        elseif strcmpi(ext, '.xodr')
            xdoc = xmlread(filePath);
            roads = xdoc.getElementsByTagName('road');
            roadData.x = {}; roadData.y = {};
            for i = 0:roads.getLength-1
                road = roads.item(i);
                planView = road.getElementsByTagName('planView').item(0);
                geometry = planView.getElementsByTagName('geometry').item(0);
                
                if ~isempty(geometry)
                    x_start = str2double(geometry.getAttribute('s'));
                    y_start = str2double(geometry.getAttribute('y'));
                    x_pts = [x_start]; y_pts = [y_start];
                    roadData.x{end+1} = x_pts;
                    roadData.y{end+1} = y_pts;
                end
            end
            appendLog(logArea, sprintf('XODR file parsed: %d roads found', roads.getLength));
        else
            appendLog(logArea, 'Unsupported file type for preview. Cannot display.');
            cla(ax);
            text(ax, 0.5, 0.5, 'Unsupported File Type', 'HorizontalAlignment', 'center', ...
                 'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#E03C32'));
            axis(ax, 'off');
            ax.XLim = [0 1]; ax.YLim = [0 1];
            return;
        end
        
        if isempty(roadData.x)
            appendLog(logArea, 'No road data found in file.');
            cla(ax);
            text(ax, 0.5, 0.5, 'No Road Data Found', 'HorizontalAlignment', 'center', ...
                 'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#A3B2CC'));
            axis(ax, 'off');
            ax.XLim = [0 1]; ax.YLim = [0 1];
        else
            appdata.RoadData = roadData;
            appdata.LoadedFile = filePath;
            setappdata(fig, 'AppData', appdata);
            appendLog(logArea, 'File successfully processed! Ready for export.');
            
            % Update preview after successful import
            updatePreview(fig);
        end
        
    catch ME
        appendLog(logArea, ['Error reading or parsing file: ' ME.message]);
        cla(ax);
        text(ax, 0.5, 0.5, 'Error Parsing File', 'HorizontalAlignment', 'center', ...
             'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#E03C32'));
        axis(ax, 'off');
        ax.XLim = [0 1]; ax.YLim = [0 1];
    end
end

function onExport(fig)
    appdata = getappdata(fig, 'AppData'); 
    logArea = appdata.logArea;
    ax = appdata.ax;

    disp(['[DEBUG] LoadedFile for Export: ' appdata.LoadedFile]); % DEBUG

    if ~isfield(appdata, 'LoadedFile') || isempty(appdata.LoadedFile)
        appendLog(logArea, 'ERROR: No file imported! Use Import Scenario first.');
        return;
    end
    
    loadedFilePath = appdata.LoadedFile;
    appendLog(logArea, ['Exporting to RoadRunner: ' loadedFilePath]);
    
    cla(ax);
    text(ax, 0.5, 0.5, 'Exporting Map...', 'HorizontalAlignment', 'center', ...
         'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#A3B2CC'));
    axis(ax, 'off');
    ax.XLim = [0 1]; ax.YLim = [0 1];
    drawnow;
    
    try
        pythonScriptPath = 'C:\ILoveCoding\kyaMATLAB\kyaMATLAB';
        if count(py.sys.path, pythonScriptPath) == 0
            insert(py.sys.path, int64(0), pythonScriptPath);
        end
        
        py.importlib.invalidate_caches();
        control_rr = py.importlib.import_module('control_rr');
        result = control_rr.export_to_roadrunner(char(loadedFilePath));
        
        isSuccessful = logical(result{1});
        message = char(result{2});
        
        if isSuccessful
            appendLog(logArea, 'SUCCESS: ' + string(message));
            cla(ax);
            text(ax, 0.5, 0.5, 'Map Exported Successfully!', 'HorizontalAlignment', 'center', ...
                 'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#3CCF4E'));
            axis(ax, 'off');
            ax.XLim = [0 1]; ax.YLim = [0 1];
        else
            appendLog(logArea, 'FAILED: ' + string(message));
            cla(ax);
            text(ax, 0.5, 0.5, 'Export Failed.', 'HorizontalAlignment', 'center', ...
                 'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#E03C32'));
            axis(ax, 'off');
            ax.XLim = [0 1]; ax.YLim = [0 1];
        end
        
    catch ME
        appendLog(logArea, ['Python Export Error: ' ME.message]);
        cla(ax);
        text(ax, 0.5, 0.5, 'An error occurred.', 'HorizontalAlignment', 'center', ...
             'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#E03C32'));
        axis(ax, 'off');
        ax.XLim = [0 1]; ax.YLim = [0 1];
    end
end

function onRun(fig)
    appdata = getappdata(fig, 'AppData'); 
    logArea = appdata.logArea;
    ax = appdata.ax;

    appendLog(logArea, 'Starting RoadRunner application...');
    
    cla(ax);
    text(ax, 0.5, 0.5, 'Launching RoadRunner...', 'HorizontalAlignment', 'center', ...
         'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#A3B2CC'));
    axis(ax, 'off');
    ax.XLim = [0 1]; ax.YLim = [0 1];
    drawnow;

    try
        pythonScriptPath = 'C:\ILoveCoding\kyaMATLAB\kyaMATLAB';
        if count(py.sys.path, pythonScriptPath) == 0
            insert(py.sys.path, int64(0), pythonScriptPath);
        end
        py.importlib.invalidate_caches();

        control_rr = py.importlib.import_module('control_rr');
        result = control_rr.launch_roadrunner();
        
        isSuccessful = logical(result{1});
        message = char(result{2});

        if isSuccessful
            appendLog(logArea, 'SUCCESS: ' + string(message));
            cla(ax);
            text(ax, 0.5, 0.5, 'RoadRunner Running!', 'HorizontalAlignment', 'center', ...
                 'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#3CCF4E'));
            axis(ax, 'off');
            ax.XLim = [0 1]; ax.YLim = [0 1];
        else
            appendLog(logArea, 'FAILED: ' + string(message));
            cla(ax);
            text(ax, 0.5, 0.5, 'Failed to Launch.', 'HorizontalAlignment', 'center', ...
                 'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#E03C32'));
            axis(ax, 'off');
            ax.XLim = [0 1]; ax.YLim = [0 1];
        end

    catch ME
        appendLog(logArea, ['Failed to start RoadRunner: ' ME.message]);
        cla(ax);
        text(ax, 0.5, 0.5, 'An error occurred.', 'HorizontalAlignment', 'center', ...
             'FontSize', 18, 'FontWeight', 'bold', 'Color', hex2rgb('#E03C32'));
        axis(ax, 'off');
        ax.XLim = [0 1]; ax.YLim = [0 1];
    end
end

% ---------------------------
% small utilities
% ---------------------------
function appendLog(logArea, txt)
    t = datestr(now, 'HH:MM:SS');
    try
        logArea.Value = [{sprintf('[%s] %s', t, txt)}; logArea.Value];
    catch
        fprintf('[%s] %s\n', t, txt);
    end
end

function rgb = hex2rgb(hex)
    if isempty(hex), rgb = [0 0 0]; return; end
    if hex(1) == '#', hex = hex(2:end); end
    r = double(hex2dec(hex(1:2))) / 255;
    g = double(hex2dec(hex(3:4))) / 255;
    b = double(hex2dec(hex(5:6))) / 255;
    rgb = [r g b];
end

function [x, y] = deg2utm(lat, lon)
    % A simplified conversion for plotting purposes
    
    % Constants for WGS84
    a = 6378137; % Earth radius
    e = 0.081819190842622;
    k0 = 0.9996;
    
    lon_rad = deg2rad(lon);
    lat_rad = deg2rad(lat);
    
    lon_origin = floor((lon + 180)/6)*6 - 180 + 3;
    lon_origin_rad = deg2rad(lon_origin);
    
    e2 = e^2;
    e4 = e2^2;
    e6 = e2^3;
    
    n = a / sqrt(1 - e2 * sin(lat_rad)^2);
    t = tan(lat_rad)^2;
    c = e2 / (1 - e2) * cos(lat_rad)^2;
    
    A = cos(lat_rad) * (lon_rad - lon_origin_rad);
    
    M = a * ( (1 - e2/4 - 3*e4/64 - 5*e6/256) * lat_rad ...
        - (3*e2/8 + 3*e4/32 + 45*e6/1024) * sin(2*lat_rad) ...
        + (15*e4/256 + 45*e6/1024) * sin(4*lat_rad) ...
        - (35*e6/3072) * sin(6*lat_rad) );
    
    x = k0 * n * (A + (1-t+c)*A^3/6 + (5-18*t+t^2+72*c-58*e2)*A^5/120) + 500000;
    y = k0 * (M + n*tan(lat_rad)*(A^2/2 + (5-t+9*c+4*c^2)*A^4/24 + (61-58*t+t^2+600*c-330*e2)*A^6/720));
    
    if lat < 0
        y = y + 10000000;
    end
end