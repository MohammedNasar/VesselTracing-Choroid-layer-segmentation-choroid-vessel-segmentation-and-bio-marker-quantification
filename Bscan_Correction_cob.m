
[cob11,rang,rangc] = Ch_seg_correctionRange_cob(COB3D_Fill2,'780-930');
% [cib11,cob11,rang,rangc] = Ch_seg_correctionRange_cib_cob(CIB3D_Fill2,COB3D_Fill2,'430-645,646-650');
figure;mesh(4*CIB3D_Fill2);hold on;mesh(4*(CIB3D_Fill2+cob11));title(strcat('After correction....',str1{6}), 'Interpreter', 'none');
% save('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat','cibnew','cobnew','-append');
rang1=[];
for i=1:size(rang,1)
    rang1=[rang1 rang(i,1):rang(i,2)];
end
nvar='sm_afterCorrection_cob';
% nvar='test_ws';
% tic
% sno = 999
% cib11 = [CIB3D_Fill2(:,1:sno) repmat(CIB3D_Fill2(:,sn0),1,size(CIB3D_Fill2,2)-sno)];
% cob11 = [COB3D_Fill2(:,1:sno) repmat(COB3D_Fill2(:,sn0),1,size(COB3D_Fill2,2)-sno)];
newSegPath = plt_wf_cibcob1(cropImgs1,4*CIB3D_Fill2,4*cob11,filePath,nvar,rang1)
% newSegPath = plt_wf_cibcob1(cropImgs1,4*CIB3D_Fill2,4*cob11,filePath,nvar,rang1)
% plt_wf_cibcob1(cropImgs1,4*cib1,4*cob1,filePath,nvar,rang1)
% newSegPath=plt_wf_cibcob1(cropImgs,4*[repmat(CIB3D_Fill2(:,4),1,200) CIB3D_Fill2(:,201:1024)],4*[repmat(COB3D_Fill2(:,4),1,200) COB3D_Fill2(:,201:1024)],filePath,nvar,rang1)

