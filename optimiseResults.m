function [sigma,pmthresh,extmaxh] = optimiseResults(folder,dist)
disp(['Optimising point extraction on ' folder ' at distance ' num2str(dist) '.'])
files = dir([folder '/*.mat']);

thresh = 0.5;
tprs = zeros(20,11,9,3,length(files));
fdrs = zeros(20,11,9,3,length(files));
dices = zeros(20,11,9,3,length(files));
hs = [0 .05 .1 .15 .2 .25 .3 .4 .5];
for Sigma = [.1 .2 .3 .4 .5 .6 .7 .8 .9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2]
    ProbParam.PMsigma = Sigma;
    for PMthresh = [0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1]
        ProbParam.PMthresh = PMthresh;
        for ExtMaxH = 1:9
            ProbParam.ExtMaxH = hs(ExtMaxH);
            for dist = dist
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

                    tprs(Sigma*10,PMthresh*10+1,ExtMaxH,dist+1,n) = tp/(tp+fn);
                    fdrs(Sigma*10,PMthresh*10+1,ExtMaxH,dist+1,n) = fp/(tp+fp);
                    dices(Sigma*10,PMthresh*10+1,ExtMaxH,dist+1,n) = 2*tp/(2*tp+fp+fn);

                end
            end
            meanDices = nanmean(nanmean(dices,5),4);
            ind = find(meanDices == max(meanDices(:)),1);
            [s,t,h] = ind2sub(size(meanDices == max(meanDices(:))),ind);
            disp(['Best optimisation is at ' num2str(s/10) ' sigma, ' num2str((t-1)/10) ' thresh, and ' num2str(hs(h)) ' height.'])
        end
    end
end
meanDices = nanmean(nanmean(dices,5),4);
ind = find(meanDices == max(meanDices(:)),1);
[s,t,h] = ind2sub(size(meanDices == max(meanDices(:))),ind);

sigma = s/10;
pmthresh = (t-1)/10;
extmaxh = hs(h);

% disp(['Max Dice is at ' num2str(s/10) ' sigma, ' num2str((t-1)/10) ' thresh, and ' num2str(hs(h)) ' height.'])
% disp(['TPR is ' num2str(nanmean(tprs(s,t,h,:,:),5))])
% disp(['FDR is  ' num2str(nanmean(fdrs(s,t,h,:,:),5))]) 
% disp(['Dice is ' num2str(nanmean(dices(s,t,h,:,:),5))])
% disp(['TPR STD is ' num2str(nanstd(tprs(s,t,h,:,:),[],5))])
% disp(['FDR STD is  ' num2str(nanstd(fdrs(s,t,h,:,:),[],5))]) 
% disp(['Dice STD is ' num2str(nanstd(dices(s,t,h,:,:),[],5))])