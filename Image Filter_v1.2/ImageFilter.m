%==========================================================================
% Image Processing: Butterworth Filter Low-pass, High-pass and Band-pass
% -------------------------------------------------------------------------
% Copyright (C) 2013 Yang Yang,  
%                    Sim Heng Ong
% 
% Contact Information:
% Yang Yang:		yang01@nus.edu.sg
%==========================================================================

function varargout = ImageFilter(varargin)
% IMAGEFILTER MATLAB code for ImageFilter.fig
%      IMAGEFILTER, by itself, creates a new IMAGEFILTER or raises the existing
%      singleton*.
%
%      H = IMAGEFILTER returns the handle to a new IMAGEFILTER or the handle to
%      the existing singleton*.
%
%      IMAGEFILTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEFILTER.M with the given input arguments.
%
%      IMAGEFILTER('Property','Value',...) creates a new IMAGEFILTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageFilter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageFilter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageFilter

% Last Modified by GUIDE v2.5 15-Jan-2013 20:59:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageFilter_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageFilter_OutputFcn, ...
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


% --- Executes just before ImageFilter is made visible.
function ImageFilter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageFilter (see VARARGIN)

% Choose default command line output for ImageFilter
handles.output = hObject;
% Add path for reading codes
addpath('src');
set(handles.slider1,'Value',0.5); 
set(handles.slider4,'Value',0.5); 
set(handles.slider5,'Value',0.5); 
set(handles.slider8,'Value',0.5); 
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageFilter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImageFilter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Open an Image File
file=uigetfile('*.*','Select an Image');
I = imread(file);
I=rgb2gray(I);
handles.I=I;
handles.FI=I;
%Show Image in Axes 1   
imshow(I);
axes(handles.axes1);
guidata(hObject,handles);

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Low-Pass Filter
cutoff=get(handles.slider1,'Value');
order=str2num(get(handles.edit1, 'String'));
if cutoff==0.5
    cutoff=0.5;
else
    cutoff=cutoff;
end
I=ButterworthLow(handles.I,order,cutoff);
%Show Image in Axes 1   
imshow(I);
handles.FI=I;
set(handles.slider2,'Value',0);
set(handles.slider3,'Value',0);
set(handles.slider4,'Value',0.5);  
set(handles.slider5,'Value',0.5);
set(handles.slider6,'Value',0);
set(handles.slider7,'Value',0);  
set(handles.slider8,'Value',0.5); 
axes(handles.axes1);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% High-Pass Filter
cutoff=get(handles.slider2,'Value');
order=str2num(get(handles.edit2, 'String'));
if cutoff==0
    I=ButterworthLow(handles.I,order,0.5);
else
    I=ButterworthHigh(handles.I,order,cutoff);
end
%Show Image in Axes 1   
imshow(I);
handles.FI=I;
set(handles.slider1,'Value',0.5);
set(handles.slider3,'Value',0);
set(handles.slider4,'Value',0.5);  
set(handles.slider5,'Value',0.5);
set(handles.slider6,'Value',0);
set(handles.slider7,'Value',0);  
set(handles.slider8,'Value',0.5); 
axes(handles.axes1);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Band-Pass Filter: Cut-in
cin=get(handles.slider3,'Value');
coff=get(handles.slider4,'Value');
order=str2num(get(handles.edit3, 'String'));

if cin~=0 && coff~=0
    I=Butterworthband(handles.I,order,cin,coff);
end
if cin==0
     I=ButterworthLow(handles.I,order,coff); 
end
if coff==0
     I=ButterworthHigh(handles.I,order,coff); 
end
%Show Image in Axes 1   
imshow(I);
handles.FI=I;
set(handles.edit4,'String',num2str(cin));  
set(handles.edit5,'String',num2str(coff));
set(handles.slider1,'Value',0.5);
set(handles.slider2,'Value',0);
set(handles.slider5,'Value',0.5);  
set(handles.slider6,'Value',0);
set(handles.slider7,'Value',0);  
set(handles.slider8,'Value',0.5); 
axes(handles.axes1);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Band-Pass Filter: Cut-off
cin=get(handles.slider3,'Value');
coff=get(handles.slider4,'Value');
order=str2num(get(handles.edit3, 'String'));

if cin~=0 && coff~=0
    I=Butterworthband(handles.I,order,cin,coff);
end
if cin==0
     I=ButterworthLow(handles.I,order,coff); 
end
if coff==0
     I=ButterworthHigh(handles.I,order,coff); 
end

