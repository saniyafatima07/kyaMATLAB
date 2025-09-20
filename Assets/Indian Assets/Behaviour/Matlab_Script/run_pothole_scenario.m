% =========================================================================
% run_pothole_scenario.m (FINAL VERSION)
% -------------------------------------------------------------------------
% This script runs the complete pothole avoidance simulation. It calls the
% creation script, finds the vehicle, assigns the pre-made Behavior Asset,
% and runs the co-simulation.
% =========================================================================
clear; clc;

% --- Step 1: Create the scenario and get the connection ---
disp("--- Creating/Updating RoadRunner Scenario ---");
rrApp = create_pothole_scenario;

disp("--- Starting Pothole Avoidance Simulation ---");

% --- Configuration ---
TARGET_VEHICLE_NAME = "vehicle_car"; % Use string for direct comparison
% This must match the asset you created manually in the RoadRunner project
BEHAVIOR_ASSET_NAME = "PotholeBehavior"; 
SIMULINK_MODEL_NAME = 'pothole_test'; 

% --- Step 2: Load the Simulink Model ---
if ~bdIsLoaded(SIMULINK_MODEL_NAME)
    load_system(SIMULINK_MODEL_NAME);
    disp(['Simulink model "' SIMULINK_MODEL_NAME '.slx" loaded.']);
end

% --- Step 3: Find Actor and Assign Behavior by Property ---
try
    % Get the API and scenario objects
    rrApi = roadrunnerAPI(rrApp);
    scnro = rrApi.Scenario;
    
    % Manually loop through actors to find the vehicle
    allActors = scnro.Actors;
    vehicleActor = [];
    for i = 1:length(allActors)
        if allActors(i).Name == TARGET_VEHICLE_NAME
            vehicleActor = allActors(i);
            disp(['Found actor "' char(vehicleActor.Name) '" in the scenario.']);
            break;
        end
    end
    
    if isempty(vehicleActor)
        error('Could not find an actor named "%s" in the scenario.', TARGET_VEHICLE_NAME);
    end
    
    % --- FIX: Assign behavior by setting the 'Behavior' property directly ---
    % This follows the same pattern as setting the '.Name' property.
    vehicleActor.Behavior = BEHAVIOR_ASSET_NAME;
    disp(['Successfully assigned behavior asset "' BEHAVIOR_ASSET_NAME '" to vehicle.']);
    
catch ME
    error('Could not find actor or assign behavior. Error: %s', ME.message);
end

% --- Step 4: Run the Simulation using the co-simulation object ---
disp("Starting co-simulation. Watch the vehicle in RoadRunner...");
% Get the simulation object as shown in the documentation
rrSim = createSimulation(rrApp);
% Start the simulation
set(rrSim, 'SimulationCommand','Start');

disp("Script finished. The simulation is now running in RoadRunner.");

