function india_twin_builder_app()
% IndiaTwinBuilder_app_v2
% Recreates the "India Digital Twin Builder" UI closely to the provided mockup.
% Run by calling IndiaTwinBuilder_app_v2 from the MATLAB command window.

    % ---------------------------
    % Colors (hex -> rgb)
    % ---------------------------
    bg    = hex2rgb('#0C1B3D');   % background dark
    panel = hex2rgb('#15294C');   % panel bg
    primary = hex2rgb('#2B7FFF'); % primary button
    accent  = hex2rgb('#1E62D0'); % accent button
    white   = [1 1 1];
    grayTxt = hex2rgb('#A3B2CC');
    mapBeige = hex2rgb('#EBD7A4');

    % ---------------------------
    % Create UIFigure
    % ---------------------------
    fig = uifigure('Name','BLAH BLAH','Position',[80 60 1220 820],...
                   'Color', bg, 'Resize', 'off'); 
    % Title bar area (large)
    topH = 96;
    topPanel = uipanel(fig,'Position',[0 720 1220 topH],'BackgroundColor',panel,'BorderType','none');

    % Title label centered
    titleLabel = uilabel(topPanel,'Text','BLAH BLAH',...
        'Position',[0 18 1220 60],'HorizontalAlignment','center',...
        'FontSize',30,'FontWeight','bold','FontColor',white,'BackgroundColor',panel);

    % ---------------------------
    % Panels: Left / Center / Right
    % ---------------------------
    leftW = 300; rightW = 280; centerW = 1220 - leftW - rightW - 40; % spacing
    leftX = 20; centerX = leftX + leftW + 20; rightX = centerX + centerW +20 ;
    panelY = 80; panelH = 620;

    leftPanel = uipanel(fig,'Position',[leftX panelY leftW panelH],'BackgroundColor',panel,'BorderType','none');
    centerPanel = uipanel(fig,'Position',[centerX panelY centerW panelH],'BackgroundColor',panel,'BorderType','none');
    rightPanel = uipanel(fig,'Position',[rightX panelY rightW panelH],'BackgroundColor',panel,'BorderType','none');

    % ---------------------------
    % LEFT PANEL content
    % ---------------------------
    % Import button
    importBtn = uibutton(leftPanel,'push','Text','Import scenario',...
        'Position',[20 520 260 64],'FontSize',20,'FontWeight','bold');
    importBtn.BackgroundColor = primary; importBtn.FontColor = white;

    % Assets titled box (Panel with Title)
    assetsPanel = uipanel(leftPanel,'Position',[20 340 260 160],'Title','Assets','BackgroundColor',panel,...
        'TitlePosition','lefttop','FontSize',18,'FontWeight','bold');
    assetList = uilistbox(assetsPanel,'Position',[8 8 244 120],...
        'Items',{'Pothole','Barricade','Vendor Stall','Rickshaw','Partial Lane Closure'},...
        'FontSize',16,'FontColor',white);
    assetList.BackgroundColor = hex2rgb('#213753'); % slightly different inner bg

    % Add asset label + numeric edit + batch add button
    lblAdd = uilabel(leftPanel,'Text','Add asset','Position',[20 300 120 24],'FontSize',14,'FontColor',white);
    addCount = uieditfield(leftPanel,'numeric','Position',[140 300 120 28],'Value',1);

    batchBtn = uibutton(leftPanel,'push','Text','Batch add','Position',[20 250 260 44],'FontSize',16);
    batchBtn.BackgroundColor = primary; batchBtn.FontColor = white;

    % Edit personas button
    editPersonaBtn = uibutton(leftPanel,'push','Text','Load Scenes','Position',[20 200 260 40],'FontSize',14);
    editPersonaBtn.ButtonPushedFcn = @(s,e) onEditPersona(fig);

    % Log Panel at bottom of leftPanel
    logLeftPanel = uipanel(leftPanel,'Position',[20 20 260 160],'Title','Log','BackgroundColor',panel,'FontSize',16,'FontWeight','bold');
    logArea = uitextarea(logLeftPanel,'Position',[8 8 244 120],'Editable','off','FontColor',grayTxt,'Value',{'[--] App started'});

    % ---------------------------
    % CENTER Panel content
    % ---------------------------
    pvLabel = uilabel(centerPanel,'Text','Preview','Position',[18 570 200 36],'FontSize',22,'FontWeight','bold','FontColor',white);

    % UIAxes for preview
    ax = uiaxes(centerPanel,'Position',[18 18 centerW-36 540],'BackgroundColor',mapBeige);
    ax.XTick = []; ax.YTick = []; ax.Box = 'on';
    % Draw the mock road map once
    drawMockMap(ax);

    % Add a bottom center log area (two columns look)
    bottomH = 80;
    centerBottomLeft = uipanel(centerPanel,'Position',[18 18  (centerW-36)/2 - 6 bottomH],'BackgroundColor',hex2rgb('#213753'));
    centerBottomRight = uipanel(centerPanel,'Position',[18 + (centerW-36)/2 + 6 18 (centerW-36)/2 - 6 bottomH],'BackgroundColor',hex2rgb('#213753'));
    lblCenterLogL = uilabel(centerBottomLeft,'Text','[10:17:23] Scene loaded','Position',[8 8 centerW 24],'FontColor',white);
    lblCenterLogR = uilabel(centerBottomRight,'Text','[10:17:25] Export to RoadRunner successful','Position',[8 8 centerW 24],'FontColor',white);

    % ---------------------------
    % RIGHT Panel content
    % ---------------------------
    simLabel = uilabel(rightPanel,'Text','Simulation','Position',[20 570 220 36],'FontSize',22,'FontWeight','bold','FontColor',white);

    lblTime = uilabel(rightPanel,'Text','Time of day','Position',[20 530 120 22],'FontSize',16,'FontColor',white);
    ddTime = uidropdown(rightPanel,'Items',{'Day','Dawn','Night'},'Value','Day','Position',[20 490 220 36]);

    lblWeather = uilabel(rightPanel,'Text','Weather','Position',[20 452 120 22],'FontSize',16,'FontColor',white);
    ddWeather = uidropdown(rightPanel,'Items',{'Clear','Rain','Fog'},'Value','Clear','Position',[20 412 220 36]);

    lblFidelity = uilabel(rightPanel,'Text','Fidelity','Position',[20 374 120 22],'FontSize',16,'FontColor',white);
    ddFidelity = uidropdown(rightPanel,'Items',{'Kinematic','Dynamics'},'Value','Kinematic','Position',[20 334 220 36]);

    lblDensity = uilabel(rightPanel,'Text','Asset density','Position',[20 296 120 22],'FontSize',16,'FontColor',white);
    sldDensity = uislider(rightPanel,'Position',[20 280 220 3]); sldDensity.Value = 0.5;

    expBtn = uibutton(rightPanel,'push','Text','Export to RoadRunner','Position',[20 182 220 48],'FontSize',17);
    expBtn.BackgroundColor = primary; expBtn.FontColor = white;

    runBtn = uibutton(rightPanel,'push','Text','Run RoadRunner','Position',[20 112 220 48],'FontSize',17);
    runBtn.BackgroundColor = primary; runBtn.FontColor = white;

    dlBtn = uibutton(rightPanel,'push','Text','Download results','Position',[20 42 220 48],'FontSize',17);
    dlBtn.BackgroundColor = primary; dlBtn.FontColor = white;

    % ---------------------------
    % Attach callbacks
    % ---------------------------
    % store handles in appdata
    appdata.ax = ax; appdata.logArea = logArea; appdata.centerLeftLabel = lblCenterLogL; appdata.centerRightLabel = lblCenterLogR;
    setappdata(fig,'AppData',appdata);

    importBtn.ButtonPushedFcn = @(s,e) onImport(fig);
    batchBtn.ButtonPushedFcn  = @(s,e) onBatchAdd(fig, assetList);
    expBtn.ButtonPushedFcn    = @(s,e) onExport(fig);
    runBtn.ButtonPushedFcn    = @(s,e) onRun(fig);

    % final log update
    appendLog(logArea,'UI ready. Use Import scenario or Batch add to populate preview.');
