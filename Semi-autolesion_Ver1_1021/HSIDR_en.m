function HSIDR_en
% HSIR: High Signal Information Detection & Report
% This is main function for semi-auto ROI detection and existing ROI
% information report
% Two subfunctions could be guided in this GUI push buttons
ScSize = get(0,'screensize');
widsize = ScSize(3);
heisize = ScSize(4);
Lsize = (widsize-500)/2;
Dsize = (heisize-500)/2;
HSIDR.total = figure('numbertitle','off',...
    'menubar','none',...              'units','normalized',...
    'color','w',...
    'position',[Lsize,Dsize,500,500],...[0.4   0.4    0.309    0.5],...
    'name','High Signal Information Detection & Report',...
    'resize','off');
[patfun,filen,ext] = fileparts(which('HSIDR_en.m'));
backgroundpictitle = fullfile(patfun,'hospital_bin.jpg');
[backbin backmap] = imread(backgroundpictitle);
backbinmax = max(backbin(:)); % 255
backbinmin = min(backbin(:)); % 0
backbinrange = backbinmax-backbinmin;
backbinranges = double(backbinrange);
backbin_t = (double(backbin)-double(backbinmin))/double(backbinranges); % norm to 0-1
ranges = 1/10;
backbin_t1 = backbin_t*ranges;
backbin_t2 = backbin_t1+(1-ranges);
backbin_t3 = backbin_t2*backbinranges;
backbin2 = uint8(backbin_t3);
colmap = [1-ranges:ranges/64:1;1-ranges:ranges/64:1;1-ranges:ranges/64:1]';
HSIDR.axes = axes('parent',HSIDR.total,...
    'units','norm',...
    'pos',[0 0 1 1]);
image(backbin2,'parent',HSIDR.axes,'CDataMapping','scaled');
axis(HSIDR.axes,'off');
% freezeColors(GLMflex.des.mainwin);
colormap(HSIDR.axes,colmap)
%%
FigR = imread(fullfile(patfun,'RIGHT.jpg'));
HSIDR.Raxes = axes('parent',HSIDR.total,...
    'units','norm',...
    'pos',[0.625,0.125,0.3,0.325]);
image(FigR,'parent',HSIDR.Raxes,'CDataMapping','scaled')
axis(HSIDR.Raxes,'off')

FigL = imread(fullfile(patfun,'LEFT2.jpg'));
HSIDR.Laxes = axes('parent',HSIDR.total,...
    'units','norm',...
    'pos',[0.075,0.125,0.3,0.325]);
image(FigL,'parent',HSIDR.Laxes,'CDataMapping','scaled')
axis(HSIDR.Laxes,'off')
%%
Strings1 ={'High Signal Information','Detection & Report'};
Strings2 = 'V 1.0';
Strings3 = 'Nanjing General Hospital of Nanjing Military Command (Jinling Hospital)';
ssize1 = 0.4;
ssize2 = 0.5;
ssize3 = 0.5;
pos1 = [0.25,0.75,0.5,0.1];
pos2 = [0.45,0.7,0.1,0.05];
pos3 = [0.1,0.65,0.8,0.05];
col_s = [0.9 0.1 0.1;
         0 0 1;
         0 0 1];
uicontrol('parent',HSIDR.total,...
    'units','norm',...              'pos',[0.35,0.80+0.18*(i-1)/3,0.6,0.18/3],...
    'pos',pos1,... 'pos',[0.1,0.80+0.18*(i-1)/3,0.8,0.18/3],...
    'style','text',...
    'string',Strings1,...
    'foregroundcolor',col_s(1,:),...
    'fontname','Arial',...
    'fontunits', 'normalized',...
    'fontsize',ssize1,...
    'fontweight','bold');
uicontrol('parent',HSIDR.total,...
    'units','norm',...              'pos',[0.35,0.80+0.18*(i-1)/3,0.6,0.18/3],...
    'pos',pos2,...'pos',[0.1,0.80+0.18*(i-1)/3,0.8,0.18/3],...
    'style','text',...
    'string',Strings2,...
    'foregroundcolor',col_s(2,:),...
    'fontname','Arial',...
    'fontunits', 'normalized',...
    'fontsize',ssize2,...
    'fontweight','bold');
uicontrol('parent',HSIDR.total,...
    'units','norm',...              'pos',[0.35,0.80+0.18*(i-1)/3,0.6,0.18/3],...
    'pos',pos3,...'pos',[0.1,0.80+0.18*(i-1)/3,0.8,0.18/3],...
    'style','text',...
    'string',Strings3,...
    'foregroundcolor',col_s(3,:),...
    'fontname','Arial',...
    'fontunits', 'normalized',...
    'fontsize',ssize3,...
    'fontweight','bold');

