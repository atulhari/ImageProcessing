clear all;
close all;

im=imread('car_dis.png');
%imshow(im);
%imshow(im, []);
im=im2double(im);

figure(1);
imshow(im, []);
title('Original Image');
%print –r150 –dpng car_dis_double.png;
print -r150 -dpng car_dis_double.png;
IM=fft2(im);
IMabs=abs(IM);
ffts=fftshift(IMabs);
%MATLAB expression for 2b after fft2
[row, col]=find(ffts==max(max(ffts)));
size(IMabs)
axis on;
figure(2);imshow(IMabs, []);
axis on;
figure(3);imshow(log(IMabs), []);
axis on;
figure(4);imshow(log(IMabs + 10), []);
axis on;
figure(5);im_fft_shift=imshow(fftshift(log(IMabs+10)), []);title('logmag of FFT  shifted'); %apply log and fftshift
axis on;
print -r150 -dpng Imlogmag.png;
v1=129-(256/7);%Expression for 2d(M/2+1=129)
v2=129+(256/7);%Expression 2d(N/2+1=129)
%print –r150 –dpng Imlogmag.png;

%hsize=[7 7];
h=fspecial('average', 7);
% Filtered Image
imfil=imfilter(im, h);   %Filter the original image with 'h' as window
figure(6);imshow(imfil);
title('Filtered Image');
imwrite(imfil, 'IMfil.jpg');
im_fft_shift_i = fftshift(log(10+abs(fft2(imfil))));
figure;
imshow(im_fft_shift_i, []); %applying fft2, log and fftshift
title('FFT shifted image');
print -r150 -dpng Imlogmag_fitered.png;

% OTF shift
OTF=psf2otf(h,size(im));
OTF_shift=fftshift(OTF);
OTF_mag=abs(OTF_shift);
figure; imshow(OTF_mag);title('OTF shifted image');
axis on;
print -r150 -dpng OTF_img.png;

% obtaining log magnitude
rstart1=86; rstart2=158;
rend1=100;rend2=172;
cstart=122; cend=136;
H = ones(size(im));
H(rstart1:rend1,cstart:cend) = 0;
H(rstart2:rend2,cstart:cend) = 0;
IM_FFT=fft2(im);
figure;imshow(H, []);title('Magnitude of the filter');axis('on');
print -r150 -dpng H.png;
H=fftshift(H);
imresult = H.*IM_FFT;
IMRESULTabs=abs(imresult);
figure;imshow(fftshift(log(IMRESULTabs+10)), []);title('logmag of FFT  shifted');axis('on');
print -r150 -dpng IMRESULTlogmag.png;
imresult=ifft2(imresult);
figure;imshow(imresult, []);title('imresult');
print -r150 -dpng imresult.png;
max(abs(imag(imresult(:))));