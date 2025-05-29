import numpy as np
import os
import subprocess
import multiprocessing

# This script interpolates the data to the exact periods at which the observed data (e.g. PREM or hvh2) is provided.
# This script can run in parralel, defined on line 81. e.g. to 20 processes, set (pool = multiprocessing.Pool(processes=20))

# Setup directory and PREM data
# base_directory is where the phase vel/group vel/attenuation TERRA prediction files are located.
base_directory = "/Volumes/Monika/convert/"
# model_list_path is a list of the TERRA models that you want to run.
model_list_path = "/TERRA_modellist.txt"

# Modes and their corresponding PREM periods
modes = [28, 35, 43, 51, 61, 72, 84, 98, 112, 127, 144, 161, 179, 198, 216, 235, 253, 271]
PREM_periods = [275.5512, 234.9498, 201.1721, 175.6817, 151.4316, 131.2899, 114.5240, 99.5632, 87.9847, 78.1786, 69.3657, 62.3103, 56.2370, 50.9849, 46.8415, 43.1459, 40.1526, 37.5560]

def process_model(model):
    model_directory = os.path.join(base_directory, model)
    print(f'----- Processing: {model_directory}')
    
    filelist_path = os.path.join(model_directory, "filelist.txt")
    
    if os.path.exists(filelist_path):
        os.remove(filelist_path)
        print(f"Deleted existing filelist.txt at {filelist_path}")

    for file in os.listdir(model_directory):
        if "interp.txt" in file:
            os.remove(os.path.join(model_directory, file))
            print(f"Deleted {file} in {model_directory}")

    command = f"ls -1 {model_directory} | grep -v 'filelist.txt'"
    filelist_output = subprocess.run(command, shell=True, capture_output=True, text=True)
    with open(filelist_path, 'w') as filelist_file:
        filelist_file.write(filelist_output.stdout)

    with open(filelist_path, 'r') as filelist:
        for filename in filelist.readlines():
            filename = filename.strip()
            file_path = os.path.join(model_directory, filename)
            output_file_path = os.path.join(model_directory, os.path.splitext(filename)[0] + "_interp.txt")

            coords, mode, TERRA_period, phase_vel, group_vel, attenuation = [], [], [], [], [], []
            with open(file_path, 'r') as infile:
                for line in infile:
                    parts = line.strip().split()
                    if len(parts) < 6:
                        continue
                    try:
                        mode_val = int(parts[1])
                        if 10 <= mode_val <= 300:
                            coords.append(parts[0])
                            mode.append(mode_val)
                            TERRA_period.append(float(parts[2]))
                            phase_vel.append(float(parts[3]))
                            group_vel.append(float(parts[4]))
                            attenuation.append(float(parts[5]))
                    except ValueError:
                        print(f"Skipping invalid data in {filename}: {line.strip()}")
                        continue
            
            if len(TERRA_period) != len(attenuation):
                print(f"Error: Mismatched data lengths in {filename}. TERRA periods: {len(TERRA_period)}, Attenuations: {len(attenuation)}")
                continue
            
            interpolated_phase_velocities = np.interp(PREM_periods, TERRA_period[::-1], phase_vel[::-1])
            interpolated_group_velocities = np.interp(PREM_periods, TERRA_period[::-1], group_vel[::-1])
            interpolated_attenuations = np.interp(PREM_periods, TERRA_period[::-1], attenuation[::-1])

            with open(output_file_path, 'w') as outfile:
                for m, p, pv, gv, at in zip(modes, PREM_periods, interpolated_phase_velocities, interpolated_group_velocities, interpolated_attenuations):
                    outfile.write(f"{model} {m} {p} {pv} {gv} {at}\n")

def main():
    with open(model_list_path, 'r') as model_list_file:
        models = [line.strip() for line in model_list_file.readlines() if line.strip()]

    #pool = multiprocessing.Pool(processes=multiprocessing.cpu_count())  # Create a pool of processes
    pool = multiprocessing.Pool(processes=20)

    pool.map(process_model, models)  # Map process_model function to all models
    pool.close()  # Close the pool
    pool.join()  # Wait for all processes to finish
 
if __name__ == "__main__":
    main()
