function india_twin_builder_app()
% IndiaTwinBuilder_app_v2
% Left panel: single "Add asset" (dialog + add-to-preview), Load Scenes, Log.
% Rest of UI retained.

    % ---------------------------
    % Colors (hex -> rgb)
    % ---------------------------
    bg      = hex2rgb('#0C1B3D');    % background dark
    panel   = hex2rgb('#15294C');    % panel bg
    primary = hex2rgb('#2B7FFF');    % primary button
    white   = [1 1 1];
    grayTxt = hex2rgb('#A3B2CC');
    mapBeige = hex2rgb('#EBD7A4');
    
    % ---------------------------
    % Get Screen Size for dynamic layout
    % ---------------------------
    scr_sz = get(0, 'ScreenSize');
    figW = scr_sz(3);
    figH = scr_sz(4);

    % ---------------------------
    % Create UIFigure (Full-screen)
    % ---------------------------
    fig = uifigure('Name','BLAH BLAH', ...
                   'Position',[1 1 figW figH], ...
                   'Color', bg, 'Resize', 'off');

    % Title bar area (large)
    topH = 96;
    topPanel = uipanel(fig, 'Position', [0 figH-topH figW topH], ...
                       'BackgroundColor', panel, 'BorderType', 'none');

    % Title label centered
    titleLabel = uilabel(topPanel, 'Text', 'BLAH BLAH', ...
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
    % LEFT PANEL content (modified)
    % - Single Add asset button, Load Scenes, and Log (bottom)
    % ---------------------------
    AddAssetButton = uibutton(leftPanel, 'push', 'Text', 'Add asset', ...
        'Position', [20 panelH-84 260 64], 'FontSize', 20, 'FontWeight', 'bold');
    AddAssetButton.BackgroundColor = primary; AddAssetButton.FontColor = white;
    AddAssetButton.ButtonPushedFcn = @(s,e) onAddAsset(fig);

    editPersonaBtn = uibutton(leftPanel, 'push', 'Text', 'Load Scenes', 'Position', [20 panelH-160 260 44], 'FontSize', 14);
    editPersonaBtn.ButtonPushedFcn = @(s,e) onEditPersona(fig);

    logLeftPanel = uipanel(leftPanel, 'Position', [20 20 260 120], 'Title', 'Log', 'BackgroundColor', panel, 'FontSize', 16, 'FontWeight', 'bold');
    logArea = uitextarea(logLeftPanel, 'Position', [8 8 244 100], 'Editable', 'off', 'FontColor', grayTxt, 'Value', {'[--] App started'});

    % ---------------------------
    % CENTER Panel content
    % ---------------------------
    pvLabel = uilabel(centerPanel, 'Text', 'Preview', 'Position', [18 panelH-50 200 36], 'FontSize', 22, 'FontWeight', 'bold', 'FontColor', white);

    % UIAxes for preview
    bottomH = 80;
    axesH = panelH - 50 - 36 - 20 - bottomH - 18;
    ax = uiaxes(centerPanel, 'Position', [18 18+bottomH centerW-36 axesH], 'BackgroundColor', mapBeige);
    ax.XTick = []; ax.YTick = []; ax.Box = 'on';
    drawMockMap(ax);

    % Center bottom logs
    centerBottomLeft = uipanel(centerPanel, 'Position', [18 18 (centerW-36)/2 - 6 bottomH], 'BackgroundColor', hex2rgb('#213753'));
    centerBottomRight = uipanel(centerPanel, 'Position', [18 + (centerW-36)/2 + 6 18 (centerW-36)/2 - 6 bottomH], 'BackgroundColor', hex2rgb('#213753'));
    lblCenterLogL = uilabel(centerBottomLeft, 'Text', '[10:17:23] Scene loaded', 'Position', [8 8 (centerW-36)/2 - 6 24], 'FontColor', white);
    lblCenterLogR = uilabel(centerBottomRight, 'Text', '[10:17:25] Export to RoadRunner successful', 'Position', [8 8 (centerW-36)/2 - 6 24], 'FontColor', white);

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

    lblDensity = uilabel(rightPanel, 'Text', 'Asset density', 'Position', [20 panelH-324 120 22], 'FontSize', 16, 'FontColor', white);
    sldDensity = uislider(rightPanel, 'Position', [20 panelH-340 220 3]); sldDensity.Value = 0.5;

    expBtn = uibutton(rightPanel, 'push', 'Text', 'Export to RoadRunner', 'Position', [20 panelH-438 220 48], 'FontSize', 17);
    expBtn.BackgroundColor = primary; expBtn.FontColor = white;

    runBtn = uibutton(rightPanel, 'push', 'Text', 'Run RoadRunner', 'Position', [20 panelH-508 220 48], 'FontSize', 17);
    runBtn.BackgroundColor = primary; runBtn.FontColor = white;

    dlBtn = uibutton(rightPanel, 'push', 'Text', 'Download results', 'Position', [20 42 220 48], 'FontSize', 17);
    dlBtn.BackgroundColor = primary; dlBtn.FontColor = white;

    % ---------------------------
    % Store appdata
    % ---------------------------
    appdata.ax = ax; appdata.logArea = logArea; appdata.centerLeftLabel = lblCenterLogL; appdata.centerRightLabel = lblCenterLogR;
    setappdata(fig, 'AppData', appdata);

    % Link callbacks for export/run (keep your earlier implementations if needed)
    expBtn.ButtonPushedFcn = @(s,e) onExport(fig);
    runBtn.ButtonPushedFcn = @(s,e) onRun(fig);

    appendLog(logArea, 'UI ready. Use "Add asset" to create Pothole or Barricade.');

    % ---------------------------
    % onAddAsset: opens modal dialog, validates, visualizes & stores
    % ---------------------------
    function onAddAsset(figHandle)
        d = getappdata(figHandle, 'AppData');
        axLocal = d.ax;
        logLocal = d.logArea;

        params = showAddAssetDialog(figHandle);
        if isempty(params)
            appendLog(logLocal, 'Add asset cancelled.');
            return;
        end

        appendLog(logLocal, sprintf('Adding asset: %s', params.assetType));
        hold(axLocal, 'on');
        switch params.assetType
            case 'Pothole'
                x = 0.15 + 0.7*rand; y = 0.15 + 0.7*rand;
                visSize = max(150, min(2400, params.details.area_m2*2800));
                scatter(axLocal, x, y, visSize, [0.25 0.22 0.22], 'o', 'filled');
                text(axLocal, x, y-0.03, sprintf('Pothole\nw=%.2fm a=%.2fm^2\nv:%s', params.details.width_m, params.details.area_m2, params.details.vehicleType),...
                    'HorizontalAlignment','center','FontSize',10,'BackgroundColor',[1 1 1 0.6]);
            case 'Barricade'
                x = 0.15 + 0.7*rand; y = 0.15 + 0.7*rand;
                if strcmp(params.details.mode, 'Single')
                    scatter(axLocal, x, y, 700, hex2rgb('#F79B42'), 's', 'filled');
                    text(axLocal, x, y-0.03, 'Barricade (single)','HorizontalAlignment','center','FontSize',10,'BackgroundColor',[1 1 1 0.6]);
                else
                    n = 4;
                    for ii = 1:n
                        xx = x + (ii-1)*(params.details.distance_m/10)*0.02;
                        scatter(axLocal, xx, y, 300, hex2rgb('#F79B42'), 's', 'filled');
                    end
                    text(axLocal, x, y-0.05, sprintf('Barricades\nmultiple, dist=%.2fm', params.details.distance_m),'HorizontalAlignment','center','FontSize',10,'BackgroundColor',[1 1 1 0.6]);
                end
            otherwise
                scatter(axLocal, 0.5, 0.5, 700, hex2rgb('#F79B42'), 'filled');
        end
        hold(axLocal, 'off');

        % store params in AssetsList
        if isappdata(figHandle, 'AssetsList')
            al = getappdata(figHandle, 'AssetsList');
        else
            al = {};
        end
        al{end+1} = params;
        setappdata(figHandle, 'AssetsList', al);

        appendLog(logLocal, 'Asset added to preview and saved.');
    end

    % ---------------------------
    % Modal dialog function (nested) - returns params struct or [] if cancelled
    % ---------------------------
    function params = showAddAssetDialog(parent)
        params = [];
        d = uifigure('Name','Add Asset','Position',[200 200 440 380],'Resize','off','WindowStyle','modal');
        uilabel(d,'Position',[16 340 400 28],'Text','Add Asset','FontWeight','bold','FontSize',16);

        uilabel(d,'Position',[16 305 100 20],'Text','Asset:','FontSize',12);
        assetDD = uidropdown(d,'Position',[120 305 300 22],'Items',{'Pothole','Barricade'},'Value','Pothole');

        dynPanel = uipanel(d,'Position',[12 140 416 150],'Title','Parameters');

        uilabel(d,'Position',[16 110 120 20],'Text','Road width (m):','FontSize',12);
        roadWidthEdit = uieditfield(d,'numeric','Position',[140 110 100 22],'Value',6);

        uilabel(d,'Position',[260 110 140 20],'Text','Number of lanes (optional):','FontSize',12);
        numLanesEdit = uieditfield(d,'numeric','Position',[380 110 40 22],'Value',2);

        cancelBtn = uibutton(d,'Position',[60 20 120 36],'Text','Cancel','ButtonPushedFcn',@(btn,event) closeDialog(false));
        addBtn = uibutton(d,'Position',[260 20 120 36],'Text','Add','ButtonPushedFcn',@(btn,event) closeDialog(true));

        % default controls
        createPotholeControls();

        assetDD.ValueChangedFcn = @(src,event) switchAsset(src.Value);
        uiwait(d);

        function switchAsset(val)
            delete(dynPanel.Children);
            if strcmp(val,'Pothole'), createPotholeControls(); else createBarricadeControls(); end
        end

        function createPotholeControls()
            uilabel(dynPanel,'Position',[8 100 120 20],'Text','Vehicle type:','FontSize',11);
            uidropdown(dynPanel,'Position',[140 100 260 22],'Items',{'Car','Two-wheeler','Bus','Truck','Other'},'Value','Car','Tag','vhDD');

            uilabel(dynPanel,'Position',[8 60 120 20],'Text','Width of hole (m):','FontSize',11);
            uieditfield(dynPanel,'numeric','Position',[140 60 120 22],'Value',0.5,'Limits',[0 Inf],'Tag','widthEdit');

            uilabel(dynPanel,'Position',[8 20 120 20],'Text','Area (sq.m):','FontSize',11);
            uieditfield(dynPanel,'numeric','Position',[140 20 120 22],'Value',0.3,'Limits',[0 Inf],'Tag','areaEdit');
        end

        function createBarricadeControls()
            uilabel(dynPanel,'Position',[8 100 140 20],'Text','Single or Multiple:','FontSize',11);
            uidropdown(dynPanel,'Position',[160 100 240 22],'Items',{'Single','Multiple'},'Value','Single','Tag','multiDD');

            uilabel(dynPanel,'Position',[8 60 200 20],'Text','Distance b/w (m) (if multiple):','FontSize',11);
            uieditfield(dynPanel,'numeric','Position',[220 60 120 22],'Value',2,'Limits',[0 Inf],'Tag','distEdit');

            %uilabel(dynPanel,'Position',[8 20 140 20],'Text','(Optional) Extra notes:','FontSize',11);
           %uieditfield(dynPanel,'text','Position',[160 20 240 22],'Value','','Tag','notesEdit');
        end

        function closeDialog(isAdd)
            if ~isAdd
                params = [];
                delete(d);
                return;
            end
            assetType = assetDD.Value;
            rw = roadWidthEdit.Value;
            nl = numLanesEdit.Value;
            if isempty(rw) || rw <= 0
                uialert(d,'Please enter valid Road width (>0).','Validation error');
                return;
            end
            details = struct();
            switch assetType
                case 'Pothole'
                    vh = findobj(dynPanel,'Tag','vhDD');
                    widthObj = findobj(dynPanel,'Tag','widthEdit');
                    areaObj  = findobj(dynPanel,'Tag','areaEdit');
                    if isempty(vh) || isempty(widthObj) || isempty(areaObj)
                        uialert(d,'Missing pothole fields.','Validation error');
                        return;
                    end
                    details.vehicleType = vh.Value;
                    details.width_m = widthObj.Value;
                    details.area_m2 = areaObj.Value;
                    if details.width_m <= 0 || details.area_m2 <= 0
                        uialert(d,'Width and area must be > 0','Validation error');
                        return;
                    end
                case 'Barricade'
                    multiObj = findobj(dynPanel,'Tag','multiDD');
                    distObj = findobj(dynPanel,'Tag','distEdit');
                    notesObj = findobj(dynPanel,'Tag','notesEdit');
                    if isempty(multiObj) || isempty(distObj)
                        uialert(d,'Missing barricade fields.','Validation error');
                        return;
                    end
                    details.mode = multiObj.Value;
                    details.distance_m = distObj.Value;
                    details.notes = '';
                    if ~isempty(notesObj), details.notes = notesObj.Value; end
                    if strcmp(details.mode,'Multiple') && (isempty(details.distance_m) || details.distance_m <= 0)
                        uialert(d,'Please enter a positive distance for multiple barricades','Validation error');
                        return;
                    end
                otherwise
                    details = struct();
            end
            params = struct('assetType',assetType,'details',details,'roadWidth',rw,'numLanes',nl);
            delete(d);
        end
    end

    % ---------------------------
    % Existing placeholder for edit persona / export / run (kept)
    % ---------------------------
    function onEditPersona(figH)
        d = getappdata(figH, 'AppData'); 
        logAreaLocal = d.logArea;
        appendLog(logAreaLocal, 'Load Scenes pressed (keeps original implementation).');
        % You can paste your Python-calling code here as before
    end

    function onExport(figH)
        d = getappdata(figH, 'AppData'); 
        logAreaLocal = d.logArea;
        appendLog(logAreaLocal, 'Export to RoadRunner triggered (unchanged).');
    end

    function onRun(figH)
        d = getappdata(figH, 'AppData'); 
        logAreaLocal = d.logArea;
        appendLog(logAreaLocal, 'Run RoadRunner triggered (unchanged).');
    end

end

% ---------------------------
% helper: draw mock map and icons in axes (unchanged)
% ---------------------------
function drawMockMap(ax)
    cla(ax); hold(ax, 'on'); axis(ax, 'off'); % no axes ticks
    lw = 38;
    plot(ax, [0.1 0.9], [0.55 0.55], 'Color', [0.93 0.82 0.6], 'LineWidth', lw); % horizontal
    plot(ax, [0.35 0.35], [0.15 0.85], 'Color', [0.93 0.82 0.6], 'LineWidth', lw); % vertical
    plot(ax, [0.15 0.85], [0.25 0.75], 'Color', [0.93 0.82 0.6], 'LineWidth', lw); % diagonal
    rectangle(ax, 'Position', [0.62 0.12 0.14 0.14], 'Curvature', [1 1], 'FaceColor', [0.70 0.88 0.64], 'EdgeColor', [0.78 0.78 0.65]);
    scatter(ax, 0.65, 0.65, 900, [0.0 0.64 0.42], 'o', 'filled');
    scatter(ax, 0.4, 0.35, 700, [0.2 0.2 0.2], 's', 'filled');
    scatter(ax, 0.25, 0.45, 500, [0.95 0.6 0.26], 'd', 'filled');
    scatter(ax, 0.5, 0.25, 300, [0.1 0.1 0.1], 'o', 'filled');
    for k = 1:4
        xp = 0.3 + 0.12*rand; yp = 0.4 + 0.18*rand;
        patch(ax, xp + 0.02*randn(1,6), yp + 0.015*randn(1,6), [0.25 0.22 0.22], 'EdgeColor', 'none');
    end
    xlim(ax, [0 1]); ylim(ax, [0 1]);
    hold(ax, 'off');
end

% ---------------------------
% small utilities (unchanged)
% ---------------------------
function appendLog(logArea, txt)
    t = datestr(now, 'HH:MM:SS');
    try
        if isempty(logArea) || ~isvalid(logArea)
            fprintf('[%s] %s\n', t, txt);
            return;
        end
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
