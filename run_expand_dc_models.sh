#!/bin/bash
# this subroutine expands velocity models delta_x/x in spherical harmonics

dir="/media/will/will_green/xTERRA/muller_visc/m_visc1/"

XYZINFILE="xyzinfile"

# Array of modes to process
# modes=(
#     "0S112_87.9076" "0S127_78.1288" "0S144_69.3406" "0S161_62.3046"
#     "0S179_56.2472" "0S198_51.0080" "0S216_46.8738" "0S235_43.1854"
#     "0S253_40.1969" "0S271_37.6036" "0S28_275.1208" "0S35_234.5631"
#     "0S43_200.8373" "0S51_175.3934" "0S61_151.1929" "0S72_131.0968"
#     "0S84_114.3725" "0S98_99.4548")

 modes=(
    "0S198_50.9849" "0S112_87.9847" "0S127_78.1786" "0S144_69.3657"
    "0S161_62.3103" "0S179_56.2370" "0S216_46.8415" "0S235_43.1459"
    "0S271_37.5560" "0S253_40.1526" "0S28_275.5512" "0S35_234.9498"
    "0S43_201.1721" "0S51_175.6817" "0S61_151.4316" "0S72_131.2899"
    "0S84_114.5240" "0S98_99.5632")

# Loop through each mode
for mode in "${modes[@]}"; do
    # Extract the short mode name (e.g., "0S112" from "0S112_87.9076")
    short_mode="${mode%%_*}"  # Removes everything after the first underscore

    # Check if numeric part of mode needs zero padding (for 0S28 to 0S98)
    mode_num=${short_mode#0S}  # Extract the numeric part of the mode
    if [[ $mode_num -lt 100 ]]; then
        # Pad with zeros to make it three digits
        padded_mode_num=$(printf "%03d" $mode_num)
        short_mode="0S${padded_mode_num}"
    fi

    # Construct the input file path
    infile="${dir}mode_${mode}_dc_CORRECT_COORDS_v2.txt"
    
    # Construct the output file name for the third column, using short_mode, without .txt extension
    outfile="${dir}${short_mode}_CCv2" 


    # Extract only the third column and save it to the outfile
    awk '{print $3}' "$infile" > "$outfile"

    echo "Processing file: $outfile"

    # Use the outfile with the expand command
    # Make sure to adjust the path to the expand command as necessary
    build/bin/expand "$outfile" -lmax 40


    echo ${outfile}.sph2 > ${XYZINFILE}
    echo ${outfile}_testing.xyz >> ${XYZINFILE}
    echo 2 >> ${XYZINFILE} 		    #dc contour level
    echo 0.01 >> ${XYZINFILE}	     #1=*100, 0.01=not
    echo 1 $LMAX >> ${XYZINFILE}
    echo 2 >> ${XYZINFILE}

    build/bin/raw2xyz_jr < ${XYZINFILE}
    
done

echo "All files processed."