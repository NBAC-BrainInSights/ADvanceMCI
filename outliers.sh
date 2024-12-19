#!/bin/bash

# Check if the data directory is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <data_dir>"
    exit 1
fi

data_dir=$1

# Loop through all directories in the provided data_dir
for subject_dir in ${data_dir}/*; do
    if [ -d "$subject_dir" ]; then
        # Define the paths for the files
        mask_mgz="${subject_dir}/mri/mask.mgz"
        mask_nii="${subject_dir}/mri/mask.nii.gz"
        gmwm_mask="${subject_dir}/mri/GM_WM_mask.nii.gz"

        # Check if the necessary files exist
        if [ -f "$mask_mgz" ] && [ -f "$gmwm_mask" ]; then
            # Convert the .mgz file to .nii.gz
            mri_convert "$mask_mgz" "$mask_nii"
            
            # Check if conversion was successful
            if [ ! -f "$mask_nii" ]; then
                echo "Failed to convert $mask_mgz to $mask_nii"
                continue
            fi

            # Perform the sum of the tissue mask
            tissue_sum=$(fslmaths "$mask_nii" -mul "$gmwm_mask" -sum)

            # If the tissue sum is less than 5000, print the filename and sum
            if (( $(echo "$tissue_sum < 5000" | bc -l) )); then
                echo "$subject_dir $tissue_sum"
            fi
        else
            echo "Missing files in $subject_dir"
        fi
    fi
done
