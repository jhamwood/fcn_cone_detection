if ~exist('data/confocal/mat/0wide/train/imgs','dir')
    createData;
end

load('pretrained_confocal_3wide.mat')

img = imread('data/confocal/mat/3wide/test/imgs/0.png');

truth = imread('data/confocal/mat/3wide/test/truth/0.png');
truth = truth == 2;
[truth_x, truth_y] = ind2sub([144 144],find(truth));

[~,~,allscores] = semanticseg(img,trainedNet);

pred = allscores(:,:,2);
[CNNPos] = ProbabilityMap_ConeLocations(pred,ProbParam);

pred = zeros(size(pred));
if ~isempty(CNNPos)
    pred(sub2ind([144 144],round(CNNPos(:,2)),round(CNNPos(:,1)))) = 1;
end

figure
subplot(2,2,1)
imagesc(img)
colormap gray
axis off
axis equal
subplot(2,2,2)
imagesc(img)
colormap gray
axis off
axis equal
hold on
plot(CNNPos(:,1),CNNPos(:,2),'g.')
subplot(2,2,3)
imagesc(img)
colormap gray
axis off
axis equal
hold on
plot(truth_y,truth_x,'m.')
subplot(2,2,4)
imshowpair(truth,pred)