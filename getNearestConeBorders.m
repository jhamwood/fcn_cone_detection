function [tp,fp,fn] = getNearestConeBorders(truth,pred,dist)
if size(truth,1) ~= size(truth,2)
    truth = truth(:,1:end-1);
end

pred(1:2,:) = 0;
pred(:,1:2) = 0;
pred(end-1:end,:) = 0;
pred(:,end-1:end) = 0;

tp = 0;
fn = 0;

inds = 1:size(truth,1)*size(truth,2);

inds = reshape(inds,size(inds,1),size(inds,2));

tinds = inds(truth);
pinds = inds(pred);

[txsub,tysub] = ind2sub(size(truth),tinds);
[pxsub,pysub] = ind2sub(size(truth),pinds);
% pxsub = max(pxsub-1,1);
% pysub = max(pysub-3,1);
errs1 = zeros(144,144);
errs2 = zeros(144,144);
errs3 = zeros(144,144);
while ~isempty(txsub) && ~isempty(pxsub)
    
    [k,d] = knnsearch([pxsub(:) pysub(:)],[txsub(:) tysub(:)]);

    % first discard all points that no prediction is closer than dist to

    fn = fn + sum(d > dist & txsub' > 2 & txsub' < size(truth,1)-2 & tysub' > 2 & tysub' < size(truth,2) - 2);
    
    errs3(sub2ind([144 144],round(txsub(d > dist)),round(tysub(d > dist)))) = 1;
    txsub(d > dist) = [];
    tysub(d > dist) = [];
%     pxsub(k(d > dist)) = [];
%     pysub(k(d > dist)) = [];
    k(d > dist) = [];
    d(d > dist) = [];

    [~,utinds] = unique(k);

%     txsub(utinds) = [];
%     tysub(utinds) = [];
%     pxsub(upinds) = [];
%     pysub(upinds) = [];
% 
%     tp = tp + length(utinds);

    tempinds = 1:length(k);
    tempinds(utinds) = [];
    removal = false(length(k),1);
    for n = 1:length(tempinds)
        ptemp = find(k == k(tempinds(n)));
        predpoint = min(d(k == k(tempinds(n)))) == d(k == k(tempinds(n)));
        ptemp = ptemp(predpoint);
        removal(ptemp(1)) = true;
    end
    
    errs1(sub2ind([size(truth,1) size(truth,2)],txsub((~ismember(k,k(tempinds)) | removal)),tysub((~ismember(k,k(tempinds)) | removal)))) = 1;
    
    tp = tp + length(k(~ismember(k,k(tempinds)) | removal));
    
    pxsub(k(~ismember(k,k(tempinds)) | removal)) = [];
    pysub(k(~ismember(k,k(tempinds)) | removal)) = [];
    txsub((~ismember(k,k(tempinds)) | removal)) = [];
    tysub((~ismember(k,k(tempinds)) | removal)) = [];
end

% if ~isempty(txsub)
%     ds = zeros(length(txsub),1);
%     ks = zeros(length(txsub),1);
%     for n = 1:length(txsub)
%         [d,k] = min(pdist2([pxsub(:) pysub(:)],[txsub(n) tysub(n)]));
%         ds(n) = d;
%         ks(n) = k;
%     end
%     d = ds;
%     k = ks;
%     fn = fn + sum(d > dist);
%     txsub(d > dist) = [];
%     tysub(d > dist) = [];
% %     pxsub(k(d > dist)) = [];
% %     pysub(k(d > dist)) = [];
%     k(d > dist) = [];
%     d(d > dist) = [];
%     while length(unique(k)) < length(k)
%         [~,utinds] = unique(k);
% 
%     %     txsub(utinds) = [];
%     %     tysub(utinds) = [];
%     %     pxsub(upinds) = [];
%     %     pysub(upinds) = [];
%     % 
%     %     tp = tp + length(utinds);
% 
%         tempinds = 1:length(k);
%         tempinds(utinds) = [];
%         removal = false(length(k),1);
%         for n = 1:length(tempinds)
%             ptemp = find(k == k(tempinds(n)));
%             predpoint = min(d(k == k(tempinds(n)))) == d(k == k(tempinds(n)));
%             ptemp = ptemp(predpoint);
%             removal(ptemp(1)) = true;
%         end
% 
%         tp = tp + length(k(~ismember(k,k(tempinds)) | removal));
% 
%         pxsub(k(~ismember(k,k(tempinds)) | removal)) = [];
%         pysub(k(~ismember(k,k(tempinds)) | removal)) = [];
%         txsub((~ismember(k,k(tempinds)) | removal)) = [];
%         tysub((~ismember(k,k(tempinds)) | removal)) = [];
%     end
% end

fp = size(pxsub,2);
errs2(sub2ind([144 144],round(pxsub),round(pysub))) = 1;

errs = cat(3,errs1,errs2,errs3);
    
    