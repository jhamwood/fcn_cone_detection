function generateProbabilityMaps(trainedNet,savefolder,datafolder)
disp(['Generating probability maps at ' savefolder '.'])

%mkdir(savefolder)
files = dir([datafolder '\imgs']);
files = files(3:end);
for n = 1:length(files)
    disp(['Generated map ' num2str(n) ' of ' num2str(length(files)) ' maps.'])
    img = imread([datafolder '\imgs\' files(n).name]);
    [~,~,allscores] = semanticseg(img,trainedNet);
    raw = img;
    pred = allscores(:,:,2);
    truth = imread([datafolder '\truth\' files(n).name]);
    truth = truth == 2;
    save([savefolder '\' files(n).name(1:find(files(n).name == '.',1,'last')) 'mat'],'raw','pred','truth')
end