#!/bin/bash

# Parse arguments
data_dir="$1"
output_dir="$2"

# Check if the required arguments are provided
if [ -z "$data_dir" ] || [ -z "$output_dir" ]; then
  echo "Usage: $0 <data_dir> <output_dir>"
  exit 1
fi

# Check if the directories exist
if [ ! -d "$data_dir" ]; then
  echo "Error: Data directory '$data_dir' does not exist."
  exit 1
fi

if [ ! -d "$output_dir" ]; then
  echo "Error: Output directory '$output_dir' does not exist."
  exit 1
fi

# Iterate over all .nii.gz files in the data directory
for file in "$data_dir"/*.nii.gz; do
  if [ -f "$file" ]; then
    # Extract filename without path
    filename=$(basename "$file" .nii.gz)
    
    # Perform normalization using fslmaths
    fslmaths "$file" -sub $(fslstats "$file" -R | awk '{print $1}') \  # Subtract the minimum value
              -div $(fslstats "$file" -R | awk '{print $2-$1}') \     # Divide by the range
              "$output_dir/${filename}_normalized.nii.gz"

    echo "Processed and saved: ${filename}_normalized.nii.gz"
  fi
done
