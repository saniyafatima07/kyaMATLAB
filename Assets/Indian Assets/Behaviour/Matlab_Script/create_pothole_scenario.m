% =========================================================================
% create_pothole_scenario.m (FINAL HYBRID WORKFLOW)
% -------------------------------------------------------------------------
% This script creates a LIVE, INTERACTIVE scenario for Simulink control.
% It uses the reliable HD Map method to build the road, then uses the
% modern API to add live actors without pre-defined paths.
% It returns a handle to the RoadRunner application.
% =========================================================================
function rrApp = create_pothole_scenario()
% --- Configuration ---
HD_MAP_FILENAME = 'PotholeCourse.rrhd';
SCENE_FILENAME = 'PotholeTest.rrscene';
SCENARIO_FILENAME = 'PotholeTest.rrscenario';
ROAD_LENGTH = 300; % meters
ROAD_WIDTH = 7; % meters
NUM_POTHOLES = 4;
POTHOLE_START_DISTANCE = 70; % meters
POTHOLE_SPACING = 60; % meters

% *** This path now directly controls which project RoadRunner will use ***
ROADRUNNER_PROJECT_FOLDER = 'C:\codes\SIH\kyaMATLAB';

disp('--- Starting RoadRunner Scenario Creation (Live Hybrid Workflow) ---');

%% PART 1: CREATE THE ROAD DEFINITION IN MATLAB AND SAVE TO FILE
disp('Step 1: Creating HD Map object in MATLAB...');
rrMap = roadrunnerHDMap;
roadCenters = [0 0; ROAD_LENGTH 0];
% Create Lane Boundaries
lb_left = roadrunner.hdmap.LaneBoundary;
lb_left.ID = "Left";
lb_left.Geometry = roadCenters - [0 ROAD_WIDTH/2];
rrMap.LaneBoundaries(1) = lb_left;
lb_right = roadrunner.hdmap.LaneBoundary;
lb_right.ID = "Right";
lb_right.Geometry = roadCenters + [0 ROAD_WIDTH/2];
rrMap.LaneBoundaries(2) = lb_right;
% Create the Driving Lane
rLane = roadrunner.hdmap.Lane;
rLane.ID = "Lane1";
rLane.Geometry = roadCenters;
rLane.TravelDirection = "Forward";
rLane.LaneType = "Driving";
leftBoundary(rLane,"Left",Alignment="Forward");
rightBoundary(rLane,"Right",Alignment="Forward");
rrMap.Lanes = rLane;
% Write the map definition to a local .rrhd file
hdMapFilePath = fullfile(pwd, HD_MAP_FILENAME);
write(rrMap, hdMapFilePath);
disp(['HD Map data successfully written to: ' hdMapFilePath]);


%% PART 2: CONNECT TO ROADRUNNER, IMPORT, AND AUTHOR SCENARIO
% *** This section forces RoadRunner to launch with the correct project folder ***
disp('Step 2: Connecting to RoadRunner with specified project folder...');
try
    % This command launches RoadRunner and sets its active project folder.
    rrApp = roadrunner(ROADRUNNER_PROJECT_FOLDER); 
    disp('Connected to RoadRunner, project folder set correctly.');
catch ME
    disp('Failed to launch or connect to RoadRunner. Please ensure it is installed correctly.');
    rethrow(ME);
end

rrApp.newScenario();

% Copy the generated map file to the official RR Project Assets folder
projectFolder = ROADRUNNER_PROJECT_FOLDER;
assetsFolder = fullfile(projectFolder, 'Assets');
if ~exist(assetsFolder, 'dir')
   mkdir(assetsFolder);
end
projectHdMapPath = fullfile(assetsFolder, HD_MAP_FILENAME);
copyfile(hdMapFilePath, projectHdMapPath, 'f'); % 'f' forces overwrite
disp(['Map file copied to project assets folder: ' projectHdMapPath]);

% Import the file from its correct project location
importOptions = roadrunnerHDMapImportOptions(ImportStep="Load"); 
importScene(rrApp, projectHdMapPath, "RoadRunner HD Map", importOptions);
disp('RoadRunner HD Map data has been loaded.');
buildOptions = roadrunnerHDMapBuildOptions(DetectAsphaltSurfaces=true);
buildScene(rrApp, "RoadRunner HD Map", buildOptions);
pause(5); 
disp('Road has been imported and built in RoadRunner.');

% Author the Scenario with LIVE actors
disp('Authoring scenario using modern API...');
rrApi = roadrunnerAPI(rrApp);
scnro = rrApi.Scenario;
prj = rrApi.Project;

disp('Placing live actors into the scenario...');
car_y_position = -ROAD_WIDTH / 4; 
vehicle_position = [5 car_y_position 0];
vehicle_asset = getAsset(prj, "Vehicles/Sedan.fbx", "VehicleAsset");
egoVehicle = addActor(scnro, vehicle_asset, vehicle_position);
egoVehicle.Name = "vehicle_car";

prop_asset = getAsset(prj, "Props/TrafficControl/TrafficCone01.fbx", "MovableObjectAsset");
for i = 1:NUM_POTHOLES
    potholeX = POTHOLE_START_DISTANCE + (i-1) * POTHOLE_SPACING;
    pothole_position = [potholeX car_y_position 0];
    pothole = addActor(scnro, prop_asset, pothole_position);
    pothole.Name = "pothole_" + i;
end
disp('Live actors placed. Scenario is ready for Simulink control.');

% Save the final scene and scenario
sceneFilePath = fullfile(pwd, SCENE_FILENAME);
saveScene(rrApp, sceneFilePath);
disp(['Scene successfully saved to: ' sceneFilePath]);
scenarioFilePath = fullfile(pwd, SCENARIO_FILENAME);
saveScenario(rrApp, scenarioFilePath);
disp(['Final scenario successfully saved to: ' scenarioFilePath]);
disp('--- Scenario Creation Complete ---');
end

