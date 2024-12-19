import os
import nibabel as nib
import numpy as np
import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('data_dir', type=str, help='Input string for processing')
args = parser.parse_args()
root_dir = args.input

# Iterate over all subject directories
for subject_dir in os.listdir(root_dir):
    subject_path = os.path.join(root_dir, subject_dir)
    
    # Ensure it is a directory
    if not os.path.isdir(subject_path):
        continue

    # Define the MRI directory within each subject
    mri_dir = os.path.join(subject_path, "mri")
    if not os.path.exists(mri_dir):
        print(f"MRI directory not found for subject {subject_dir}")
        continue

    # File paths for aseg and orig_nu
    aseg_path = os.path.join(mri_dir, "aseg.auto_noCCseg.mgz")
    t1_path = os.path.join(mri_dir, "orig_nu.mgz")

    # Ensure required files exist
    if not os.path.exists(aseg_path) or not os.path.exists(t1_path):
        print(f"Missing required files for subject {subject_dir}")
        continue

    try:
        # Load aseg and create the mask
        aseg = nib.load(aseg_path)
        aseg_data = aseg.get_fdata()
        mask = (aseg_data >= 2) & (aseg_data <= 77) & ~np.isin(aseg_data, [14, 15, 24, 4, 5, 43, 44])
        # 0   Unknown
        # 1   Left-Cerebral-Exterior
        # 4   Left-Lateral-Ventricle
        # 5   Left-Inf-Lat-Vent
        # 14  3rd-Ventricle
        # 15  4th-Ventricle
        # 24  CSF
        # 43  Right-Lateral-Ventricle
        # 44  Right-Inf-Lat-Vent

        # Save the mask
        mask_img = nib.Nifti1Image(mask.astype(np.uint8), aseg.affine, aseg.header)
        mask_path = os.path.join(mri_dir, "GM_WM_mask.nii.gz")
        nib.save(mask_img, mask_path)

        # Load T1 and apply the mask
        t1 = nib.load(t1_path)
        t1_data = t1.get_fdata()
        masked_t1 = t1_data * mask

        # Save the masked T1 image
        masked_t1_img = nib.Nifti1Image(masked_t1, t1.affine, t1.header)
        masked_t1_path = os.path.join(mri_dir, "T1w_GM_WM_only.nii.gz")
        nib.save(masked_t1_img, masked_t1_path)

        print(f"Processed subject {subject_dir}: Mask saved at {mask_path}, T1 masked at {masked_t1_path}")
    except Exception as e:
        print(f"Error processing subject {subject_dir}: {e}")