HSIDR.Detect = uicontrol('parent',HSIDR.total,...
    'units','norm',...
    'pos',[0.05,0.5,0.4,0.1],...
    'style','pushbutton',...
    'string','Semi-Auto High Signal Detection');

HSIDR.Report = uicontrol('parent',HSIDR.total,...
    'units','norm',...
    'pos',[0.55,0.5,0.4,0.1],...
    'style','pushbutton',...
    'string','ROI information Reporting');

HSIDR.Changever = uicontrol('parent',HSIDR.total,...
    'units','norm',...
    'pos',[0.4,0.35,0.2,0.08],...
    'style','pushbutton',...
    'string','转换成中文版本');

HSIDR.Helppb = uicontrol('parent',HSIDR.total,...
    'units','norm',...
    'pos',[0.4,0.25,0.2,0.08],...
    'style','pushbutton',...
    'string','HELP');

HSIDR.EXIT = uicontrol('parent',HSIDR.total,...
    'units','norm',...
    'pos',[0.4,0.15,0.2,0.08],...
    'style','pushbutton',...
    'string','EXIT');
set(HSIDR.Detect,'callback',{@HSIDR_Semiauto,HSIDR});
set(HSIDR.Report,'callback',{@HSIDR_Report,HSIDR});
set(HSIDR.EXIT,'callback',{@HSIDR_EXIT,HSIDR});
set(HSIDR.Helppb,'callback',{@HSIDR_HELP,HSIDR});
set(HSIDR.Changever,'callback',{@HSIDR_ChangeVer,HSIDR});
end
function HSIDR_Semiauto(varargin)
HSIDR = varargin{3};
close(HSIDR.total);
clear HSIDR;
Hfig.total = figure('menubar','none',...              
    'units','normalized',...
    'color','w',...
    'position',[0.3   0.45    0.4    0.1],...
    'name','Semi-auto High Signal I/O',...
    'resize','off');
Hfig.InputTEXT1 = uicontrol('parent',Hfig.total,...
    'units','norm',...
    'pos',[0.05,0.55,0.1,0.4],...
    'style','text',...
    'string','Input Data:');

Hfig.InputTEXT2 = uicontrol('parent',Hfig.total,...
    'units','norm',...
    'pos',[0.15,0.55,0.6,0.4],...
    'style','text');
Hfig.InputPB = uicontrol('parent',Hfig.total,...
    'units','norm',...
    'pos',[0.75,0.55,0.1,0.4],...
    'style','pushbutton',...
    'string','Select');

Hfig.OutputTEXT1 = uicontrol('parent',Hfig.total,...
    'units','norm',...
    'pos',[0.05,0.05,0.1,0.4],...
    'style','text',...
    'string','Output Dir:');
Hfig.OutputTEXT2 = uicontrol('parent',Hfig.total,...
    'units','norm',...
    'pos',[0.15,0.05,0.6,0.4],...
    'style','text');
Hfig.OutputPB = uicontrol('parent',Hfig.total,...
    'units','norm',...
    'pos',[0.75,0.05,0.1,0.4],...
    'style','pushbutton',...
    'string','Select');
Hfig.OKPB = uicontrol('parent',Hfig.total,...
    'units','norm',...
    'pos',[0.85,0.05,0.1,0.9],...
    'style','pushbutton',...
    'string','OK');
set(Hfig.InputPB,'callback',{@HfigIN,Hfig});
set(Hfig.OutputPB,'callback',{@HfigOUT,Hfig});
set(Hfig.OKPB,'callback',{@HfigOK,Hfig});
end
function HfigOK(varargin)
Hfig = varargin{3};
INDIR = get(Hfig.InputTEXT2,'string');
OUTDIR = get(Hfig.OutputTEXT2,'string');
if isempty(INDIR)||isempty(OUTDIR)
    disp('Please Select In/Out information');
    return;
end
[dat hdr] = rest_ReadNiftiImage(INDIR);
outputs = OUTDIR;
close(Hfig.total);
clear Hfig;
Semi_auto_Lesionarea_beta3(dat,hdr,outputs);
% Semi_auto_Lesionarea_beta2(dat,hdr,outputs);
end
function HfigIN(varargin)
Hfig = varargin{3};
[filename, pathname] = ...
     uigetfile({'*.nii';'*.img';'*.hdr';'*.*'},'Nifti_1 Image Data selection');
Inputstring = fullfile(pathname,filename);
set(Hfig.InputTEXT2,'string',Inputstring);
end
function HfigOUT(varargin)
Hfig = varargin{3};
folder_name = uigetdir(pwd);
set(Hfig.OutputTEXT2,'string',[folder_name,filesep]);
end
function HSIDR_Report(varargin)
HSIDR = varargin{3};
close(HSIDR.total);
clear HSIDR;
Hfig2.total = figure('menubar','none',...              
    'units','normalized',...
    'color','w',...
    'position',[0.3   0.45    0.4    0.1],...
    'name','ROI report I/O',...
    'resize','off');