end

% ---------------------------
% helper: draw mock map and icons in axes
% ---------------------------
function drawMockMap(ax)
    cla(ax); hold(ax,'on'); axis(ax,'off'); % no axes ticks
    % draw beige background (already set)
    % draw some roads as thick lines
    lw = 38;
    plot(ax, [0.1 0.9], [0.55 0.55], 'Color', [0.93 0.82 0.6], 'LineWidth', lw); % horizontal
    plot(ax, [0.35 0.35], [0.15 0.85], 'Color', [0.93 0.82 0.6], 'LineWidth', lw); % vertical
    plot(ax, [0.15 0.85], [0.25 0.75], 'Color', [0.93 0.82 0.6], 'LineWidth', lw); % diagonal
    % draw roundabout
    rectangle(ax,'Position',[0.62 0.12 0.14 0.14],'Curvature',[1 1],'FaceColor',[0.70 0.88 0.64],'EdgeColor',[0.78 0.78 0.65]);
    % draw small asset icons as colored rectangles/circles
    scatter(ax, 0.65, 0.65, 900, [0.0 0.64 0.42],'o','filled'); % rickshaw-green
    scatter(ax, 0.4, 0.35, 700, [0.2 0.2 0.2],'s','filled'); % car
    scatter(ax, 0.25, 0.45, 500, [0.95 0.6 0.26],'d','filled'); % cone/barrier
    scatter(ax, 0.5, 0.25, 300, [0.1 0.1 0.1],'o','filled'); % small car
    % add little pothole blobs (dark smudges)
    for k = 1:4
        xp = 0.3 + 0.12*rand; yp = 0.4 + 0.18*rand;
        patch(ax, xp + 0.02*randn(1,6), yp + 0.015*randn(1,6), [0.25 0.22 0.22], 'EdgeColor','none');
    end
    % scale axes to 0..1 for consistent layout
    xlim(ax,[0 1]); ylim(ax,[0 1]);
    hold(ax,'off');
