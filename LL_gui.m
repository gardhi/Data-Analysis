function varargout = LL_gui(varargin)
% LL_GUI MATLAB code for LL_gui.fig
%      LL_GUI, by itself, creates a new LL_GUI or raises the existing
%      singleton*.
%
%      H = LL_GUI returns the handle to a new LL_GUI or the handle to
%      the existing singleton*.
%
%      LL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LL_GUI.M with the given input arguments.
%
%      LL_GUI('Property','Value',...) creates a new LL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LL_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LL_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to runparameters (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LL_gui

% Last Modified by GUIDE v2.5 27-Oct-2015 13:07:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LL_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @LL_gui_OutputFcn, ...
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


% --- Executes just before LL_gui is made visible.
function LL_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LL_gui (see VARARGIN)

% Choose default command line output for LL_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LL_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LL_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function BattSize_Callback(hObject, eventdata, handles)
% hObject    handle to BattSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BattSize as text
%        str2double(get(hObject,'String')) returns contents of BattSize as a double


% --- Executes during object creation, after setting all properties.
function BattSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BattSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PVSize_Callback(hObject, eventdata, handles)
% hObject    handle to PVSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PVSize as text
%        str2double(get(hObject,'String')) returns contents of PVSize as a double


% --- Executes during object creation, after setting all properties.
function PVSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PVSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RunParameters.
function RunParameters_Callback(hObject, eventdata, handles)
% hObject    handle to RunParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

assignin('base','batt_size',str2num(get(handles.BattSize,'String')));
assignin('base','pv_size',str2num(get(handles.PVSize,'String')));
assignin('base','LL_gui_runmode',1)
assignin('base','plot_SoC',get(handles.plot_SoC,'Value'))

evalin('base','LL_calculations');



function NPV_Callback(hObject, eventdata, handles)
% hObject    handle to NPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NPV as text
%        str2double(get(hObject,'String')) returns contents of NPV as a double


% --- Executes during object creation, after setting all properties.
function NPV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RunNPV.
function RunNPV_Callback(hObject, eventdata, handles)
% hObject    handle to RunNPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base','NPV_target',str2num(get(handles.NPV,'String')));
assignin('base','LL_gui_runmode',2)
assignin('base','plot_SoC',get(handles.plot_SoC,'Value'))

evalin('base','LL_calculations');


% --- Executes on button press in plot_SoC.
function plot_SoC_Callback(hObject, eventdata, handles)
% hObject    handle to plot_SoC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hint: get(hObject,'Value') returns toggle state of plot_SoC