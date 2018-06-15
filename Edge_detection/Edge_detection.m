clear variable;
close all;
clc;


%% Part I Edge Based image segmentation

sigma = 5; % set the width of the Gaussian
L = 2*ceil(sigma*[3,3])+1; % fill in a constant to define the matrix size
xymax = (L-1)/2; % the maximum of the x and the y coordinate
xrange = -xymax:xymax; % the range of x values
yrange = xrange; % the range of y values
% create the PSF matrix
h = fspecial('gaussian', L , sigma);
%% visualize as a 3D plot:
% create a RGB matrix to define the colour of the surface plot
C = cat(3, ones(size(h)),ones(size(h)),zeros(size(h)));
% create the surface plot of the gaussian
figure(1)
hd =surf(xrange,yrange,h,C,'FaceColor','interp','Facelight','phong');
camlight right % add a light at the right side of the scene
xlim([-20,20]); % set appropriate axis limits
ylim([-20,20]);
xlabel('x'); % add axis labels
ylabel('y');
zlabel('h(x,y)');
print -r150 -dpng ex3_1.png % print the result to file


im = imread('ang2.png'); % read the image from file
sigma = [1 10 20 35]; % fill array with sigma values
for i=1:4 % do 4 times:
h = fspecial('gaussian',L,sigma(i)) ; % create the PSF
imfiltered = imfilter(im,h,'replicate','same') ; % apply the filter
subplot(2,2,i); % define a subplot
imshow(imfiltered,[]); % show the image
title(['\sigma = ' num2str(sigma(i))])
print -r150 -dpng ex3_1b.png;% include a plot title

sigma=1.5;
L = 2*ceil(sigma*3)+1;
N = ceil((L-1)/2); % get the size of half of the full range
[x,y]=meshgrid(-N:N,-N:N); % create the coordinates of a 2D orthogonal grid
%h = exp(-(x.^2 + y.^2)/(2*sigma^2))/(2*pi*sigma^2);


h_y=-y*exp(-(x.^2 + y.^2)/(2*sigma^2))/(2*pi*sigma^4);
C1 = cat(3, ones(size(h_y)),ones(size(h_y)),zeros(size(h_y)));
% create the surface plot of the gaussian
figure(3)
hd =surf(x,y,h_y,C1,'FaceColor','interp','Facelight','phong');

camlight right % add a light at the right side of the scene
xlim([-5,5]); % set appropriate axis limits
ylim([-5,5]);
xlabel('x'); % add axis labels
ylabel('y');
zlabel('h(x,y)');
print -r150 -dpng ex3_2b.png
imfiltered_conv = imfilter(im,h_y,'conv') ;

%imshow(imfiltered_conv)
imm2g=mat2gray(imfiltered_conv);
%imshow(imm2g)
imwrite(imm2g,'after_conv.png');
%gaussian 
sigma3=3;

imx=ut_gauss(im,sigma3,1,0);
imx1=mat2gray(imx);
imwrite(imx1,'fx.png');

imy=ut_gauss(im,sigma3,0,1);
imy1=mat2gray(imy);
imwrite(imy1,'fy.png');

imxx=ut_gauss(im,sigma3,2,0);
imxx1=mat2gray(imxx);
imwrite(imxx1,'fxx.png');

imyy=ut_gauss(im,sigma3,0,2);
imyy1=mat2gray(imyy);
imwrite(imxx1,'fyy.png');

imxy=ut_gauss(im,sigma3,1,1);
imxy1=mat2gray(imxy);
imwrite(imxy1,'fxy.png');



%Performing image gradient 
[Gx, Gy] = imgradientxy(im);
[Gmag, Gdir] = imgradient(Gx, Gy);
Gmag1=mat2gray(Gmag);
imwrite(Gmag1,'Gmag.png');

Lap=imxx1+imyy1;
Lap1=mat2gray(Lap);
imwrite(Lap1,'Lap.png');

%binarizing 
imb=imbinarize(Lap1);
imb1=mat2gray(imb,[0,1]);
imwrite(imb1,'Binary.png');

%morphological operations 
SE = strel('diamond',1) ;
NH = getnhood(SE);
ime=imerode(imb1,NH);
ime1=mat2gray(ime,[0,1]);
imsub=imsubtract(imb1,ime1);
imsub1=mat2gray(imsub,[0,1]);
imwrite(imsub1,'ZeroCrossing.png');



imb2=-1*imb+1;
imb3=imbinarize(imb2);
imb4=mat2gray(imb3,[0,1]);
imwrite(imb4,'Binary_neg.png');
SE1 = strel('diamond',1) ;
NH1 = getnhood(SE1);
ime2=imerode(imb4,NH1);
ime3=mat2gray(ime2,[0,1]);
imsub2=imsubtract(imb4,ime3);
imsub3=mat2gray(imsub2,[0,1]);
imwrite(imsub3,'ZeroCrossing_neg.png');



