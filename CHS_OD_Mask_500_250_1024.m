
% This is a script for the estimation of cross-section (CS) diameter of choroidal vessels 
% using choroid layer (CL) and choroid vessel (CV) segmentations
% based on input OCT volume and en-face optic disc (OD) mask

clearvars;clc;
close all;

% load the input volume
[fileNames,filePath0,~] = uigetfile('MultiSelect','on','img*.jpg');
% [fileNames,filePath0,~] = uigetfile('MultiSelect','on','D:\Choroid\Data\WideField_Datasets\Amrish_New\img*.jpg');

% Output folder(s) for storing the results
filePath = strcat(filePath0,'VT_Project\');
len0 = length(fileNames);
dt = datetime('now','Format','d-MMM-y-HH-mm'); hr = hour(dt); mints = minute(dt);
inputImgsPath = strcat(filePath,date,'\cropImgs_1536x500x250'); mkdir(inputImgsPath);

% % % % % % % %  CL estimation starts here....
% CIB - Choroid inner boundary
% COB - Choroid outer boundary
% Alternate scans are cosidered while finding CIB and COB such that computational time can be minimized.
for mn1 = 0:2:len0-1
    mn11 = round(mn1/2);
    inputImg = mn1
    try
    raw_img = strcat(filePath0,fileNames{mn1+1});%
    aa11 = imread(raw_img);
    if size(aa11,3)==3
        a1 = rgb2gray(aa11);
    elseif size(aa11,3)>3
        a1 = rgb2gray(aa11(:,:,1:3));
    else
        a1 = aa11;
    end
    Imgs(:,:,mn11+1) = a1;
    imwrite(Imgs(:,:,mn11+1),strcat(inputImgsPath,'\img',sprintf('%04d',mn1-1),'.jpg'));
    catch ME
        fprintf('Corrupted scan# %d: %s\n',mn1, ME.message);
        continue;
    end
end
% sz -----> no. of rows in each B-scan
% sy -----> no. of cols in each B-scan
% sx -----> no. of B-scans in the OCT volume

sz = size(Imgs,1); sy = size(Imgs,2); sx = size(Imgs,3);

% Enface mask is used to identify optic disc (OD) region and skip the
% boundary detections encompassing OD

m_img = imread(strcat(filePath0,'Mask.jpg'));
bmask = imbinarize(m_img);
mask = squeeze(bmask(:,:,1));
% mask=imresize(squeeze(bmask(:,:,1)),[sy sx]);


str1 = split(inputImgsPath,'\');
inpFPath = join(str1(1:end),"/");
outPath = join(str1(1:end-1),"/"); % 
outFPath = strcat(outPath{1},'/Mask_1536x500x250');
mkdir(outFPath);  

% ResUNet model is introduced to find the choroid layer mask, this portion of the code is
% implemented using python script (maskGen.py)
tic
% h5file='VKKResUnet_CWF_1269_Raw_10Val_90Train_RS42_8_80_256.h5';
h5file = 'VKKResUnet_CS_3594_Raw_10Val_90Train_RS42_8_80_256.h5';
cmd = strcat('python maskGen.py',{' '},inpFPath{1},{' '},h5file,{' '},outFPath);
system(cmd{1})
mask_gen_toc = toc

clear bVol In_enhance3D mask_img0
tic   

% Read choroid mask for further processing and also binarization 
% of the choroid layer is performed based on input OCT volume
bVol = zeros([round(sz/4) sy sx]);
mask_img0 = zeros([round(sz/4) sy sx]);
se1 = strel('disk',3);
for mn1 = 1:sx
%     mn11 = round(mn1/2);
    Enh_mask_img = mn1 
    mask_img0(:,:,mn1) = imbinarize(imfil(imclose(imresize(imread(strcat(outFPath,'/mask_',int2str(mn1-1),...
        '.jpg')),[round(sz/4) sy]),se1))); % read choroid mask
%     I_org_Bw_vol_SC(:,:,mn1) = imcomplement(img_enhance_EXP_org((adapthisteq(imadjust(medfilt2 ...
%         (ShadowremovalAndEnhancement2(imresize(cropImgs(:,:,mn1),[round(sz/4) sy]),2),[8 8])))),6)); 
    bVol(:,:,mn1) = imcomplement(phansalkar(adapthisteq(medfilt2(imresize(Imgs(:,:,mn1)...
        ,[round(sz/4) sy]),[2 2])),[20 20])); % binarize B-scans
end

% Perform morphological operations on choroid layer mask to remove spurious detections
CC1 = bwconncomp(mask_img0); % Y is the 3D array
mask_img01 = zeros(size(mask_img0));
numPixels = cellfun(@numel,CC1.PixelIdxList);
[biggest,maxid] = max(numPixels);
mask_img01(CC1.PixelIdxList{maxid}) = 1;
mask_img02 = mask_img01.*permute(repmat(mask(1:2:end,:),[1,1,round(sz/4)]),[3 2 1]);
se2 = strel('sphere',5);
mask_img = imbinarize(imfil(imclose((mask_img02),se2)));

In_enhance3D_toc = toc; 

% Identify optic disc (OD) region 
indx5 = [];
for mn1 = 1:sx  
%% Read Original wide-field images
    interp_img = mn1
    rd = mask(2*mn1,:);
    if sum(rd) == 2*sx
        indx5 = [indx5;mn1 1  sy nan nan];
    else
        ini = find(rd == 0, 1, 'first');
        fin = find(rd == 0, 1, 'last');
        if ini < sx
%             OD presents in Left-side, so ROI is right side
            indx5 = [indx5;mn1 fin+1 sy ini fin];
        else
%             OD presents in right-side, so ROI is left side
            indx5 = [indx5;mn1 1 ini-1 ini fin];
        end
    end        
end

CIB3D_Fill0 = zeros(sy,sx);
COB3D_Fill0 = zeros(sy,sx);

% Identify inner and outer boundaries from the CL mask images
tic
for mn1 = 1:sx
    try
    y_intrm = indx5(mn1,2):indx5(mn1,3);
    y_temp_indx1 = [];
    y_temp_indx2 = [];
    cib_cob = mn1  
    for mn2 = 1:sy%y_intrm%indx5(mn1,2):indx5(mn1,3)
        aa_ILM = [];
        aa_ILM = find(mask_img(:,mn2,mn1) == 1);
        if numel(aa_ILM)>4
            CIB3D_temp(mn2,mn1) = round(aa_ILM(1));
            y_temp_indx1 = [y_temp_indx1 mn2];
            if mn2 <= indx5(mn1,3) && mn2 >= indx5(mn1,2) 
                COB3D_temp(mn2,mn1) = round(aa_ILM(end)-aa_ILM(1));
                y_temp_indx2 = [y_temp_indx2 mn2];
            end
        end
    end  
%     if ~isempty(y_temp_indx1)&~isempty(y_temp_indx2)
        CIB3D_intrm = interp1(y_temp_indx1,CIB3D_temp(y_temp_indx1,mn1),1:sy,'linear','extrap');
        CIB3D_Fill0(1:sy,mn1) = smooth(1:sy,CIB3D_intrm,0.1,'rloess');
        COB3D_intrm = interp1(y_temp_indx2,COB3D_temp(y_temp_indx2,mn1),y_intrm,'linear','extrap');
        COB3D_Fill0(indx5(mn1,2):indx5(mn1,3),mn1) = smooth(y_intrm,COB3D_intrm,0.1,'rloess');
%     end
    catch ME
      fprintf('Failed to process CIB/COB numbered %d: %s\n',mn1, ME.message);
      continue;
    end
end

% resize the boundary surfaces dimensions from (sy*sx = 1024*250) to standard scale (1024*1024)
CIB3D_Fill = imresize(CIB3D_Fill0,[round((size(CIB3D_Fill0,1)*1024)/(2*sx)) 1024]);
COB3D_Fill = imresize(COB3D_Fill0,[round((size(CIB3D_Fill0,1)*1024)/(2*sx)) 1024]);

figure;mesh(4*CIB3D_Fill);hold on;mesh(4*(CIB3D_Fill+COB3D_Fill)); 
title(strcat('Initial boundary surface estimates....',str1{6}), 'Interpreter', 'none');
Icib_cob_toc = toc/60     %  432.9090/1024=  0.4228

% new sx & sy
sx1 = size(CIB3D_Fill,2);
sy1 = size(CIB3D_Fill,1);

mask1 = imresize(mask,size(CIB3D_Fill));

% Identify optic disc region in standard scale (1536*1024*1024), it is similar to done
% earlier in the line starting from 103 for squeezed dimension (1536/4*500*250)
indx6 = [];
clear mn1;
for mn1 = 1:sx1 
    rd = mask1(mn1,:);
    if sum(rd) == sx1
        indx6 = [indx6; mn1 1  sy1 nan nan];
    else
        ini = find(rd == 0, 1, 'first');
        fin = find(rd == 0, 1, 'last');
        if ini < sx1/2
            indx6 = [indx6; mn1 fin+1 sy1 ini fin];
        else
            indx6 = [indx6; mn1 1 ini-1 ini fin];
        end
    end        
end

% identify OD staring and ending B-scans
x1 = min(indx6(~isnan(indx6(:,4)),1));  %*round(1024/sx);
x2 = max(indx6(~isnan(indx6(:,4)),1)); %*round(1024/sx);

y1 = min(indx6(~isnan(indx6(:,4)),4));
y2 = max(indx6(~isnan(indx6(:,4)),5));

% Boundary correction: Skip the boundaries of the B-scans encompassing OD region and interpolate them with the
% help of boundary information from other B-scans
for mn2 = 1:sy1 
    cib(mn2,:) = interp1([1:x1-1,x2+1:sx1],CIB3D_Fill(mn2,[1:x1-1,x2+1:sx1]),1:sx1,'linear','extrap');
    cob(mn2,:) = interp1([1:x1-1,x2+1:sx1],COB3D_Fill(mn2,[1:x1-1,x2+1:sx1]),1:sx1,'linear','extrap');
end

% Smooth the corrected boundaries
CIB3D_Fill2 = smoothdata(smoothdata(cib,2,'rloess'),1,'rloess');
COB3D_Fill2 = smoothdata(smoothdata(cob,2,'rloess'),1,'rloess');

% Originally depth direction (A-scan dimension) was reduced by 4 times and
% it is again resized to original scale 
CIB3D_Fill3 = 4*CIB3D_Fill2;
COB3D_Fill3 = 4*COB3D_Fill2;

figure;mesh(4*CIB3D_Fill2);hold on;mesh(4*(CIB3D_Fill2+COB3D_Fill2)); 
title(strcat('Included OD....',str1{6}), 'Interpreter', 'none');

% This is fill empty space in the OD region of the boundary surfaces
for mn1 = x1:x2
    CIB3D_Fill3(indx6(mn1,4):indx6(mn1,5),mn1) = NaN;
    COB3D_Fill3(indx6(mn1,4):indx6(mn1,5),mn1) = NaN;
end
figure;mesh(CIB3D_Fill3);hold on;mesh(CIB3D_Fill3+COB3D_Fill3); 
title(strcat('Exclusion of OD....',str1{6}), 'Interpreter', 'none');
view(0,90);

% 
% plt_wf_cibcob(cropImgs,4*cib,4*cob,filePath,'ws',[]);

% Resize OCT volume (Imgs,(1536/4,500,250)) to standard size (1536*1024*1024)
Imgs1 = imresize3(Imgs,[size(Imgs,1) size(CIB3D_Fill)]);

% plt_wf_cibcob(Imgs1,4*cib,4*COB3D_Fill2,filePath,'ws',[]);


% % Plot by overlaying CIB and COB on OCT B-scans
plt_wf_cibcob(Imgs1,4*CIB3D_Fill2,4*COB3D_Fill2,filePath,'sm',[]);


% Steps for further correction, if required: repeating any particular boundary as reference for the
% range of boundaries, this logic applicable for both CIB and COB
% bnd = rpt_ref_bnd('980','980-1024',COB3D_Fill2);
% plt_wf_cibcob1(cropImgs1,4*CIB3D_Fill2,4*bnd,filePath,'ref_corr_cob',980:1024)
% COB3D_Fill2 = bnd;


% Steps for further correcting CIB, if required:
% Bscan_Correction_cib
% CIB3D_Fill2 = cib11;
% CIB3D_Fill3 = 4*CIB3D_Fill2;

% Steps for further correcting COB, if required:
% Bscan_Correction_cob
% COB3D_Fill2 = cob11;
% COB3D_Fill3 = 4*COB3D_Fill2;

% figure;mesh(4*CIB3D_Fill2);hold on;mesh(4*(CIB3D_Fill2+COB3D_Fill2)); title(strcat('Before OD filling....',str1{6}), 'Interpreter', 'none');

% % Common for both CIB and COB
% for mn1 = x1:x2
%     CIB3D_Fill3(indx6(mn1,4):indx6(mn1,5),mn1) = NaN;
%     COB3D_Fill3(indx6(mn1,4):indx6(mn1,5),mn1) = NaN;
% end
% figure;mesh(CIB3D_Fill3);hold on;mesh(CIB3D_Fill3+COB3D_Fill3); title(strcat('After OD filling....',str1{6}), 'Interpreter', 'none');
% view(0,90);

%%%%%%%%%%%%%  CL estimation ends here....


%%%%%%%%%%%%% Next, proceeding to CS estimation process, which begins from here........

% % Resize binarized volume (I_org_Bw_vol_SC,(1536/4,500,250)) to standard size (1536*1024*1024)
bVol1 = imresize3(bVol,[size(bVol,1) size(COB3D_Fill)]);


% % Main script (hmap_OD_Mask) for the CS estimation problem: First, it extracts the choroid
% % vessel from binarized volume (I_org_Bw_vol_SC1) based on estimated CIB and COB boundaries
% hmap_OD_Mask

% % Storing output variables 
% matSave_OD_mask1

% % Identification of representative enface image
% Enf_cibcobImg_OD_mask1


filePath0


% % Scripts for storing output variables using mat file
% matSave_OD_mask2
% save_Data_GUI_Hmap_OD_Mask

