import grpc
import subprocess
import os
import time
import pyautogui
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

def import_via_gui(osm_file_path):
    """
    Imports an .osm file by automating the SD Map Viewer Tool workflow.
    This version has longer delays for increased reliability.
    """
    try:
        print("Python Backend: Starting GUI automation for SD Map Viewer...")

        # !!! CRITICAL: Ensure these coordinates are correct for your screen !!!
        SD_MAP_VIEWER_ICON_POS = (1166, 161)   # X, Y of the "SD Map Viewer Tool" icon
        OSM_ICON_POS           = (30, 280)  # X, Y of the "Open OpenStreetMap file" icon

        print("You have 5 seconds to click on the main RoadRunner window to make it active...")
        time.sleep(5) # Increased initial delay

        # 1. Click the "SD Map Viewer Tool" icon
        print(f"Clicking SD Map Viewer Tool at {SD_MAP_VIEWER_ICON_POS}...")
        pyautogui.click(SD_MAP_VIEWER_ICON_POS)
        pyautogui.click(SD_MAP_VIEWER_ICON_POS)
        time.sleep(4) # Increased delay to allow the viewer to open fully

        # 2. Click the "Open OpenStreetMap file" icon
        print(f"Clicking OpenStreetMap file icon at {OSM_ICON_POS}...")
        pyautogui.click(OSM_ICON_POS)
        pyautogui.click(OSM_ICON_POS)
        time.sleep(4) # Increased delay to allow the file dialog to open and become active

        # 3. Type the full path to the .osm file
        print(f"Typing file path: {osm_file_path}")
        pyautogui.write(osm_file_path, interval=0.05) # Slightly slower typing
        time.sleep(2)

        # 4. Press Enter to confirm the import
        print("Pressing Enter...")
        pyautogui.press('enter')
        
        print("Python Backend: GUI automation commands sent successfully.")
        return True, "SUCCESS: GUI import process initiated via SD Map Viewer."

    except Exception as e:
        return False, f"GUI Automation Error: {str(e)}"

__all__ = ['import_via_gui', 'launch_roadrunner', 'load_scene']