end

% ---------------------------
% Callbacks (simple, safe)
% ---------------------------
function onImport(fig)
    d = getappdata(fig,'AppData');
    logArea = d.logArea;
    
    [f,p] = uigetfile({'*.osm;*.xodr', 'OpenDRIVE/OpenStreetMap Files (*.osm, *.xodr)'},...
        'Select Road Network');
    
    if isequal(f,0)
        appendLog(logArea,'Import canceled.');
        return;
    end
    
    filePath = fullfile(p, f);
    appendLog(logArea,['Selected file: ' filePath]);
    
    try
        % Just read the file and show some info - NO ROADRUNNER CONNECTION!
        appendLog(logArea,'Reading file...');
        
        if contains(filePath, '.osm')
            % Read OSM file
            fileContent = fileread(filePath);
            nodeCount = numel(strfind(fileContent, '<node'));
            wayCount = numel(strfind(fileContent, '<way'));
            appendLog(logArea,sprintf('OSM file loaded: %d nodes, %d ways', nodeCount, wayCount));
        else
            % Read XODR file  
            fileContent = fileread(filePath);
            roadCount = numel(strfind(fileContent, '<road'));
            appendLog(logArea,sprintf('XODR file loaded: %d roads found', roadCount));
        end
        
        % STORE the loaded file path for export
        setappdata(fig, 'LoadedFile', filePath);
        appendLog(logArea,'File successfully processed! Ready for export.');
        
        % Update the preview with REAL verification
        ax = d.ax;
        cla(ax);
        
        % Show actual file stats - NOT fake positive messages
        if contains(filePath, '.osm')
            statusText = sprintf('✓ VERIFIED OSM Import\nFile: %s\nNodes: %d\nWays: %d\n\nReady for RoadRunner!', ...
                               f, nodeCount, wayCount);
        else
            statusText = sprintf('✓ VERIFIED XODR Import\nFile: %s\nRoads: %d\n\nReady for RoadRunner!', ...
                               f, roadCount);
        end
        
        text(ax, 0.5, 0.5, statusText, 'HorizontalAlignment', 'center', ...
             'FontSize', 12, 'Color', [0 0.6 0], 'FontWeight', 'bold');
        xlim(ax, [0 1]); ylim(ax, [0 1]);
        
    catch ME
        appendLog(logArea,['Error reading file: ' ME.message]);
    end
end

function onBatchAdd(fig, assetList)
    d = getappdata(fig,'AppData'); logArea = d.logArea; ax = d.ax;
    % read selected asset (if none selected use Pothole)
    items = assetList.Items;
    if ~isempty(assetList.Value), choice = assetList.Value; else choice = 'Pothole'; end
    appendLog(logArea,['Batch adding assets of type: ' choice]);
    % draw some random icons on the preview to mimic added assets
    ax = d.ax;
    hold(ax,'on');
    for i=1:6
        x = 0.15 + 0.7*rand; y = 0.15 + 0.7*rand;
        scatter(ax,x,y,600,hex2rgb('#F79B42'),'filled'); % orange spots for batch assets
    end
    hold(ax,'off');
    appendLog(logArea,'Batch add complete (visual mock).');
