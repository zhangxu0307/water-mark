%-------------------------
%Embedding 
%-------------------------
clear;
clc
img= imread('nju.jpg');
img = rgb2gray(img)
img=imresize(img,[256 256]);
[M,N]=size(img);
img=double(img);
[Uimg,Simg,Vimg]=svd(img);
Simg_temp=Simg;
% read watermark
 img_wat= imread('id.jpg');
 img_wat = rgb2gray(img_wat)
 img_wat=imresize(img_wat,[256 256]);
   alfa= input('The alfa Value = ');
   [x y]=size(img_wat);
   img_wat=double(img_wat);
   for i=1:x
       for j=1:y
          Simg(i,j) =Simg(i,j) + alfa * img_wat(i,j);
       end 
   end 
   % SVD for Simg (SM)
  [U_SHL_w,S_SHL_w,V_SHL_w]=svd(Simg);
Wimg =Uimg* S_SHL_w * Vimg';
figure(1)
imshow(uint8(img));
title('The Original Image')
figure(2)
imshow(uint8(img_wat));
title('The Watermark ')
figure(3)
imshow(uint8(Wimg));
title('The Watermarked Image')
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate image quality degradation after inserting watermark
%%%%%%%%%%%%%%%%%%%%%%%%%%%
mse=mean(squeeze(sum(sum((double(img)-double(Wimg)).^2))/(M*N)));
PSNR=10*log10(255^2./mse);
msg=sprintf('\n\n-------------------------\nWatermark by SVD  PSNR=%fdB\n-----------------------------\n\n', PSNR);
    disp(msg);
%--------------------------------------------------------------------------
% %% Extraction Part
% -------------------------------------------------------------------------
[UWimg,SWimg,VWimg]=svd(Wimg);
D_1=U_SHL_w * SWimg * V_SHL_w';
for i=1:x 
  for j=1:y
     Watermark(i,j)= (D_1(i,j) - Simg_temp(i,j) )/alfa ;
  end 
end
figure(8)
imshow(uint8(Watermark));
mse=mean(squeeze(sum(sum((double(img_wat)-(Watermark)).^2))/(M*N)));
PSNR=10*log10(255^2./mse);
msg=sprintf('\n\n-------------------------\nWatermark by SVD  PSNR=%fdB\n-----------------------------\n\n', PSNR);
disp(msg);