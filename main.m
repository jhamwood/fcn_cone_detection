% This code was trained on the data sets found in the following paper
% D. Cunefare, L. Fang, R.F. Cooper, A. Dubra, J. Carroll, S. Farsiu,
% "Open source software for automatic detection of cone photoreceptors 
% in adaptive optics ophthalmoscopy using convolutional neural networks," 
% Scientific Reports, 7, 6620, 2017.
%
% Please cite the above paper if using their datasets

% You will need to download their data and follow their instructions to use
% this code. The data can be found at
% https://github.com/DavidCunefare/CNN-Cone-Detection.

if ~exist('data/confocal/mat/0wide/train/imgs','dir')
    createData;
end

runNet('data/confocal/mat/0wide','exps/test_0')