%Show Image in Axes 1   
imshow(I);
handles.FI=I;
set(handles.edit4,'String',num2str(cin));  
set(handles.edit5,'String',num2str(coff)); 
set(handles.slider1,'Value',0.5);
set(handles.slider2,'Value',0);
set(handles.slider5,'Value',0.5);  
set(handles.slider6,'Value',0);
set(handles.slider7,'Value',0);  
set(handles.slider8,'Value',0.5);  
axes(handles.axes1);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save File
[FileName, PathName] = uiputfile('*.jpg', 'Save As'); 
if PathName==0, return; end  
Name = fullfile(PathName,FileName); 
I=handles.FI;
imwrite(I, Name, 'jpg');



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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
order=str2num(get(handles.edit3, 'String'));
cin=str2num(get(handles.edit4, 'String'));
coff=str2num(get(handles.edit5, 'String'));
if cin~=0 && coff~=0
    I=Butterworthband(handles.I,order,cin,coff);
end
if cin==0
    I=ButterworthLow(handles.I,order,coff);
end
if coff==0
    I=ButterworthHigh(handles.I,order,cin);
end
%Show Image in Axes 1   
imshow(I);
handles.FI=I;
set(handles.slider3,'Value',cin);  
set(handles.slider4,'Value',coff);  
axes(handles.axes1);
guidata(hObject,handles);


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Low-Pass Filter
cutoff=get(handles.slider5,'Value');
if cutoff==0.5
    cutoff=0.5;
else
    cutoff=cutoff;
end
I=IdealLow(handles.I,cutoff);
%Show Image in Axes 1   
imshow(I);
handles.FI=I;
set(handles.slider1,'Value',0.5);
set(handles.slider2,'Value',0);
set(handles.slider3,'Value',0);  
set(handles.slider4,'Value',0.5);
set(handles.slider6,'Value',0);
set(handles.slider7,'Value',0);  
set(handles.slider8,'Value',0.5);
axes(handles.axes1);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Ideal High-Pass Filter
cutoff=get(handles.slider6,'Value');
if cutoff==0
    I=IdealLow(handles.I,0.5);
else
    I=IdealHigh(handles.I,cutoff);
end
%Show Image in Axes 1   
imshow(I);
handles.FI=I;
set(handles.slider1,'Value',0.5);
set(handles.slider2,'Value',0);
set(handles.slider3,'Value',0);  
set(handles.slider4,'Value',0.5);
set(handles.slider5,'Value',0.5);
set(handles.slider7,'Value',0);  
set(handles.slider8,'Value',0.5);
axes(handles.axes1);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Band-Pass Filter: Cut-in
cin=get(handles.slider7,'Value');
coff=get(handles.slider8,'Value');

if cin~=0 && coff~=0
    I=Idealband(handles.I,cin,coff);
end
if cin==0
    I=IdealLow(handles.I,coff);
end
if coff==0
    I=IdealHigh(handles.I,cin);
end

%Show Image in Axes 1   
imshow(I);
handles.FI=I;
set(handles.edit9,'String',num2str(cin));  
set(handles.edit10,'String',num2str(coff));
set(handles.slider1,'Value',0.5);
set(handles.slider2,'Value',0);
set(handles.slider3,'Value',0); 
set(handles.slider4,'Value',0.5);  
set(handles.slider5,'Value',0.5);
set(handles.slider6,'Value',0); 
axes(handles.axes1);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Band-Pass Filter: Cut-in
cin=get(handles.slider7,'Value');
coff=get(handles.slider8,'Value');

if cin~=0 && coff~=0
    I=Idealband(handles.I,cin,coff);
end
if cin==0
    I=IdealLow(handles.I,coff);
end
if coff==0
    I=IdealHigh(handles.I,cin);
end

%Show Image in Axes 1   
imshow(I);
handles.FI=I;
set(handles.edit9,'String',num2str(cin));  
set(handles.edit10,'String',num2str(coff));
set(handles.slider1,'Value',0.5);
set(handles.slider2,'Value',0);
set(handles.slider3,'Value',0); 
set(handles.slider4,'Value',0.5);  
set(handles.slider5,'Value',0.5);
set(handles.slider6,'Value',0); 
axes(handles.axes1);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cin=str2num(get(handles.edit9, 'String'));
coff=str2num(get(handles.edit10, 'String'));
if cin~=0 && coff~=0
    I=Idealband(handles.I,cin,coff);
end
if cin==0
    I=IdealLow(handles.I,coff);
end
if coff==0
    I=IdealHigh(handles.I,cin);
end
%Show Image in Axes 1   
imshow(I);
handles.FI=I;
set(handles.slider7,'Value',cin);  
set(handles.slider8,'Value',coff);  
axes(handles.axes1);
guidata(hObject,handles);
