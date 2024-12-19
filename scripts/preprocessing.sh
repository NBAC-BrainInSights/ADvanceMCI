##____________________________ pre_processing _________________________________!
## follow installation guid in below link for fastsurfer to preprocess and segmentation of the brain using deeplearning
## https://github.com/Deep-MI/FastSurfer?tab=readme-ov-file 
##_____________________________________________________________________________!

for dataset in oasis ADNI ;do
    for sub in ${dataset}/*;do
        base_name=$(basename $sub)
        SUBJECTS_DIR=${sub}
        fastsurfer --t1 "${sub}/${base_name}.nii.gz"  --sd "${dataset}" --sid "${base_name}"   --fs_license "license.txt" --no_cereb --no_hypothal --parallel --threads 20 --qc_snap --seg_only
    done
done

##____________________________GMWM extraction _________________________________!
##  
# python ./GMWM_extraction.py oasis
# python ./GMWM_extraction.py ADNI

./GMWM_extraction.sh oasis
./GMWM_extraction.sh ADNI

##____________________________mriqc,outlier rm_________________________________!

./mriqc.sh oasis
./mriqc.sh ADNI

# python ./outliers.py oasis
# python ./outliers.py ADNI

./outliers.sh oasis
./outliers.sh ADNI

##____________________________ minmax normal _________________________________!
##  
##_____________________________________________________________________________!



##____________________________ resize T1w 64  _________________________________!
##  
##_____________________________________________________________________________!



##____________________________  conv nii2npz  _________________________________!
##  
##_____________________________________________________________________________!