# follow installation guid in below link for fastsurfer to preprocess and segmentation of the brain using deeplearning
# https://github.com/Deep-MI/FastSurfer?tab=readme-ov-file

##____________________________ pre_processing _________________________________!
##  
##_____________________________________________________________________________!

for dataset in oasis/nifti ADNI_safi/pMCI_safi  ADNI_safi/sMCI_safi;do
    for sub in ${dataset}/*;do
        base_name=$(basename $sub)
        SUBJECTS_DIR=${sub}
        fastsurfer --t1 "${sub}/${base_name}.nii.gz"  --sd "${dataset}" --sid "${base_name}"   --fs_license "/home/mnili/tmp/khedmat/license.txt" --no_cereb --no_hypothal --parallel --threads 20 --qc_snap --seg_only
    done
done
##_____________________________________________________________________________!



##____________________________GMWM extraction _________________________________!
##  
##_____________________________________________________________________________!



##____________________________ outlier detect _________________________________!
##  
##____________________________________________________________________________!



##____________________________ minmax normal _________________________________!
##  
##_____________________________________________________________________________!



##____________________________ resize T1w 64  _________________________________!
##  
##_____________________________________________________________________________!



##____________________________  conv nii2npz  _________________________________!
##  
##_____________________________________________________________________________!