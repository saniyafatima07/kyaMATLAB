import grpc
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
        loadSceneRequest.file_path = "FourWaySignal"
        
        print(f"Requesting to load scene: '{loadSceneRequest.file_path}'")
        
        # Make the remote procedure call
        api.LoadScene(loadSceneRequest)
        
        print("Successfully sent LoadScene request!")

    except grpc.RpcError as e:
        print(f"Could not connect or call the API: {e.details()}")