
clear variable;
close all;
clc;
% Reading the images 
images=imageSet('imfolder'); % current folder 
im1=read(images,1);
im2=read(images,2);
im3=read(images,3);
im4=read(images,4);

% Part I,II
%For Point Selection in the Image
for n=1:4
for m=n+1:4
[p{n,m},p{m,n}] = cpselect(read(images,n),read(images,m),'Wait',true);
end
end
save pset p %saving the value in set p
 load psets 
 
%% Stitching of Images
% Applying geometric transform 
T12=estimateGeometricTransform(p{2,1},p{1,2},'projective','MaxDistance',10,'MaxNumTrials',100);
T01=projective2d;
T23=estimateGeometricTransform(p{3,2},p{2,3},'projective','MaxDistance',10,'MaxNumTrials',100);
T34=estimateGeometricTransform(p{4,3},p{3,4},'projective','MaxDistance',10,'MaxNumTrials',100);
tform=[T01,T12,T23,T34];
tform1=tform;

for n=4:-1:3
 tform1(n).T=tform1(n-1).T*tform1(n-2).T;
 p{n-1,n}=transformPointsForward(tform1(n),p{n-1,n});
 tform1(n)=estimateGeometricTransform(p{n,n-1},p{n-1,n},'projective','MaxDistance',10,'MaxNumTrials',100);
end
% defining the dimensions 
[xlim1,ylim1]=outputLimits(tform1(1),[1,1224],[1,1632]);
[xlim2,ylim2]=outputLimits(tform1(2),[1,1224],[1,1632]);
[xlim3,ylim3]=outputLimits(tform1(3),[1,1224],[1,1632]);
[xlim4,ylim4]=outputLimits(tform1(4),[1,1224],[1,1632]);
xlim=[xlim1,xlim2,xlim3,xlim4];
ylim=[ylim1,ylim2,ylim3,ylim4];

xmin=min(xlim(:));
xmax=max(xlim(:));

ymin=min(ylim(:));
ymax=max(ylim(:));

%setting world reference limits 
xWorldLimits=[xmin,xmax];
yWorldLimits=[ymin,ymax];

height=round(ymax-ymin);
width=round(xmax-xmin);

imref=imref2d([height width],xWorldLimits,yWorldLimits);
%wrapping the images 
im11=imwarp(im1,tform1(1),'OutputView',imref);
im22=imwarp(im2,tform1(2),'OutputView',imref);
im33=imwarp(im3,tform1(3),'OutputView',imref);
im44=imwarp(im4,tform1(4),'OutputView',imref);
% Applying alpha blend 
alphablend=vision.AlphaBlender('Operation','Binary Mask','MaskSource','Input port');
im11= step(alphablend,im11,im22,im22(:,:,1));
im11= step(alphablend,im11,im33,im33(:,:,1));
im11= step(alphablend,im11,im44,im44(:,:,1));
imshow(im11);
imwrite(im11,'Stitch_all.png');% writing stitched images

