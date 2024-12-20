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

##____________________________mriQualityControl_________________________________!

./mriqc.sh oasis
./mriqc.sh ADNI

##____________________________ outlier detect _________________________________!

# python ./outliers.py oasis
# python ./outliers.py ADNI

./outliers.sh oasis
./outliers.sh ADNI

##____________________________ minmax normal _________________________________!

python .MinMax_norm.py oasis
python .MinMax_norm.py ADNI

# .MinMax_norm.sh oasis
# .MinMax_norm.sh ADNI

##____________________________ resize T1w 64  _________________________________!
for dataset in oasis  ADNI;do
    for sub in ${dataset}/*;do
        base_name=$(basename $sub)
        mrgrid $sub regrid -template $sub -size 64,64,64 ${dataset}/64/$base_name -fill nan
    done
done
##_____________________________________________________________________________!



##____________________________  conv nii2npz  _________________________________!

python niis2npz.py oasis    oasis_data
python niis2npz.py ADNI     ADNI_data
##_____________________________________________________________________________!