clc;clear;close all;
%��ʼ��
all_area = 0;%ʯͷ�����
rock_accordnum=[];%�������ε�ʯͷ���
bl=0;
%
he = imread('E:\C��\������ʯͷʶ��\6.png');

lab_he = rgb2lab(he);%ת����l r g ����ɫ�ʿռ�
ab = lab_he(:,:,2:3);
ab = im2single(ab);
nColors = 3;
% �ظ�3�ξ����Ա���ֲ���Сֵ
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',5);
[imagex,imagey]=size(pixel_labels);
figure(1)
imshow(pixel_labels,[])
title('Image Labeled by Cluster Index');
%image_Stone=input('������ɸѡ��ͼ�Σ�')

for i=1:imagex
    for j=1:imagey
        if pixel_labels(i,j)~=2
            pixel_labels(i,j)=0;
        end

    end
end

pixel_labels=logical(pixel_labels);
pixel_labels = bwareafilt(pixel_labels,[100 6500]);%ֻ����1000~6000��ͼ��
figure(2)
imshow(pixel_labels,[])
title('Image Labeled by Cluster Index');


cc = bwconncomp(pixel_labels,8); 
stats = regionprops(cc,'Area','BoundingBox','MaxFeretProperties','MinFeretProperties');%ÿ��ʯͷ�������λ�� �Լ�����
rock=size(stats);
rock_num=rock(1);
j=1;
for i =1:1:rock_num
    lw=stats(i);
    all_area=all_area+lw.Area;
    lw_proportion=lw.MaxFeretDiameter/lw.MinFeretDiameter; %������������ֱ������С������ֱ��֮��
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
disp('��״ʯͷ������')
disp(a(1,1))
disp('ռ���������')
disp(real_bl)