end

function onEditPersona(fig)
    d = getappdata(fig,'AppData'); 
    logArea = d.logArea;
    
    % The scene to load. This is a hardcoded placeholder.
    sceneName = 'T_Intersection'; 
    
    appendLog(logArea,['Calling Python backend to load scene: ' sceneName]);
    
    try
        % Add Python path and RELOAD module
        pythonScriptPath = 'C:\codes\SIH\kyaMATLAB';
        if count(py.sys.path, pythonScriptPath) == 0
            insert(py.sys.path, int64(0), pythonScriptPath);
        end
        
        py.importlib.invalidate_caches();
        
        % Call the Python function to load the scene
        control_rr = py.importlib.import_module('control_rr');
        result = control_rr.load_scene(sceneName);
        
        isSuccessful = logical(result{1});
        message = char(result{2});
        
        if isSuccessful
            appendLog(logArea, 'SUCCESS: ' + string(message));
        else
            appendLog(logArea, 'FAILED: ' + string(message));
        end
        
    catch ME
        appendLog(logArea,['Python Load Scene Error: ' ME.message]);
    end
end

function onExport(fig)
    d = getappdata(fig,'AppData'); 
    logArea = d.logArea;
    
    % Check if we have a loaded file first
    if ~isappdata(fig, 'LoadedFile')
        appendLog(logArea,'ERROR: No file imported! Use Import Scenario first.');
        return;
    end
    
    loadedFilePath = getappdata(fig, 'LoadedFile');
    appendLog(logArea,['Exporting to RoadRunner: ' loadedFilePath]);
    
    try
        % Add Python path and RELOAD module
        pythonScriptPath = 'C:\codes\SIH\kyaMATLAB';
        if count(py.sys.path, pythonScriptPath) == 0
            insert(py.sys.path, int64(0), pythonScriptPath);
        end
        
        % SIMPLE reload
        py.importlib.invalidate_caches();
        
        % Call Python export function
        control_rr = py.importlib.import_module('control_rr');
        result = control_rr.export_to_roadrunner(char(loadedFilePath));
        
        % Get results
        isSuccessful = logical(result{1});
        message = char(result{2});
        
        if isSuccessful
            appendLog(logArea, 'SUCCESS: ' + string(message));
        else
            appendLog(logArea, 'FAILED: ' + string(message));
        end
        
    catch ME
        appendLog(logArea,['Python Export Error: ' ME.message]);
    end
end

function onRun(fig)
    d = getappdata(fig,'AppData'); 
    logArea = d.logArea;
    appendLog(logArea,'Starting RoadRunner application...');
    
    try
        % Add Python path and RELOAD module
        pythonScriptPath = 'C:\codes\SIH\kyaMATLAB';
        if count(py.sys.path, pythonScriptPath) == 0
            insert(py.sys.path, int64(0), pythonScriptPath);
        end
        py.importlib.invalidate_caches();

        control_rr = py.importlib.import_module('control_rr');
        
        % This will launch the specific executable you have.
        result = control_rr.launch_roadrunner();
        
        isSuccessful = logical(result{1});
        message = char(result{2});

        if isSuccessful
            appendLog(logArea, 'SUCCESS: ' + string(message));
        else
            appendLog(logArea, 'FAILED: ' + string(message));
        end

    catch ME
        appendLog(logArea,['Failed to start RoadRunner: ' ME.message]);
    end
end

% ---------------------------
% small utilities
% ---------------------------
function appendLog(logArea, txt)
    t = datestr(now,'HH:MM:SS');
    try
        logArea.Value = [{sprintf('[%s] %s',t,txt)}; logArea.Value];
    catch
        fprintf('[%s] %s\n',t,txt);
    end
end

function rgb = hex2rgb(hex)
    if isempty(hex), rgb=[0 0 0]; return; end
    if hex(1)=='#', hex = hex(2:end); end
    r = double(hex2dec(hex(1:2))) / 255;
    g = double(hex2dec(hex(3:4))) / 255;
    b = double(hex2dec(hex(5:6))) / 255;
    rgb = [r g b];
end
