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

% Last Modified by GUIDE v2.5 29-Oct-2015 15:22:12

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

set(handles.plot_SoC,'Value',1)
set(handles.plot_power_balance,'Value',1)
set(handles.disp_avg,'Value',1)
set(handles.disp_worst_case,'Value',1)
set(handles.disp_overprod,'Value',1)
set(handles.disp_gen_req,'Value',1)
set(handles.disp_biomass_req,'Value',0)

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



function batt_size_Callback(hObject, eventdata, handles)
% hObject    handle to batt_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of batt_size as text
%        str2double(get(hObject,'String')) returns contents of batt_size as a double


% --- Executes during object creation, after setting all properties.
function batt_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batt_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pv_size_Callback(hObject, eventdata, handles)
% hObject    handle to pv_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pv_size as text
%        str2double(get(hObject,'String')) returns contents of pv_size as a double


% --- Executes during object creation, after setting all properties.
function pv_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pv_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function NPV_Callback(hObject, eventdata, handles)
% hObject    handle to pv_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pv_size as text
%        str2double(get(hObject,'String')) returns contents of pv_size as a double


% --- Executes during object creation, after setting all properties.
function NPV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pv_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function fix_NPV_Callback(hObject, eventdata, handles)
% hObject    handle to fix_NPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fix_NPV as text
%        str2double(get(hObject,'String')) returns contents of fix_NPV as a double


% --- Executes during object creation, after setting all properties.
function fix_NPV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fix_NPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

run_mode = get(handles.run_mode_choice,'SelectedObject');
run_mode = get(run_mode,'String');
if strcmp(run_mode,'Fix Net Present Value')
    assignin('base','NPV_target',str2num(get(handles.NPV,'String')));
    assignin('base','LL_gui_runmode',2)
end
if strcmp(run_mode,'Fix Component Sizes')
    assignin('base','batt_size',str2num(get(handles.batt_size,'String')));
    assignin('base','pv_size',str2num(get(handles.pv_size,'String')));
    assignin('base','LL_gui_runmode',1)
end

assignin('base','plot_SoC',get(handles.plot_SoC,'Value'))
assignin('base','plot_power_balance',get(handles.plot_power_balance,'Value'))
assignin('base','disp_avg',get(handles.disp_avg,'Value'))
assignin('base','disp_worst_case',get(handles.disp_worst_case,'Value'))
assignin('base','disp_overprod',get(handles.disp_overprod,'Value'))
assignin('base','disp_gen_req',get(handles.disp_gen_req,'Value'))
assignin('base','disp_biomass_req',get(handles.disp_biomass_req,'Value'))

evalin('base','LL_calculations');


% --- Executes on button press in plot_power_balance.
function plot_power_balance_Callback(hObject, eventdata, handles)
% hObject    handle to plot_power_balance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hint: get(hObject,'Value') returns toggle state of plot_power_balance


% --- Executes on button press in plot_SoC.
function plot_SoC_Callback(hObject, eventdata, handles)
% hObject    handle to plot_SoC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_SoC


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all



% --- Executes on button press in disp_avg.
function disp_avg_Callback(hObject, eventdata, handles)
% hObject    handle to disp_avg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of disp_avg


% --- Executes on button press in disp_worst_case.
function disp_worst_case_Callback(hObject, eventdata, handles)
% hObject    handle to disp_worst_case (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of disp_worst_case


% --- Executes on button press in disp_overprod.
function disp_overprod_Callback(hObject, eventdata, handles)
% hObject    handle to disp_overprod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of disp_overprod


% --- Executes on button press in disp_gen_req.
function disp_gen_req_Callback(hObject, eventdata, handles)
% hObject    handle to disp_gen_req (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of disp_gen_req


% --- Executes on button press in disp_opt_sol.
function disp_opt_sol_Callback(hObject, eventdata, handles)
% hObject    handle to disp_opt_sol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MA_opt = evalin('base', 'MA_opt_norm_bhut_jun15_20_10');
format bank
disp(MA_opt)
% for i = 1:length(MA_opt)
%     disp([MA_opt(i,1) MA_opt(i,2) MA_opt(i,3) MA_opt(i,4) MA_opt(i,5) MA_opt(i,6)])
% end




% --- Executes on button press in disp_biomass_req.
function disp_biomass_req_Callback(hObject, eventdata, handles)
% hObject    handle to disp_biomass_req (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of disp_biomass_req
