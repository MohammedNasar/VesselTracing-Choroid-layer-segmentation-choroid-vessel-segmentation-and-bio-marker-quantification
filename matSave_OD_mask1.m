
len0=length(fileNames);
strr=strcat(str1{6});%,'_',str1{6});
% strr=strcat(str1{4},'_',str1{6});
save(strcat(strr,'_cib_cob_',num2str(len0),'_',num2str(size(CIB3D_Fill,2)),'_',date,'-',num2str(hr),'-',num2str(mints)),...
        'CIB3D_Fill','COB3D_Fill','hr','mints');%,'img');
% ,'c2','mat_fn'
test_point=111
