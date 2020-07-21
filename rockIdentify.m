clc;clear;close all;
%初始化
all_area = 0;%石头总面积
rock_accordnum=[];%符合针形的石头编号
bl=0;
%
he = imread('E:\C：\林书庆石头识别\6.png');

lab_he = rgb2lab(he);%转换成l r g 三个色彩空间
ab = lab_he(:,:,2:3);
ab = im2single(ab);
nColors = 3;
% 重复3次聚类以避免局部极小值
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',5);
[imagex,imagey]=size(pixel_labels);
figure(1)
imshow(pixel_labels,[])
title('Image Labeled by Cluster Index');
%image_Stone=input('请输入筛选的图形：')

for i=1:imagex
    for j=1:imagey
        if pixel_labels(i,j)~=2
            pixel_labels(i,j)=0;
        end

    end
end

pixel_labels=logical(pixel_labels);
pixel_labels = bwareafilt(pixel_labels,[100 6500]);%只留下1000~6000的图形
figure(2)
imshow(pixel_labels,[])
title('Image Labeled by Cluster Index');


cc = bwconncomp(pixel_labels,8); 
stats = regionprops(cc,'Area','BoundingBox','MaxFeretProperties','MinFeretProperties');%每个石头的面积和位置 以及长宽
rock=size(stats);
rock_num=rock(1);
j=1;
for i =1:1:rock_num
    lw=stats(i);
    all_area=all_area+lw.Area;
    lw_proportion=lw.MaxFeretDiameter/lw.MinFeretDiameter; %计算最大费雷特直径与最小费雷特直径之比
    if lw_proportion>=2.2
        rock_accordnum(j,1)=i;
        rock_accordnum(j,2)=lw.Area;
        rock_accordnum(j,3)=lw_proportion;
        j=j+1;
    end
end
a=size(rock_accordnum);
for i=1:1:a(1,1)
bl=bl+rock_accordnum(i,2);
end


L = bwlabel(pixel_labels,8);
rock_oknum=rock_accordnum(:,1);
[x_x,y_y]=size(L);
for i=1:x_x
    for j=1:y_y
       if ismember(L(i,j),rock_oknum) 
           L(i,j)=1;
       else if L(i,j)==0
           L(i,j)=0;
           else
           L(i,j)=2;
           end
       end
    end
end
  figure(3)
RGB = label2rgb(L,'jet','k','noshuffle');
imshow(RGB,[]);


real_bl=bl/all_area;
disp('针状石头数量：')
disp(a(1,1))
disp('占总体比例：')
disp(real_bl)