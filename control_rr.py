import grpc
import subprocess
import os
import time
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

def start_roadrunner():
    """Start RoadRunner application"""
    rr_path = r"C:\Program Files\RoadRunner R2025a\bin\win64\RoadRunner.exe"
    if os.path.exists(rr_path):
        subprocess.Popen([rr_path])
        time.sleep(5)  # Wait for startup
        return True, "RoadRunner started"
    return False, "RoadRunner executable not found"

def export_to_roadrunner(file_path):
    """Launch RoadRunner with file - SIMPLE and WORKS"""
    print(f"Python: Opening {file_path} in RoadRunner")
    
    try:

        possible_paths = [
            r"C:\Program Files\RoadRunner R2025a\bin\win64\AppRoadRunner.exe",
            r"C:\Program Files (x86)\RoadRunner R2025a\bin\win64\AppRoadRunner.exe",
        ]
        
        rr_path = None
        for path in possible_paths:
            if os.path.exists(path):
                rr_path = path
                break
        
        if rr_path:
            subprocess.Popen([rr_path, file_path])
            return True, f"SUCCESS: RoadRunner launched with {os.path.basename(file_path)}"
        else:
            return False, f"RoadRunner not found. Check installation at: {possible_paths[0]}"
            
    except Exception as e:
        return False, f"Launch error: {str(e)}"

# Only export function - assumes RoadRunner already running
__all__ = ['export_to_roadrunner']