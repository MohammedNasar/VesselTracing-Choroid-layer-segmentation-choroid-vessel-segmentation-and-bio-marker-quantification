

tic
% I_org_Bw_vol_SC1 = bVol1;
[vol0,fcvolFilt] = cs_frangi_crop(CIB3D_Fill2,COB3D_Fill2,bVol1);

% represent the vasculature in physical dimensions (3*12*12)
vol = vol0.*permute(repmat(imresize(mask1,0.5),[1,1,size(vol0,1)]),[3 2 1]);

% Main script for CS estimation starts here
wf_cs_15Dec21

% Plot the histogram and heatmap
plt_vas_hmap_hist

cs_toc = toc

