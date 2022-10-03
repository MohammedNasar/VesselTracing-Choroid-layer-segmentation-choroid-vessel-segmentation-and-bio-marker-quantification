

len0=length(fileNames);
strr=strcat(str1{6})
save(strcat(strr,'_cs_hmap_',num2str(len0),'_',num2str(size(CIB3D_Fill2,2)),'_',date,'-',num2str(hr),'-',num2str(mints)),...
    'mask_img','filePath','fcvolFilt','vol','nd','m_pt','var','dim','enf_img','hr','mints');  %
% ,'c2','mat_fn'


