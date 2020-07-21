function varargout = untitled1(varargin)
% UNTITLED1 MATLAB code for untitled1.fig
%      UNTITLED1, by itself, creates a new UNTITLED1 or raises the existing
%      singleton*.
%
%      H = UNTITLED1 returns the handle to a new UNTITLED1 or the handle to
%      the existing singleton*.
%
%      UNTITLED1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED1.M with the given input arguments.
%
%      UNTITLED1('Property','Value',...) creates a new UNTITLED1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled1

% Last Modified by GUIDE v2.5 15-Jul-2020 02:34:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled1_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before untitled1 is made visible.
function untitled1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled1 (see VARARGIN)

% Choose default command line output for untitled1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global fpath;
[filename,pathname]=uigetfile({'*.jpg';'*.png'},'选择图片');
fpath=[pathname filename];
cla(handles.axes1);
axes(handles.axes1);
image = imread(fpath);
imshow(image);
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global fpath;
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
% figure(1)
% imshow(pixel_labels,[])
% title('Image Labeled by Cluster Index');
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
% figure(2)
% imshow(pixel_labels,[])
% title('Image Labeled by Cluster Index');


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

RGB = label2rgb(L,'jet','k','noshuffle');

real_bl=bl/all_area;
cla(handles.axes2);
axes(handles.axes2);
imshow(RGB);
A=['针状石头有' num2str(a(1,1)) '个，' '占总体比例为' num2str(real_bl*100) '%'];
set(handles.edit2,'string',A);
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
