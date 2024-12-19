#!/bin/bash

# Usage: ./process_mri.sh <input_directory>

# Check for required argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <input_directory>"
  exit 1
fi

INPUT_DIR="$1"

# Iterate over all subject directories
for SUBJECT_DIR in "$INPUT_DIR"/*; do
  if [ ! -d "$SUBJECT_DIR" ]; then
    continue
  fi

  # Define the MRI directory within each subject
  MRI_DIR="$SUBJECT_DIR/mri"
  if [ ! -d "$MRI_DIR" ]; then
    echo "MRI directory not found for subject $(basename "$SUBJECT_DIR")"
    continue
  fi

  # File paths for aseg and orig_nu
  ASEG_PATH="$MRI_DIR/aseg.auto_noCCseg.mgz"
  T1_PATH="$MRI_DIR/orig_nu.mgz"

  # Ensure required files exist
  if [ ! -f "$ASEG_PATH" ] || [ ! -f "$T1_PATH" ]; then
    echo "Missing required files for subject $(basename "$SUBJECT_DIR")"
    continue
  fi

  # Convert aseg to NIfTI
  ASEG_NIFTI="$MRI_DIR/aseg.nii.gz"
  mri_convert "$ASEG_PATH" "$ASEG_NIFTI"

  # Create the mask using FSL's fslmaths
  MASK_PATH="$MRI_DIR/GM_WM_mask.nii.gz"
  fslmaths "$ASEG_NIFTI" \
    -thr 2 -uthr 77 \
    -bin \
    -sub $(fslmaths "$ASEG_NIFTI" -uthr 15 -thr 14 -bin -add 0) \
    -sub $(fslmaths "$ASEG_NIFTI" -uthr 24 -thr 24 -bin -add 0) \
    -sub $(fslmaths "$ASEG_NIFTI" -uthr 44 -thr 43 -bin -add 0) \
    "$MASK_PATH"

    # 0   Unknown
    # 1   Left-Cerebral-Exterior
    # 4   Left-Lateral-Ventricle
    # 5   Left-Inf-Lat-Vent
    # 14  3rd-Ventricle
    # 15  4th-Ventricle
    # 24  CSF
    # 43  Right-Lateral-Ventricle
    # 44  Right-Inf-Lat-Vent
    
  if [ $? -ne 0 ]; then
    echo "Error creating mask for subject $(basename "$SUBJECT_DIR")"
    continue
  fi

  # Convert T1 to NIfTI
  T1_NIFTI="$MRI_DIR/orig_nu.nii.gz"
  mri_convert "$T1_PATH" "$T1_NIFTI"

  # Apply the mask to T1
  MASKED_T1_PATH="$MRI_DIR/T1w_GM_WM_only.nii.gz"
  fslmaths "$T1_NIFTI" -mul "$MASK_PATH" "$MASKED_T1_PATH"

  if [ $? -eq 0 ]; then
    echo "Processed subject $(basename "$SUBJECT_DIR"): Mask saved at $MASK_PATH, T1 masked at $MASKED_T1_PATH"
  else
    echo "Error processing subject $(basename "$SUBJECT_DIR")"
  fi
done