imcomb=(imsub1|imsub3);
imcomb1=mat2gray(imcomb,[0,1]);
imwrite(imcomb1,'combine.png');
imskel=bwmorph(imcomb1,'skel',inf);
imskel1=mat2gray(imskel,[0,1]);
imwrite(imskel1,'skeleton.png');

im6=Gmag1.*imcomb1;
figure(4)
imshow(im6)
imwrite(im6,'6_1.png');
threshold=graythresh(im6)

imedge = edge(imcomb1,'zerocross',[,]);
imedge1=mat2gray(imedge);
imwrite(imedge1,'edge_t.png');
figure(10)
imshow(imedge1);

% setting up Threshold limits
thresh_high=0.5 ;
thresh_low=0.1;
marker=im6>thresh_high;
mask=im6>thresh_low;
imMM=imreconstruct(marker,mask);
%imMM1=mat2gray(imMM);
imwrite(imMM,'masked_image.png');
figure(5)
imshow(imMM)


%Gradient Mask 

imout=ut_edge(im,'c',3,0.6,[0.1,0.1]);
imout1=mat2gray(imout,[0,1]);
imwrite(imout1,'canny.png');

imout2=ut_edge(im,'m',3,0.6,[0.2,0.2]);
imout3=mat2gray(imout2,[0,1]);
imwrite(imout3,'MarrHildreth.png');


%% Part2


IM=im_bloodvessel(2);
[diam,suc]=get_diameters(IM,5,'c');
figure(6)

x=(1:1000);
plot(x,diam);
xlabel('x'); % add axis labels
ylabel('diameter');
title('Diameter plot');
print -r150 -dpng diameter_plot.png

stddev=std(diam);
avgdia=mean(diam);

N=50;
s_rate=zeros(1,N);

for j=1:N
    s=0;
    IM=im_bloodvessel(1.5);
    for i=1:10
        [diam,suc]=get_diameters(IM,4,'c');
        if(suc==1)
            s=s+1;
        end
    end
    s_rate(j)=s*100/N
    std12=std(diam);
    bias12=(37.5-mean(diam));

end
%
%Edge detection
%% 
sigma13=1:1:40;
s_size13=size(sigma13,2);
n=10;
Diam1=zeros(1,n);
Diam2=zeros(1,n);
for j=1:n
    S1=0;
    S2=0;
    Q=im_bloodvessel(1.5);
    for i=1:s_size13
        [diam2,suc2]=get_diameters(Q,sigma13(i),'c');
        if (suc2==1)
            S1=S1+1;
            Diam1=diam2;
        end
        [diam3,suc3]=get_diameters(Q,sigma13(i),'m');
        if (suc3==1)
            S2=S2+1;
            Diam2=diam3;
        end

        S_Rate1(i)=S1*100/n;
        S_Diam1(i)=std(Diam1);
        bias1(i)=abs(37.5-mean(Diam1));
        S_Rate2(i)=S2*100/n;
        S_Diam2(i)=std(Diam2);
        bias2(i)=(mean(37.5-Diam2));
    end
end

Diam3=zeros(1,n);
Diam4=zeros(1,n);
for j=1:n
    S3=0;
    S4=0;
    Q1=im_bloodvessel(3);
    for i=1:s_size13
        [diam4,suc4]=get_diameters(Q1,sigma13(i),'c');
        if (suc2==1)
            S3=S3+1;
            Diam3=diam4;
        end
        [diam5,suc5]=get_diameters(Q1,sigma13(i),'m');
        if (suc3==1)
            S4=S4+1;
            Diam4=diam5;
        end

        S_Rate3(i)=S3*100/n;
        S_Diam3(i)=std(Diam3);
        bias3(i)=abs(75-mean(Diam3));
        S_Rate4(i)=S4*100/n;
        S_Diam4(i)=std(Diam4);
        bias4(i)=(75-mean(Diam4));
    end
end

figure(19);
plot(1:1:40,S_Rate1);
hold on;
plot(1:1:40,S_Rate2);
plot(1:1:40,S_Rate3);
plot(1:1:40,S_Rate4);
hold off;
legend('1.5-c','1.5-m','3-c','3-m')
title('The Success Rate');
xlabel('sigma');
ylabel('success rate');
figure(20);
plot(1:1:40,S_Diam1);
hold on;
plot(1:1:40,S_Diam2);
plot(1:1:40,S_Diam3);
plot(1:1:40,S_Diam4);
hold off;
legend('1.5-c','1.5-m','3-c','3-m')
title('The Standard Deviation');
xlabel('sigma');
ylabel('standard deviation');
figure(21);
plot(1:1:40,bias1);
hold on;
plot(1:1:40,bias2);
plot(1:1:40,bias3);
plot(1:1:40,bias4);
hold off;
legend('1.5-c','1.5-m','3-c','3-m')
title('The Bias');
xlabel('sigma ');
ylabel('bias');


%%end



