import nibabel as nib
import numpy as np
import os
import re
import csv
import argparse

parser = argparse.ArgumentParser(description="Print two arguments passed to the script.")

# Add arguments
parser.add_argument('arg1', type=str, help='First argument (string)')
parser.add_argument('arg2', type=str, help='Second argument (string)')

# Parse the arguments
args = parser.parse_args()

# Access and print the arguments
data_dir= args.arg1
output_dir= args.arg2

# Iterate over all .nii.gz files in the directory
for filename in os.listdir(data_dir):    
    # Load the .nii.gz file
    nii_path = os.path.join(data_dir, filename)
    img = nib.load(nii_path)
    img_data = img.get_fdata()
    normalized_data = (img_data - np.min(img_data)) / (np.max(img_data) - np.min(img_data))

    normalized_img = nib.Nifti1Image(normalized_data, img.affine)
    nib.save(normalized_img, os.path.join(output_dir, f"{filename}_normalized.nii.gz"))