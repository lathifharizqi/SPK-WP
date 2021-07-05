function varargout = paketStudi(varargin)
% PAKETSTUDI MATLAB code for paketStudi.fig
%      PAKETSTUDI, by itself, creates a new PAKETSTUDI or raises the existing
%      singleton*.
%
%      H = PAKETSTUDI returns the handle to a new PAKETSTUDI or the handle to
%      the existing singleton*.
%
%      PAKETSTUDI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PAKETSTUDI.M with the given input arguments.
%
%      PAKETSTUDI('Property','Value',...) creates a new PAKETSTUDI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before paketStudi_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to paketStudi_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help paketStudi

% Last Modified by GUIDE v2.5 05-Jul-2021 18:31:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @paketStudi_OpeningFcn, ...
                   'gui_OutputFcn',  @paketStudi_OutputFcn, ...
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


% --- Executes just before paketStudi is made visible.
function paketStudi_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to paketStudi (see VARARGIN)

%import dataset
opts = detectImportOptions('dataset.xlsx');
opts.SelectedVariableNames = (1); 
data = readmatrix('dataset', opts);
opts.SelectedVariableNames = (3:7);
data=[data readmatrix('dataset', opts)]; %matriks data diisi nilai dataset kolom 1 dan kolom 3 sampai kolom 7 
set(handles.tdataset,'data',data); %tampilkan matriks dataset pada table tdataset
handles.data=data; %simpan matriks data di variabel global
guidata(hObject,handles);

% Choose default command line output for paketStudi
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes paketStudi wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = paketStudi_OutputFcn(hObject, eventdata, handles) 
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
data=handles.data(1:end,2:6); %matriks data diambil dari matriks handles.data kolom 2 sampai 6
k=[0,1,1,1,1]; %penentuan atribut kriteria 0 untuk atribut biaya dan 1 untuk atribut keuntungan

%ambil nilai dari edit text
bobot(1)= str2double(get(handles.edit1,'String'));
bobot(2)= str2double(get(handles.edit2,'String'));
bobot(3)= str2double(get(handles.edit3,'String'));
bobot(4)= str2double(get(handles.edit4,'String'));
bobot(5)= str2double(get(handles.edit5,'String'));
w=[bobot(1),bobot(2),bobot(3),bobot(4),bobot(5)]; %simpan di matriks bobot w

%normalisasi bobot
[m n]=size(data); %inisialisasi ukuran x
w=w./sum(w); %membagi bobot per kriteria dengan jumlah total seluruhbobot

%menentukan nilai vektor s
for j=1:n,
if k(j)==0, w(j)=-1*w(j); %jika atribut 0 maka nilai bobotnya dikalikan -1
end;
end;
for i=1:m,
S(i)=prod(data(i,:).^w); %nilai S tiap baris didapat dari perkalian semua nilai kriteria tiap kolom yang dipangkatkan bobotnya
end;

%tahapan ketiga, mengisi vector v
V= S/sum(S); %nilai V tiap baris didapatkan dari nilai S tiap baris dibagi dengan jumlah S semua baris
V=reshape(V,[16,1]); %perubahan bentuk matriks V dari kolom menjadi baris
data=[V handles.data(1:end,1) data]; %matriks data berisi gabungan matriks V, matriks handles.data kolom 1, dan matriks data
data=sortrows(data,1,'descend'); %data matriks data dirurtkan berdasarkan nilai apda kolom 1 nya secara descending
data=data(1:5,1:end); %matriks data diambil 5 baris teratasnya
kode=data(1:5,2); %matriks kode diisi kolom ke 2 matriks data
set(handles.uitable3,'data',data); %matriks data ditampilkan pada table uitable3

%proses pengisian table detail paket
opts = detectImportOptions('dataset.xlsx');
opts.SelectedVariableNames = (8:9);
data = readmatrix('dataset', opts); %matriks diisi kolom detail kota, dan detail destinasi pada data

%proses pengurutan data detail paket sesuai urutan peringkat pada proses sebelumnya
data2(1,1:2)=data(kode(1),1:2);
data2(2,1:2)=data(kode(2),1:2);
data2(3,1:2)=data(kode(3),1:2);
data2(4,1:2)=data(kode(4),1:2);
data2(5,1:2)=data(kode(5),1:2);
set(handles.uitable4,'data',data2); %matriks data2 ditampilkan pada table uitable4

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


% --- Executes during object creation, after setting all properties.
function tdataset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
