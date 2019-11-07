# fcn_cone_detection
This repository contains the code to reproduce the results from Automatic Detection of Cone Photoreceptors with Fully Convolutional Networks.

# Notes
This code comes without any included data, however pretrained models presented in the above paper are included. 

The models presented here were trained on freely available data from David Cunefare et al. You will need to download their data and run "Code/Reassemble_IMDBS.m". The data can be found at https://github.com/DavidCunefare/CNN-Cone-Detection.

# Instructions for Training

1. Download the zip from https://github.com/DavidCunefare/CNN-Cone-Detection and unzip it your computer. Choose a short path (for example, C:\temp) to ensure it unzips the data properly.

2. Run the file CNN-Cone-Detection\Code\Reassemble_IMDBs.m from Cunefare et al. in MATLAB.

3. Navigate back to the fcn_cone_detection-master folder, run the file main.m from this project in MATLAB. It will prompt for a folder containing the raw data. Choose the exact folder 'CNN-Cone-Detection\Images and Results' from Cunefare et al. 

4. The main.m file will generate the dataset and will train and evaluate a network on this specific data. By default main.m is set to use the '0 wide Confocal' dataset. Main.m has an example for the split detector dataset commented out.
The program will train the network. After training, it will evalute the model and provide the mean value performance in Dice coefficient, True Positive Rate, and False Detection Rate.

# Instructions for Using Pretrained Networks

1. Download the zip from https://github.com/DavidCunefare/CNN-Cone-Detection and unzip it your computer. Choose a short path (for example, C:\temp) to ensure it unzips the data properly.

2. Run the file CNN-Cone-Detection\Code\Reassemble_IMDBs.m from Cunefare et al. in MATLAB.

3. Navigate back to the fcn_cone_detection-master folder, run the file pretrained_example.m from this project in MATLAB. It will prompt for a folder containing the raw data. Choose the exact folder 'CNN-Cone-Detection\Images and Results' from Cunefare et al. 

4. The pretained_example.m file will load an example image and then classify and localise the cones present. The raw image, predictions, truths, and comparison will be shown in a figure.