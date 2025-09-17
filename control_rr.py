import grpc
import subprocess
import os
import time
from pathlib import Path
from mathworks.roadrunner import roadrunner_service_messages_pb2
from mathworks.roadrunner import roadrunner_service_pb2_grpc

SERVER_ADDRESS = "localhost:54321"

print(f"Connecting to RoadRunner at {SERVER_ADDRESS}...")

# Establish a connection
with grpc.insecure_channel(SERVER_ADDRESS) as channel:
    try:
        # Create the API client "stub"
        api = roadrunner_service_pb2_grpc.RoadRunnerServiceStub(channel)

        # Create an instance of the request message
        loadSceneRequest = roadrunner_service_messages_pb2.LoadSceneRequest()
        
        # Set the parameters (fields) for the request
        loadSceneRequest.file_path = "Bridge"
        
        print(f"Requesting to load scene: '{loadSceneRequest.file_path}'")
        
        # Make the remote procedure call
        api.LoadScene(loadSceneRequest)
        
        print("Successfully sent LoadScene request!")

    except grpc.RpcError as e:
        print(f"Could not connect or call the API: {e.details()}")

def launch_roadrunner():
    """Start RoadRunner application using subprocess with correct API flags."""
    print("Python Backend: Launching RoadRunner application...")
    
    # Use your specific executable name
    rr_exe_path = r"C:\Program Files\RoadRunner R2025a\bin\win64\AppRoadRunner.exe"
    project_path = r"C:\ILoveCoding\kyaMATLAB\kyaMATLAB"
    api_port = "54321"
    
    if not os.path.exists(rr_exe_path):
        return False, "RoadRunner executable not found. Please check the path."
        
    try:
        # We use Popen with the correct command-line arguments found by you.
        # This will launch the GUI and start the gRPC server.
        subprocess.Popen([rr_exe_path, "--projectPath", project_path, "--apiPort", api_port])
        
        # Give the application time to start up and listen for gRPC calls
        time.sleep(10)
        
        return True, "RoadRunner launched successfully."
        
    except Exception as e:
        return False, f"Launch error: {str(e)}"



def load_scene_from_file(file_path):
    """
    Loads a .rrscene file into a running RoadRunner instance.
    """
    print(f"Python Backend: Connecting to RoadRunner to load file '{file_path}'")

    if not os.path.exists(file_path):
        return False, f"Error: Scene file not found at {file_path}"
    
    try:
        with grpc.insecure_channel(SERVER_ADDRESS) as channel:
            api = roadrunner_service_pb2_grpc.RoadRunnerServiceStub(channel)

            load_request = roadrunner_service_messages_pb2.LoadSceneRequest()
            load_request.file_path = file_path

            response = api.LoadScene(load_request)

            if response.status_code == 0:
                return True, f"SUCCESS: Scene loaded from '{Path(file_path).name}'."
            else:
                return False, f"RoadRunner API Error: {response.message}"
    except grpc.RpcError as e:
        return False, f"gRPC Connection Error: {e.details()}"
    except Exception as e:
        return False, f"An unexpected error occurred: {str(e)}"

def export_to_roadrunner(file_path):
    """
    Imports a road network file into a currently running RoadRunner instance.
    This function uses the gRPC API for communication.
    
    Args:
        file_path (str): The full path to the .osm or .xodr file.

    Returns:
        tuple: (bool, str) - A tuple indicating success and a message.
    """
    print(f"Python Backend: Connecting to RoadRunner at {SERVER_ADDRESS} to import file...")

    try:
        # Establish an insecure gRPC channel to the RoadRunner server
        with grpc.insecure_channel(SERVER_ADDRESS) as channel:
            # Create a gRPC client stub
            api = roadrunner_service_pb2_grpc.RoadRunnerServiceStub(channel)

            # Create an ImportRoadNetworkRequest message
            import_request = roadrunner_service_messages_pb2.ImportRoadNetworkRequest()
            import_request.file_path = file_path
            
            # Send the request to RoadRunner
            response = api.ImportRoadNetwork(import_request)

            # The response message contains a success/failure status and a message
            if response.status_code == 0:
                return True, f"SUCCESS: '{os.path.basename(file_path)}' imported."
            else:
                return False, f"RoadRunner API Error: {response.message}"
                
    except grpc.RpcError as e:
        return False, f"gRPC Connection Error: {e.details()}"
    except Exception as e:
        return False, f"General Python Error: {str(e)}"
    
__all__ = ['export_to_roadrunner', 'launch_roadrunner', 'load_scene']