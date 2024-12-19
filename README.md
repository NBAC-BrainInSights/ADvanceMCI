
# ADvanceMCI Project: Classifying Progressive MCI from Stable MCI

## Project Overview
The ADvanceMCI project aims to classify participants with **Progressive Mild Cognitive Impairment (MCI)** from those with **Stable MCI** using neuroimaging data. The project involves various stages of preprocessing, brain segmentation, quality control, and data transformation to prepare the dataset for machine learning analysis.

This README provides a guide to the project structure, pre-processing steps, and necessary commands to replicate the analysis pipeline.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Project Setup](#project-setup)
- [Preprocessing Steps](#preprocessing-steps)
  - [FastSurfer Preprocessing and Segmentation](#fastsurfer-preprocessing-and-segmentation)
  - [GMWM Extraction](#gmwm-extraction)
  - [MRIQC and Outlier Removal](#mriqc-and-outlier-removal)
  - [Min-Max Normalization](#min-max-normalization)
  - [Resize T1w Images](#resize-t1w-images)
  - [Convert NIfTI to NPZ](#convert-nifti-to-npz)
- [Running the Project](#running-the-project)
- [References](#references)

---

## Prerequisites

Before running the pipeline, ensure you have the following software and dependencies installed:

- **FastSurfer**: A deep learning-based MRI preprocessing and segmentation tool.
  - Follow the installation guide here: [FastSurfer Installation](https://github.com/Deep-MI/FastSurfer?tab=readme-ov-file)

- **Python**: Required for some preprocessing scripts, such as GMWM extraction, outlier detection, etc.
- **MRIQC**: To assess the quality of MRI images.
- **FSL/FreeSurfer**: Used for brain image processing tasks.

Additionally, you will need the following Python packages:
```bash
pip install nibabel numpy scikit-learn
```

---

## Project Setup

Clone the project repository to your local machine:

```bash
git clone https://github.com/your-username/ADvanceMCI.git
cd ADvanceMCI
```

---

## Preprocessing Steps

### FastSurfer Preprocessing and Segmentation

We use **FastSurfer** for preprocessing and segmentation of MRI scans using deep learning techniques. FastSurfer is fast and provides high-quality segmentation results. Below are the commands to preprocess the data.

1. Download the dataset for **OASIS** and **ADNI**.
2. For each participant in the dataset, run **FastSurfer** to preprocess the T1-weighted images and perform segmentation.

```bash
for dataset in oasis ADNI; do
    for sub in ${dataset}/*; do
        base_name=$(basename $sub)
        SUBJECTS_DIR=${sub}
        fastsurfer --t1 "${sub}/${base_name}.nii.gz" --sd "${dataset}" --sid "${base_name}" --fs_license "license.txt" --no_cereb --no_hypothal --parallel --threads 20 --qc_snap --seg_only
    done
done
```

### GMWM Extraction

To extract the **Gray Matter (GM)** and **White Matter (WM)** masks, we use the following Python and shell scripts. These masks are important for subsequent analyses, such as feature extraction.

Run the script to extract the GM and WM masks for both **OASIS** and **ADNI** datasets:

```bash
./GMWM_extraction.sh oasis
./GMWM_extraction.sh ADNI
```

### MRIQC and Outlier Removal

We use **MRIQC** to evaluate the quality of the MRI images. The quality control steps help identify and remove outlier images that may affect model training.

1. Run MRIQC on the datasets:
   
```bash
./mriqc.sh oasis
./mriqc.sh ADNI
```

2. Use the `outliers.sh` script to remove any images flagged as outliers based on MRIQC results.

```bash
./outliers.sh oasis
./outliers.sh ADNI
```

### Min-Max Normalization

Normalizing the data is an essential step to ensure that all features are on the same scale. Min-Max normalization rescales the pixel values of the MRI images to a range between 0 and 1.

You can implement the normalization as per your requirements.

### Resize T1w Images

Resizing the T1-weighted images to a standard resolution of `64x64` pixels may be required for certain machine learning models. This step ensures consistency across all images in the dataset.

Resizing commands can be added here as needed based on your model requirements.

### Convert NIfTI to NPZ

Finally, convert the **NIfTI** format images to **NPZ** format for easy use with machine learning models. This conversion allows for faster loading and more efficient processing during model training.

```bash
python ./convert_nii2npz.py
```

---

## Running the Project

Once the preprocessing steps are complete, you can begin with model training and evaluation. Make sure the dataset is correctly prepared by checking the processed files and logs for any errors.

To run the preprocessing pipeline for the **OASIS** dataset:

```bash
bash preprocess_oasis.sh
```

To run the preprocessing pipeline for the **ADNI** dataset:

```bash
bash preprocess_adni.sh
```

Each script will process the data and output results to the corresponding directories.

---

## References

- **FastSurfer**: [FastSurfer GitHub](https://github.com/Deep-MI/FastSurfer?tab=readme-ov-file)
- **MRIQC**: [MRIQC GitHub](https://github.com/MRIQC/mriqc)

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
