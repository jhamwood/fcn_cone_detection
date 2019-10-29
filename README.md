# fcn_cone_detection
This repository contains the code to reproduce the results from Automatic Detection of Cone Photoreceptors with Fully Convolutional Networks.

# Notes
This code comes without any included data, however pretrained models presented in the above paper are included. 

The models presented here were trained on freely available data from David Cunefare et al. You will need to download their data and run "Code/Reassemble_IMDBS.m". The data can be found at https://github.com/DavidCunefare/CNN-Cone-Detection.

# Instructions

Download the zip from https://github.com/DavidCunefare/CNN-Cone-Detection and unzip it to any place on your computer.

Run the file CNN-Cone-Detection/Code/Reassemble_IMDBs.m from Cunefare et al. in MATLAB.

Run the file main.m from this project in MATLAB. It will prompt for a folder containing the raw data. Navigate to CNN-Cone-Detection\Images and Results.

The main.m file will train and evaluate a network on this data.