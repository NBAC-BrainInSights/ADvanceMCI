## Make ADNI dataset structure like BIDS
# PARENT_DIR="/home/mnili/tmp/adni"

# for participant in "$PARENT_DIR"/*/; do
#   participant_name=$(basename "$participant")
#   new_participant_name="sub-${participant_name:6:10}" #crop last 4 character which is the participant id
#   mv "$participant" "$PARENT_DIR/$new_participant_name"
#   mkdir -p $PARENT_DIR/$new_participant_name/anat
#   mv $PARENT_DIR/$new_participant_name/*.nii.gz $PARENT_DIR/$new_participant_name/anat/${new_participant_name}_T1w.nii.gz
#   mv $PARENT_DIR/$new_participant_name/*.json $PARENT_DIR/$new_participant_name/anat/${new_participant_name}_T1w.json
# done



BIDS_DIR="$1"
OUTPUT_DIR="${BIDS_DIR}/output"

# List of participant directories and running MRIQC in parallel
find ${BIDS_DIR} -type d -name "sub-*" | xargs -n 1 -P 10 -I {} bash -c '
  export BIDS_DIR="$2"
  export OUTPUT_DIR="$3"
  participant_label=$(basename "{}")
  echo "Running MRIQC for ${participant_label}..."
  echo "BIDS_DIR=${BIDS_DIR}"
  echo "OUTPUT_DIR=${OUTPUT_DIR}"
  docker run --rm \
  -v "$BIDS_DIR":/data:ro \
  -v "$OUTPUT_DIR":/out \
  nipreps/mriqc:latest \
  /data /out participant --participant-label ${participant_label} --no-sub --n_cpus 10
' _ {} "$BIDS_DIR" "$OUTPUT_DIR"  # Pass the BIDS_DIR and OUTPUT_DIR as arguments
