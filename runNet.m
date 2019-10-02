function runNet(datafolder,savefolder)
if exist('savefolder','var') == 0
    savefolder = datestr(now,'YY-mm-DD-HH-MM-SS');
end

if 7==exist(savefolder,'dir')
    savefolder = [savefolder datestr(now,'-YY-mm-DD-HH-MM-SS')];
end

mkdir([savefolder '\train'])
mkdir([savefolder '\test'])

imds = imageDatastore([datafolder '\train\imgs']);
pxds = pixelLabelDatastore([datafolder '\train\truth'],["background","cone"],[1 2]);
pximds = pixelLabelImageDatastore(imds,pxds);

net = initNet(pximds);

trainedNet = trainNetwork(pximds,net,trainingOptions('sgdm','Shuffle','every-epoch','Plots','training-progress','MaxEpochs',50,'Verbose',false,'MiniBatchSize',20));

save([savefolder '\net.mat'],'trainedNet')

generateProbabilityMaps(trainedNet,[savefolder '\train'],[datafolder '\train'])

[sigma, pmthresh, maxexth] = optimiseResults([savefolder '\train'],6);

ProbParam.PMsigma = sigma;
ProbParam.PMthresh = pmthresh;
ProbParam.ExtMaxH = maxexth;
save([savefolder  '\optima.mat'],'ProbParam')

generateProbabilityMaps(trainedNet,[savefolder '\test'],[datafolder '\test'])

[dices,tprs,fdrs] = evalResults([savefolder '\test'],6,ProbParam);

save([savefolder '\results.mat'],'dices','tprs','fdrs')

disp(['TPR is ' num2str(mean(tprs))])
disp(['FDR is  ' num2str(mean(fdrs))]) 
disp(['Dice is ' num2str(mean(dices))])
disp(['TPR STD is ' num2str(std(tprs))])
disp(['FDR STD is  ' num2str(std(fdrs))]) 
disp(['Dice STD is ' num2str(std(dices))])