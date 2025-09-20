classdef PotholeController < matlab.System
% PotholeController continuously finds the next pothole in the ego
% vehicle's path and adjusts the vehicle's speed.
%
% This System object identifies the closest pothole in front of the
% vehicle, targets it, and commands the vehicle to slow down when within
% an action distance. Once passed, it finds the next pothole and repeats.
%
% Copyright 2025 The MathWorks, Inc. (Inspired by user example)

    % Public, tunable properties that will appear in the Simulink mask
    properties(Nontunable)
        % Actor ID of the Ego Vehicle to control
        EgoActorID = 1;
        % Cruising speed when no pothole is nearby (m/s)
        CruisingSpeed = 15;
        % Target speed when approaching a pothole (m/s)
        PotholeSpeed = 5;
        % Distance at which to start slowing down (m)
        ActionDistance = 50;
    end

    % Private properties to store internal state information
    properties(Access = private)
        % RoadRunner Simulation Object
        RRSimObj
        % Ego actor's name (needed for the output command)
        EgoActorName
        % The ID of the current pothole being targeted
        TargetPotholeID
    end

    methods(Access = protected)
        %% SETUP: Runs once at the beginning of the simulation
        function setupImpl(obj)
            % Get the RoadRunner Scenario Simulation object from the model
            obj.RRSimObj = Simulink.ScenarioSimulation.find('ScenarioSimulation', 'SystemObject', obj);
            
            % Retrieve all ActorSimulation objects
            actorSim = obj.RRSimObj.get("ActorSimulation");
            allActorIDs = cellfun(@(c) c.getAttribute("ID"), actorSim);
            
            % Find the specific Actor Simulation object for our ego vehicle
            egoIdx = (allActorIDs == obj.EgoActorID);
            if ~any(egoIdx)
                error('PotholeController: Ego vehicle with ID %d not found.', obj.EgoActorID);
            end
            egoActorSim = actorSim{egoIdx};

            % Store the ego actor's name, which is required for the command bus
            obj.EgoActorName = egoActorSim.getAttribute("Name");

            % Initialize the target pothole ID to -1, indicating no target
            obj.TargetPotholeID = -1;
        end

        %% STEP: Runs at every simulation time step
        function vehicleCmd = stepImpl(obj, egoPose, allPotholePoses)
            % Initialize the output command with the cruising speed
            vehicleCmd.ActorName = string(obj.EgoActorName);
            vehicleCmd.TargetSpeed = obj.CruisingSpeed;
            
            % --- Find a new target if we don't have one ---
            if obj.TargetPotholeID == -1
                obj.TargetPotholeID = obj.findNextPothole(egoPose, allPotholePoses, -1);
            end

            % If we still don't have a target, just keep cruising and exit
            if obj.TargetPotholeID == -1
                return;
            end

            % --- Track the current target pothole ---
            % Find the current target pothole in the input array
            targetPotholePose = struct.empty;
            for i = 1:numel(allPotholePoses)
                if allPotholePoses(i).ActorID == obj.TargetPotholeID
                    targetPotholePose = allPotholePoses(i);
                    break;
                end
            end

            % If the target pothole somehow disappeared, find a new one and exit
            if isempty(targetPotholePose)
                obj.TargetPotholeID = -1;
                return;
            end
            
            % Calculate vector from ego vehicle to the target pothole
            vecToPothole = [targetPotholePose.X - egoPose.X, targetPotholePose.Y - egoPose.Y];
            
            % Get ego's forward direction vector from its yaw angle
            yawAngle = -egoPose.Yaw + pi/2; % Convert from RR to standard math angle
            forwardVec = [cos(yawAngle), sin(yawAngle)];
            
            % --- Decide what to do ---
            % Check if we have passed the pothole (dot product is negative)
            if dot(vecToPothole, forwardVec) < 0
                % We've passed it. Find the next one, excluding the one we just passed.
                passedPotholeID = obj.TargetPotholeID;
                obj.TargetPotholeID = obj.findNextPothole(egoPose, allPotholePoses, passedPotholeID);
                % If a new one is found, we remain in cruising state. If not, we still cruise.
                vehicleCmd.TargetSpeed = obj.CruisingSpeed;
            else
                % We are still approaching the target pothole. Check the distance.
                distToPothole = norm(vecToPothole);
                if distToPothole <= obj.ActionDistance
                    % We are inside the action radius, so slow down.
                    vehicleCmd.TargetSpeed = obj.PotholeSpeed;
                else
                    % We are outside the action radius, so cruise.
                    vehicleCmd.TargetSpeed = obj.CruisingSpeed;
                end
            end
        end

        %% HELPER METHOD: Finds the closest pothole in front of the vehicle
        function nextPotholeID = findNextPothole(obj, egoPose, allPotholePoses, excludeID)
            minDist = inf;
            nextPotholeID = -1;

            % Get ego's forward direction vector from its yaw angle
            yawAngle = -egoPose.Yaw + pi/2;
            forwardVec = [cos(yawAngle), sin(yawAngle)];
            
            for i = 1:numel(allPotholePoses)
                currentPothole = allPotholePoses(i);
                
                % Skip if this is the pothole we want to exclude
                if currentPothole.ActorID == excludeID
                    continue;
                end

                % Calculate vector from vehicle to this pothole
                vecToPothole = [currentPothole.X - egoPose.X, currentPothole.Y - egoPose.Y];
                
                % Check if the pothole is in front of the vehicle
                if dot(vecToPothole, forwardVec) > 0
                    dist = norm(vecToPothole);
                    if dist < minDist
                        minDist = dist;
                        nextPotholeID = currentPothole.ActorID;
                    end
                end
            end
        end

        %% BOILERPLATE: Define Inputs and Outputs for Simulink
       %% BOILERPLATE: Define Inputs and Outputs for Simulink (Legacy Method)
        function interface = getInterfaceImpl(~)
            import matlab.system.interface.*;
            % Define inputs as Bus Inputs, specifying the bus object name
            in1 = BusInput("egoPose", "slBusActorPose");
            in2 = BusInput("allPotholePoses", "slBusActorPoses");

            % Define output as a Bus Output, specifying our manually created bus
            out1 = BusOutput("vehicleCmd", "slBusActorCommand");

            interface = [in1, in2, out1];
        end
        
        function icon = getIconImpl(~)
            icon = "Pothole Controller";
        end
    end
   
    methods (Access = protected, Static)
        function simMode = getSimulateUsingImpl
            simMode = "Interpreted execution";
        end
    end
end