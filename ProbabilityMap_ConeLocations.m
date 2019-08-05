

% Please cite this paper if you use any component of this software:
% D. Cunefare, L. Fang, R.F. Cooper, A. Dubra, J. Carroll, S. Farsiu, "Open source software for automatic detection of cone photoreceptors in adaptive optics ophthalmoscopy using convolutional neural networks," Scientific Reports, 7, 6620, 2017.
% Released under a GPL v2 license.


% David Cunefare
% 1/20/2017

function [AutPos] = ProbabilityMap_ConeLocations(Cone_Probability,params)

    % Blur image
    ConeMap = imgaussfilt(Cone_Probability,params.PMsigma);
    
    thresh = params.PMthresh;
 
    % Find local maxima with sufficient height
    [ConeMapMax] = imextendedmax(ConeMap,params.ExtMaxH);
    
    % Find individual clusters
    CC=bwconncomp(ConeMapMax,8); 
    % Choose COM for cone position
    AutPos = [];
    i = 1;
    for iCone=1:length(CC.PixelIdxList)
        ConeInd = cell2mat(CC.PixelIdxList(iCone));
        ConeVals = ConeMap(ConeInd);
        
        % Only save positions that pass threshold
        if(max(ConeVals(:))>=params.PMthresh)
            [Y,X] = ind2sub(size(ConeMap),ConeInd);
            AutPos(i,:) = [(mean(X)) (mean(Y))];
            AutPos(i,:) = [sum(X)/length(X) sum(Y)/length(Y)];
            i=i+1;
        end
    end 
%     AutPos = cellfun(@expandArray,CC.PixelIdxList);
%     
%     AutPos = AutPos(AutPos > 0);
%     
%     y = round(AutPos/256);
%     x = AutPos-y*256;
%     
%     AutPos = [x y];
%     
%     function [AutPos] = expandArray(cellcontents)
%         ConeVals = ConeMap(cellcontents);
%         if(max(ConeVals(:))>=thresh)
%             [Y,X] = ind2sub(size(ConeMap),cellcontents);
%             AutPos = (sum(X)/length(X)) + 256*(round(sum(Y)/length(Y)));
%         else
%             AutPos = 0;
%         end
%     end
end