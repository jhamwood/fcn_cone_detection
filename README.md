# fcn_cone_detection
This repository contains the code to reproduce the results from Automatic Detection of Cone Photoreceptors with Fully Convolutional Networks.

# Notes
This code comes without any included data, however pretrained models presented in the above paper are included. 

The models presented here were trained on freely available data from David Cunefare et al. You will need to download their data and run "Code/Reassemble_IMDBS.m". The data can be found at https://github.com/DavidCunefare/CNN-Cone-Detection.

# Instructions

A "main" function is provided to run a sample network. This function will prompt for the location of the "Confocal" and "Split Detectors" folders from Cunefare et al.'s project.
