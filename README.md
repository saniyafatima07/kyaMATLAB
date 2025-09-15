# kyaMATLAB

This project demonstrates how to programmatically control a **MathWorks RoadRunner** simulation using its **gRPC API** with Python. The included example script (`control_rr.py`) connects to a running RoadRunner instance, loads a scene, and prepares for simulation control.

!(https://www.mathworks.com/help/roadrunner/r2025a/examples/rr_custom_api/xxrr_custom_api_01.png)

## Prerequisites

Before you begin, ensure you have the following installed on your system:

* **MathWorks RoadRunner R2025a** (or a compatible version).
* **Python 3.8+**
* **Git** for cloning the repository.

---

## Getting Started

Follow these steps to set up and run the project.

### 1. Clone the Repository

First, clone this repository to your local machine:

```bash
git clone <your-repository-url>
cd kyaMATLAB
```

### 2. Set Up the Python Environment

It's highly recommended to use a virtual environment to manage project dependencies.

```powershell
# Create a virtual environment named 'venv'
python -m venv venv

# Activate the virtual environment
# On Windows (PowerShell):
.\venv\Scripts\Activate.ps1

# On macOS/Linux:
# source venv/bin/activate
```

### 3. Install Dependencies

Install the required Python packages using the `requirements.txt` file.

```powershell
# Ensure your virtual environment is active
pip install -r requirements.txt
```

### 4. Generate gRPC Code

The project communicates with RoadRunner using gRPC. You need to generate the necessary Python interface code from the `.proto` files provided with your RoadRunner installation.

Run the following command from the root directory of this project (`C:\codes\SIH\kyaMATLAB` in your example).

**Note:** You must replace `"C:\Program Files\RoadRunner R2025a"` with the actual installation path of RoadRunner on your system.

```powershell
python -m grpc_tools.protoc --proto_path="C:\Program Files\RoadRunner R2025a\bin\win64\Proto" --python_out=. --pyi_out=. --grpc_python_out=. mathworks/roadrunner/core.proto mathworks/roadrunner/export_settings.proto mathworks/roadrunner/import_settings.proto mathworks/roadrunner/roadrunner_service.proto mathworks/roadrunner/roadrunner_service_messages.proto mathworks/scenario/common/geometry.proto mathworks/scenario/common/array.proto
```

This command generates the necessary `*_pb2.py`, `*_pb2.pyi`, and `*_pb2_grpc.py` files inside the `mathworks/` directory. **This step only needs to be done once.**

---

## ධ Running the Simulation

The process involves two main steps: starting the RoadRunner application with the API enabled, and then running the Python control script.

### Step 1: Start RoadRunner via Command Line

1.  Open a new terminal or PowerShell window.
2.  Navigate to your RoadRunner installation directory.
    ```powershell
    cd "C:\Program Files\RoadRunner R2025a\bin\win64"
    ```
3.  Start the `AppRoadRunner` application, pointing it to this project's directory and specifying an API port. **Replace the `--projectPath` with the absolute path to your cloned `kyaMATLAB` folder.**

    ```powershell
    .\AppRoadRunner --projectPath C:\codes\SIH\kyaMATLAB --apiPort 54321
    ```
    RoadRunner will now launch and load the specified project.

### Step 2: Execute the Python Control Script

1.  Go back to the terminal where you activated the Python virtual environment (from the setup steps).
2.  Run the main control script:

    ```powershell
    # Make sure you are in the project root and (venv) is active
    python control_rr.py
    ```

The script will connect to the RoadRunner instance on port `54321`, load the `FourWaySignal` scene, and print a success message. You can now modify `control_rr.py` to add more complex simulation logic.

---

## 📁 Project Structure

A brief overview of the key files and directories:

```
└── 📁kyaMATLAB
    ├── 📁Assets/             # Contains all assets (vehicles, materials, props) for the RR project.
    ├── 📁Scenes/             # Contains the simulation scenes, like FourWaySignal.rrscene.
    ├── 📁Scenarios/          # Contains simulation scenarios.
    ├── 📁mathworks/          # Auto-generated Python gRPC interface files.
    ├── 📁venv/               # Python virtual environment folder.
    ├── control_rr.py         # The main Python script to control the simulation.
    ├── requirements.txt      # A list of Python package dependencies for the project.
    └── README.md             # This file.
```

---

## ⚖️ License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.