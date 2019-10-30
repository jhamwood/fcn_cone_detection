function [dices,tprs,fdrs] = evalResults(predfolder,dist,ProbParam)
% EVALRESULTS Evaluates metrics of cone location accuracy.
%   [DICES, TPRS, FDRS] = EVALRESULTS(FOLDER, DIST, PROBPARAM) calculates
%   dice overlaps DICES, true positive rates TPRS, and false detection
%   rates FDRS on all probability maps in FOLDER, with a maximum matching
%   DIST using parameters PROBPARAM.

disp(['Evaluating performance on ' predfolder '.'])

% Get all probability maps within folder
files = dir([predfolder '/*.mat']);

thresh = 0.5;

% Initialise storage variables
tprs = zeros(length(files),1);
fdrs = zeros(length(files),1);
dices = zeros(length(files),1);

for n = 1:length(files)
    load([files(n).folder '\' files(n).name],'pred','truth')
    
    [CNNPos] = ProbabilityMap_ConeLocations(pred,ProbParam);
    pred = zeros(size(pred));
    if ~isempty(CNNPos)
        pred(sub2ind([144 144],round(CNNPos(:,2)),round(CNNPos(:,1)))) = 1;
    end

    offset = (size(truth,1) - 144)/2;
    truth = truth(1+floor(offset):end-ceil(offset),1+floor(offset):end-ceil(offset));
    if sum(pred(:) > thresh) > 0
        [tp,fp,fn] = getNearestConeBorders(truth == 1, pred > thresh, dist);
    elseif sum(truth(:) == 1) == 0
        tp = 1;
        fp = 0;
        fn = 0;
    else
        tp = 0;
        fp = 1;
        fn = 0;
    end
    tprs(n) = tp/(tp+fn);
    fdrs(n) = fp/(tp+fp);
    dices(n) = 2*tp/(2*tp+fp+fn);
end