Hfig2.InputTEXT1 = uicontrol('parent',Hfig2.total,...
    'units','norm',...
    'pos',[0.02,0.65,0.13,0.3],...
    'style','text',...
    'string','Target Image:');
Hfig2.InputTEXT2 = uicontrol('parent',Hfig2.total,...
    'units','norm',...
    'pos',[0.15,0.65,0.6,0.3],...
    'style','text');
Hfig2.InputPB = uicontrol('parent',Hfig2.total,...
    'units','norm',...
    'pos',[0.75,0.65,0.1,0.3],...
    'style','pushbutton',...
    'string','Select');
%
Hfig2.Input2TEXT1 = uicontrol('parent',Hfig2.total,...
    'units','norm',...
    'pos',[0.02,0.35,0.13,0.3],...
    'style','text',...
    'string','Mask Image:');
Hfig2.Input2TEXT2 = uicontrol('parent',Hfig2.total,...
    'units','norm',...
    'pos',[0.15,0.35,0.6,0.3],...
    'style','text');
Hfig2.Input2PB = uicontrol('parent',Hfig2.total,...
    'units','norm',...
    'pos',[0.75,0.35,0.1,0.3],...
    'style','pushbutton',...
    'string','Select');
%
Hfig2.OutputTEXT1 = uicontrol('parent',Hfig2.total,...
    'units','norm',...
    'pos',[0.02,0.05,0.13,0.3],...
    'style','text',...
    'string','Output Dir:');
Hfig2.OutputTEXT2 = uicontrol('parent',Hfig2.total,...
    'units','norm',...
    'pos',[0.15,0.05,0.6,0.3],...
    'style','text');
Hfig2.OutputPB = uicontrol('parent',Hfig2.total,...
    'units','norm',...
    'pos',[0.75,0.05,0.1,0.3],...
    'style','pushbutton',...
    'string','Select');

Hfig2.OKPB = uicontrol('parent',Hfig2.total,...
    'units','norm',...
    'pos',[0.85,0.05,0.1,0.9],...
    'style','pushbutton',...
    'string','OK');

set(Hfig2.InputPB,'callback',{@Hfig2IN1,Hfig2});
set(Hfig2.Input2PB,'callback',{@Hfig2IN2,Hfig2});
set(Hfig2.OutputPB,'callback',{@Hfig2OUT,Hfig2});
set(Hfig2.OKPB,'callback',{@Hfig2OK,Hfig2});
end
function Hfig2OK(varargin)
Hfig2 = varargin{3};
INDIR = get(Hfig2.InputTEXT2,'string');
INDIR2 = get(Hfig2.Input2TEXT2,'string');
OUTDIR = get(Hfig2.OutputTEXT2,'string');
if isempty(INDIR)||isempty(OUTDIR)||isempty(INDIR2)
    disp('Please Select In/Out information');
    return;
end
[dat hdr] = rest_ReadNiftiImage(INDIR);
[dat2 hdr2] = rest_ReadNiftiImage(INDIR2);
outputs = OUTDIR;
close(Hfig2.total);
clear Hfig2;
ReportROIinformation(dat,dat2,hdr,hdr2,outputs);
end
function Hfig2IN1(varargin)
Hfig2 = varargin{3};
[filename, pathname] = ...
     uigetfile({'*.nii';'*.img';'*.hdr';'*.*'},'Target Data selection(NIFTI_1)');
Inputstring = fullfile(pathname,filename);
set(Hfig2.InputTEXT2,'string',Inputstring);
end
function Hfig2IN2(varargin)
Hfig2 = varargin{3};
[filename, pathname] = ...
     uigetfile({'*.nii';'*.img';'*.hdr';'*.*'},'MASK Data selection(NIFTI_1)');
Inputstring = fullfile(pathname,filename);
set(Hfig2.Input2TEXT2,'string',Inputstring);
end
function Hfig2OUT(varargin)
Hfig2 = varargin{3};
folder_name = uigetdir(pwd);
set(Hfig2.OutputTEXT2,'string',[folder_name,filesep]);
end
function HSIDR_EXIT(varargin)
HSIDR = varargin{3};
close(HSIDR.total);
clear all;
clc;
disp('Thank you to use our program!');
disp('If you have some advise or find problems, please contract us!');
disp('Email: fmrixuq@126.com')
end
function HSIDR_HELP(varargin)
HSIDR = varargin{3};
paths = which('HSIDR_cn.m');
manpath = fileparts(paths);
manpathhelp = fullfile(manpath,'HSIDR_cnhelp.mht');
web(manpathhelp)
end
function HSIDR_ChangeVer(varargin)
HSIDR = varargin{3};
close(HSIDR.total);
HSIDR_cn;
end