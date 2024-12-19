import nibabel as nib
import numpy as np
import os

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('data_dir', type=str, help='Input string for processing')
args = parser.parse_args()
data_dir = args.input

for filename in os.listdir(data_dir):    
    # Load the .nii.gz file
    img=nib.load(os.path.join(data_dir, filename,'mri/mask.mgz'))
    nib.save(img,os.path.join(data_dir, filename,'mri/mask.nii.gz'))
    brain_mask = nib.load(os.path.join(data_dir, filename,'mri/mask.nii.gz')).get_fdata()
    gmwm_mask = nib.load(os.path.join(data_dir, filename,'mri/GM_WM_mask.nii.gz')).get_fdata()
    tissue_sum = np.sum((gmwm_mask) * brain_mask)
    if(tissue_sum<5000):
        print(filename,tissue_sum)