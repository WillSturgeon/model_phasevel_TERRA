#!/bin/bash

# Configuration
TIMEOUT=10  # Timeout in seconds
#MODEL_LIST='../TERRA_modellist_overtones.txt'  # Path to your list of models
MODEL_LIST='../TERRA_modellist_June2025.txt'  # Path to your list of models
#MODEL_LIST='../SEMUCB.txt'  # Path to your list of models
COORD_LIST='../TERRA_filelist.txt'  # Path to your list of profiles
#COORD_LIST='/home/will/Documents/rapid_mineos/SEMUCB_mineos_profiles/modelList.txt'

# Loop through each model in the model list
while IFS= read -r TERRA_MODEL; do
    echo "starting"
    echo TERRA model === ${TERRA_MODEL}

    # Prepare the timeout log filename
    TERRA_MODEL_CLEAN="${TERRA_MODEL//\//_}"  # Replace slashes with underscores for filename
    TERRA_MODEL_CLEAN="${TERRA_MODEL_CLEAN%_}"  # Remove trailing underscore
    TERRA_MODEL_CLEAN="${TERRA_MODEL_CLEAN#_}"  # Remove leading underscore
    TIMEOUT_LOG="${TERRA_MODEL_CLEAN}_timeouts.log"  # Final log file name

    # Ensure the timeout log file is empty initially
    > "$TIMEOUT_LOG"

    # Export model path and timeout log for access in parallel subshells
    export TERRA_MODEL TIMEOUT_LOG TIMEOUT

    # Define a function to run for each line
    process_line() {
      COORD=$1
      #echo "Processing profile: $TERRA_MODEL $COORD"
      # Run the Fortran program with a timeout
      timeout $TIMEOUT ./rapid_mineos "$TERRA_MODEL" "$COORD"
      if [ $? -eq 124 ]; then  # Check if timeout occurred
        echo "Timeout occurred for $COORD"
        echo "$TERRA_MODEL $COORD" >> "$TIMEOUT_LOG"
      else
        echo "Completed processing $COORD at model $TERRA_MODEL"
      fi
    }
    export -f process_line  # Export the function for parallel to use

    # Use GNU parallel to read each line from the COORD_LIST and process it
    parallel -j 40 process_line :::: "$COORD_LIST"

    # Check if any timeouts were recorded
    if [ -s "$TIMEOUT_LOG" ]; then
      echo "Timeouts were recorded in $TIMEOUT_LOG"
    else
      echo "No timeouts occurred."
      rm "$TIMEOUT_LOG"  # Optionally remove the log if it's empty
    fi

done < "$MODEL_LIST"