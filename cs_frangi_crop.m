
% Extract choroid vasculature from the binarized volume (cvol) based on CIB and COB
% Apply Frangi filter, followed by morphological operations and connected component analysis to clean
% the vasculature from spurious detections

function [vol,fcvolFilt] = cs_frangi_crop(cib,cob,cvol)
% yo_3dpts=mat3D_3Dpts(Y0);
% cib=CIB3D_Fill2;cob=COB3D_Fill2;cvol=cvVol;
clear fcvol;
fcvol = zeros([round(max(max(cob))) size(cob)]);
for mn1 = 1:size(fcvol,3)
%     for mn2=indx(mn1,2):indx(mn1,3)   
    for mn2 = 1:size(fcvol,2)
        ind = round(cib(mn2,mn1));
        ind1 = round(cib(mn2,mn1)+cob(mn2,mn1))-2;
        if ind < 1
            ind = 1;
        end
        if ind1 < 1
            ind1 = 1;
        end
        if ind1 > size(cvol,1)
            ind1 = size(cvol,1);
        end
        fcvol(1:ind1-ind+1,mn2,mn1) = cvol(ind:ind1,mn2,mn1);
    end
end
[fcvolFilt,~] = frangi_wf_22Oct21(fcvol,5,8);

se = strel('sphere',3);
Y0 = imopen(imfil(fcvolFilt),se);
CC1 = bwconncomp(Y0); % Y is the 3D array
YY = zeros(size(Y0));
numPixels = cellfun(@numel,CC1.PixelIdxList);
idx = find(numPixels>1000);
for ind = 1:length(idx)
    YY(CC1.PixelIdxList{idx(ind)}) = 1;
end
vol = imresize3(YY,0.5);

