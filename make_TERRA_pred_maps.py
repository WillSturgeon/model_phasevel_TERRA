import os
import subprocess
import sys

# Check for command line arguments
if len(sys.argv) != 2:
    print("Usage: python run_script.py <model_name>")
    sys.exit(1)

# The model name is taken from the command line input
model_name = sys.argv[1]

# Base directory setup
#base_directory = "/media/will/will_green/xTERRA/"
base_directory = "/media/will/WS/"
model_directory = os.path.join(base_directory, model_name)
filelist_path = os.path.join(model_directory, "filelist_interp_0S.txt")

# Delete filelist_interp.txt if it exists
if os.path.exists(filelist_path):
    os.remove(filelist_path)

# Delete any existing files that include 'mode_0S'
for filename in os.listdir(model_directory):
    if 'mode_0S' in filename:
        os.remove(os.path.join(model_directory, filename))

# Generate the file list, ensuring only file names are included, not paths
command = f"find {model_directory} -maxdepth 1 -type f -name '*0S_pred_CRUST1_interp_0S.txt*' -exec basename {{}} \\;"
filelist_output = subprocess.run(command, shell=True, capture_output=True, text=True)
with open(filelist_path, 'w') as filelist_file:
    filelist_file.write(filelist_output.stdout)

# Define necessary parameters for seismic data processing
modes = [28, 35, 43, 51, 61, 72, 84, 98, 112, 127, 144, 161, 179, 198, 216, 235, 253, 271]
PREM_periods = [275.1208, 234.5631, 200.8373, 175.3934, 151.1929, 131.0968, 114.3725, 99.4548, 87.9076, 78.1288, 69.3406, 62.3046, 56.2472, 51.0080, 46.8738, 43.1854, 40.1969, 37.6036]
PREM_phasevel = [5.0941, 4.7967, 4.5724, 4.4229, 4.2972, 4.2047, 4.1359, 4.0814, 4.044, 4.0159, 3.9936, 3.9779, 3.9655, 3.9554, 3.9474, 3.9397, 3.9328, 3.926]
PREM_grvel = [3.6210, 3.5611, 3.5825, 3.6193, 3.6594, 3.6940, 3.7247, 3.7552, 3.7818, 3.8056, 3.8263, 3.8405, 3.8488, 3.8512, 3.8484, 3.8409, 3.8299, 3.8156]
PREM_Q = [190.8221, 168.3270, 152.8315, 142.2297, 132.7560, 125.7131, 121.1311, 118.9656, 119.4160, 122.1749, 127.6063, 135.1345, 145.1897, 158.0455, 172.3485, 189.7279, 208.3966, 229.2304]

# Process for each mode
for mode in modes:
    data_list = []
    with open(filelist_path, 'r') as filelist:
        for filename in filelist.readlines():
            filename = filename.strip()
            if filename:
                file_path = os.path.join(model_directory, filename)
                with open(file_path, 'r') as infile:
                    for line in infile:
                        parts = line.strip().split()
                        if len(parts) >= 6 and int(parts[1]) == mode:
                            period_TERRA = float(parts[2])
                            phase_velocity = float(parts[3])
                            group_velocity = float(parts[4])
                            attenuation = float(parts[5])
                            lat_long = filename.split('_')[:2]
                            latitude, longitude = map(float, lat_long)
                            mode_index = modes.index(mode)
                            prem_phase_vel = PREM_phasevel[mode_index]
                            prem_gr_vel = PREM_grvel[mode_index]
                            prem_Q = PREM_Q[mode_index]

                            perturbation_phase = ((phase_velocity - prem_phase_vel) / prem_phase_vel) * 100
                            perturbation_group = ((group_velocity - prem_gr_vel) / prem_gr_vel) * 100
                            perturbation_attenuation = ((attenuation - prem_Q) / prem_Q) * 100
                            data_list.append((longitude, latitude, period_TERRA, phase_velocity, group_velocity, attenuation, perturbation_phase, perturbation_group, perturbation_attenuation))

    # Sort data_list by longitude, then latitude
    data_list.sort(key=lambda x: (x[0], x[1]))

    if data_list:
        first_period_TERRA = data_list[0][2]
        formatted_first_period_TERRA = f"{first_period_TERRA:.4f}"

        # Construct output filenames and prepare output files
        output_filenames = {
            "phase_velocity": f"mode_0S{mode}_{formatted_first_period_TERRA}_phase_velocity_CRUST1_interp_0S.txt",
            "phase_velocity_perturbation": f"mode_0S{mode}_{formatted_first_period_TERRA}_phase_velocity_perturbation_CRUST1_interp_0S.txt",
            "group_velocity": f"mode_0S{mode}_{formatted_first_period_TERRA}_group_velocity_CRUST1_interp_0S.txt",
            "attenuation": f"mode_0S{mode}_{formatted_first_period_TERRA}_attenuation_CRUST1_interp_0S.txt",
            "group_velocity_perturbation": f"mode_0S{mode}_{formatted_first_period_TERRA}_group_velocity_perturbation_CRUST1_interp_0S.txt",
            "attenuation_perturbation": f"mode_0S{mode}_{formatted_first_period_TERRA}_attenuation_perturbation_CRUST1_interp_0S.txt"
        }

        output_files = {key: open(os.path.join(model_directory, filename), 'w') for key, filename in output_filenames.items()}

        # Write sorted data to output files
        for entry in data_list:
            output_files["phase_velocity"].write(f"{entry[0]:>10} {entry[1]:>10} {entry[3]:>15.5f}\n")
            output_files["phase_velocity_perturbation"].write(f"{entry[0]:>10} {entry[1]:>10} {entry[6]:>15.5f}\n")
            output_files["group_velocity"].write(f"{entry[0]:>10} {entry[1]:>10} {entry[4]:>15.5f}\n")
            output_files["attenuation"].write(f"{entry[0]:>10} {entry[1]:>10} {entry[5]:>15.5f}\n")
            output_files["group_velocity_perturbation"].write(f"{entry[0]:>10} {entry[1]:>10} {entry[7]:>15.5f}\n")
            output_files["attenuation_perturbation"].write(f"{entry[0]:>10} {entry[1]:>10} {entry[8]:>15.5f}\n")

        # Close all output files
        for file in output_files.values():
            file.close()
