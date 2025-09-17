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

def launch_roadrunner():
    """Start RoadRunner application using subprocess with correct API flags."""
    print("Python Backend: Launching RoadRunner application...")
    
    # Use your specific executable name
    rr_exe_path = r"C:\Program Files\RoadRunner R2025a\bin\win64\AppRoadRunner.exe"
    project_path = r"C:\codes\SIH\kyaMATLAB"
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

def load_scene(scene_name):
    """
    Loads a pre-existing RoadRunner scene.

    Args:
        scene_name (str): The name of the scene to load (e.g., 'Urban Canyon').

    Returns:
        tuple: (bool, str) - A tuple indicating success and a message.
    """
    print(f"Python Backend: Connecting to RoadRunner to load scene '{scene_name}'")

    try:
        with grpc.insecure_channel(SERVER_ADDRESS) as channel:
            api = roadrunner_service_pb2_grpc.RoadRunnerServiceStub(channel)

            load_request = roadrunner_service_messages_pb2.LoadSceneRequest()
            load_request.file_path = scene_name

            api.LoadScene(load_request)
            return True, f"SUCCESS: Scene '{scene_name}' loaded successfully."
        
    except grpc.RpcError as e:
        return False, f"gRPC Error ({e.code()}): {e.details()}"
    except Exception as e:
        return False, f"General Python Error: {str(e)}"

def convert_osm_to_xodr(osm_file_path):
    """
    Converts an .osm file to an .xodr file using SUMO's netconvert tool.
    Returns the path to the new .xodr file or an error message.
    """
    print(f"Python Backend: Converting '{os.path.basename(osm_file_path)}' to OpenDRIVE...")
    
    xodr_file_path = os.path.splitext(osm_file_path)[0] + ".xodr"
    
    try:
        # Command for the subprocess call
        command = [
            "netconvert",
            "--osm-files", osm_file_path,
            "--opendrive-output", xodr_file_path,
            #"--offset.disable-normalization", "true",
            "--proj.scale", "1",
            "--output.street-names", "true",
        ]
        
        result = subprocess.run(command, check=True, capture_output=True, text=True)
        print(f"Python Backend: Conversion successful. Output at '{xodr_file_path}'")
        return xodr_file_path, None
        
    except FileNotFoundError:
        error_msg = "Conversion failed: 'netconvert' command not found. Is SUMO installed and in your system PATH?"
        print(f"Python Backend: {error_msg}")
        return None, error_msg
        
    except subprocess.CalledProcessError as e:
        error_msg = f"Conversion failed with error: {e.stderr}"
        print(f"Python Backend: {error_msg}")
        return None, error_msg

def export_to_roadrunner(file_path):
    """
    Imports a road network file. If it's an .osm file, it first
    converts it to .xodr and then imports it into RoadRunner.
    """
    print(f"Python Backend: Starting import process for '{file_path}'...")
    
    file_to_import = file_path
    format_name = ""
    
    _, file_extension = os.path.splitext(file_path)
    
    if file_extension.lower() == ".osm":
        # Step 1: Convert the .osm file
        converted_path, error = convert_osm_to_xodr(file_path)
        if error:
            return False, error # Return the conversion error message
        file_to_import = converted_path
        format_name = "OpenDRIVE" # The format is now OpenDRIVE
        
    elif file_extension.lower() == ".xodr":
        format_name = "OpenDRIVE"
        
    else:
        return False, f"Unsupported file type: {file_extension}"

    # Step 2: Import the file (which is now guaranteed to be .xodr) into RoadRunner
    print(f"Python Backend: Importing '{os.path.basename(file_to_import)}' into RoadRunner...")
    
    try:
        with grpc.insecure_channel(SERVER_ADDRESS) as channel:
            # Create a gRPC client stub
            api = roadrunner_service_pb2_grpc.RoadRunnerServiceStub(channel)

            request = roadrunner_service_messages_pb2.ImportRequest()
            request.file_path = file_to_import
            request.format_name = format_name
            
            api.Import(request)
            
            return True, f"SUCCESS: '{os.path.basename(file_to_import)}' imported successfully."
            
    except grpc.RpcError as e:
        return False, f"gRPC Error ({e.code()}): {e.details()}"
    except Exception as e:
        return False, f"General Python Error: {str(e)}"
    
__all__ = ['export_to_roadrunner', 'launch_roadrunner', 'load_scene']