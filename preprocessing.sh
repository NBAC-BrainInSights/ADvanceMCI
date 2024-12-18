##____________________________ pre_processing _________________________________!
## follow installation guid in below link for fastsurfer to preprocess and segmentation of the brain using deeplearning
## https://github.com/Deep-MI/FastSurfer?tab=readme-ov-file 
##_____________________________________________________________________________!

for dataset in oasis/pMCI oasis/sMCI ADNI/pMCI  ADNI/sMCI;do
    for sub in ${dataset}/*;do
        base_name=$(basename $sub)
        SUBJECTS_DIR=${sub}
        fastsurfer --t1 "${sub}/${base_name}.nii.gz"  --sd "${dataset}" --sid "${base_name}"   --fs_license "license.txt" --no_cereb --no_hypothal --parallel --threads 20 --qc_snap --seg_only
    done
done
##_____________________________________________________________________________!



##____________________________GMWM extraction _________________________________!
##  
# python ./GMWM_extraction.py oasis/pMCI/
# python ./GMWM_extraction.py oasis/sMCI/
# python ./GMWM_extraction.py ADNI/pMCI/
# python ./GMWM_extraction.py ADNI/sMCI/

./GMWM_extraction.sh oasis/pMCI/
./GMWM_extraction.sh oasis/sMCI/
./GMWM_extraction.sh ADNI/pMCI/
./GMWM_extraction.sh ADNI/sMCI/

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