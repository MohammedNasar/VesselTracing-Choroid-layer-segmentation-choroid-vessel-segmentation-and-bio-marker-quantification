
% cropImages
% cropImgs1 = cropImgs;
% indx6 = indx5;
for mn1=x1:x2
    cropImgs1(:,indx6(mn1,4):indx6(mn1,5),mn1)= NaN;
    cropImgs1(:,indx6(mn1,4):indx6(mn1,5),mn1)= NaN;
end
cib=4*CIB3D_Fill2;

str1=strsplit(filePath,'\');
% str2{4}='SPCAAngioSegmentations_Pt2_CSCR';
n=round(min(min(cib)))-1
img=zeros([n size(cib)]);

for i=1:sx1
    i
%     mimg=crop_scans{i};
    mimg=squeeze(cropImgs1(:,:,i));
    for j=1:sy1%indx6(i,2):indx6(i,3)
        if cib(j,i) <= 0
            cib(j,i) = 1;
        end
        img(:,j,i)=mimg(round(cib(j,i))-n+1:round(cib(j,i)),j);
    end
end
n
div=1;
% enf_img=uint8(squeeze(mean(img(end-round(100/div):end-round(80/div),:,:),1)));
enf_img=uint8(squeeze(mean(img(end-30:end-0,:,:),1)));
figure;imshow(enf_img);
str1{6}
% imwrite(enf_img,strcat('Enface_',str1{6},'_',date,'.jpg'));
% ,'_',str1{7},'_',str1{9}


% cropImgs1=cropImgs;
% for mn1=x1:x2
%     cropImgs1(:,indx6(mn1,4):indx6(mn1,5),mn1)= NaN;
%     cropImgs1(:,indx6(mn1,4):indx6(mn1,5),mn1)= NaN;
% end
% 
% str1=strsplit(filePath,'\');
% 
% img=[];
% ofset=400;
% 
% n=round(min(min(CIB3D_Fill3)))-1+ofset;
% for i=1:size(CIB3D_Fill3,2)
% %      i
% %     mimg=crop_scans{i};
% % %     mimg=squeeze(cropImgs(:,:,i));
% %     for j=1:size(mimg,2)
% %         img(:,j,i)=mimg(round(CIB3D_Fill3(j,i))-n+1:round(CIB3D_Fill3(j,i)),j);
% %     end
%     i
% %     mimg=crop_scans{i};
% %     mimg=squeeze(imgs(:,:,i));
% 
%     mimg=squeeze(cropImgs1(:,:,i));
%     mimg_temp=zeros(size(mimg,1)+ofset,size(mimg,2));
%     mimg_temp(ofset+1:end,:)=mimg;
%     for j=1:size(mimg_temp,2)
%         img(:,j,i)=mimg_temp(round(cib(j,i))+1:round(cib(j,i))+ofset,j);
%     end
% end
% n
% div=1;
% 
% enf_img=uint8(squeeze(mean(img(end-round(140/div):end-round(100/div),:,:),1)));
% % enf_img=uint8(squeeze(mean(img(end-120:end-40,:,:),1)));
% figure;imshow(enf_img);






