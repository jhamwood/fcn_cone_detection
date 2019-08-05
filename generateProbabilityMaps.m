function generateProbabilityMaps(trainedNet,savefolder,datafolder)
mkdir(savefolder)
files = dir(datafolder);
files = files(3:end);
for n = 1:length(files)
    img = imread([datafolder '\imgs\' files(n).name]);
    [~,~,allscores] = semanticseg(img,trainedNet);
    raw = img;
    pred = allscores(:,:,2);
    truth = imread([datafolder '\truths\' files(n).name]);
    truth = truth == 2;
    save([savefolder '\' files(n).name(1:find(files(n).name == '.',1,'last')) 'mat'],'raw','pred','truth')
end