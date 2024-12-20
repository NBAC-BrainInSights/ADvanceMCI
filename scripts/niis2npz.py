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
output_name= args.arg2

# Directory containing your .nii.gz files
# data_dir = '/home/mnili/tmp/oasis/mask_GM_WM_64'
# data_dir = /home/mnili/tmp/ADNI_safi/mask_GM_WM_64/pMCI_safi
# Initialize lists to store data and metadata
data_list = []
file_names = []

# Iterate over all .nii.gz files in the directory
for filename in os.listdir(data_dir):    
    # Load the .nii.gz file
    nii_path = os.path.join(data_dir, filename)
    img = nib.load(nii_path)
    img_data = img.get_fdata()

    # Append the data to the list and metadata to the dictionary
    data_list.append(img_data)
    file_names.append(filename)

# Convert the list to a NumPy array (shape: 1200, 64, 64, 64)
data_array = np.array(data_list)

# Save the data and metadata to a .npz file
np.savez_compressed(f"{output_name}.npz", data=data_array)

# Save the file names to a CSV file
with open(f"{output_name}.csv", 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['file_name'])  # Write the header
    for filename in file_names:
        writer.writerow([filename])  # Write each file name in a new row

print(f"Saved {len(data_list)} files to 'data.npz'")