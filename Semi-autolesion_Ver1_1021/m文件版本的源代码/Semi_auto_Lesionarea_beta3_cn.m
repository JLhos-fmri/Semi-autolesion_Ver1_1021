function Semi_auto_Lesionarea_beta3_cn(dat,hdr,outputs)
CMAPS = [0:1/127:1;0:1/127:1;0:1/127:1]';
dims = size(dat);
HSAL.DAT = dat;
HSAL.HDR = hdr;
HSAL.OUT = outputs;
HSAL.total = figure('menubar','none',...
    'color','w',...
    'units','normalized',...
    'position',[0.2,0.2,0.6,0.6],...
    'name','半自动化高信号区域分割工具 1.0版本');
HSAL.Sagittal = axes('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.5,0.65,0.225,0.3]);
HSAL.Coronal = axes('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.75,0.65,0.225,0.3]);
HSAL.Axial = axes('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.5,0.3,0.225,0.3]);
HSAL.Sel = axes('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.1,0.425,0.3,0.45]);
axis(HSAL.Sel,'off')
HSAL.Selrad(1) = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.1,0.9,0.1,0.05],...
    'style','rad',...
    'val',1,...
    'string','横断位');
HSAL.Selrad(2) = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.2,0.9,0.1,0.05],...
    'style','rad',...
    'val',0,...
    'string','矢状位');
HSAL.Selrad(3) = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.3,0.9,0.1,0.05],...
    'style','rad',...
    'val',0,...
    'string','冠状位');
HSAL.sliceslide = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.1,0.3,0.3,0.08],...
    'style','slide',...
    'Min',1,...
    'Max',dims(3),...
    'val',round(dims(3)/2),...
    'SliderStep',[1/dims(3) 1/dims(3)]);
axis(HSAL.Axial,[0,size(dat,2),0,size(dat,1)])
axis(HSAL.Coronal,[0,size(dat,1),0,size(dat,3)])
axis(HSAL.Sagittal,[0,size(dat,2),0,size(dat,3)])
axis(HSAL.Sel,[0,size(dat,2),0,size(dat,1)]);

minv = round(min(HSAL.DAT(HSAL.DAT>0)));
maxv = round(max(HSAL.DAT(HSAL.DAT>0)));
% dat = (dat-min(dat(:)))/(max(dat(:))-min(dat(:)));
Axialimgtemp = squeeze(dat(:,:,round(dims(3)/2)));
Axialimgtemp(1,1) = 0;
Axialimgtemp(end,end) = maxv;
% figure;imagesc(Axialimgtemp);
image(Axialimgtemp,'parent',HSAL.Axial,'CDataMapping','scaled');
colormap(HSAL.Axial,CMAPS);
Coronalimgtemp1 = squeeze(dat(:,round(dims(2)/2),:));
Coronalimgtemp = rot90(Coronalimgtemp1);
Coronalimgtemp(1,1) = 0;
Coronalimgtemp(end,end) = maxv;
image(Coronalimgtemp,'parent',HSAL.Coronal,'CDataMapping','scaled');
colormap(HSAL.Coronal,CMAPS);
Sagittalimgtemp1 = squeeze(dat(round(dims(1)/2),:,:));
Sagittalimgtemp = rot90(Sagittalimgtemp1);
Sagittalimgtemp(1,1) = 0;
Sagittalimgtemp(end,end) = maxv;
image(Sagittalimgtemp,'parent',HSAL.Sagittal,'CDataMapping','scaled');
colormap(HSAL.Sagittal,CMAPS);
image(Axialimgtemp,'parent',HSAL.Sel,'CDataMapping','scaled');
colormap(HSAL.Sel,CMAPS);
HSAL.PickButton = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.05,0.2,0.1,0.08],...
    'string','起始区域选择',...
    'style','pushbutton');
HSAL.Xpos = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.17,0.2,0.05,0.08],...
    'style','text',...
    'string',['左右维度（矢状位）: ',num2str(round(dims(1)/2))]);
HSAL.Ypos = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.23,0.2,0.05,0.08],...
    'style','text',...
    'string',['前后维度（冠状位）: ',num2str(round(dims(2)/2))]);
HSAL.Zpos = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.29,0.2,0.05,0.08],...
    'style','text',...
    'string',['上下维度（横断位）: ',num2str(round(dims(3)/2))]);
HSAL.Val = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.35,0.2,0.05,0.08],...
    'style','text',...
    'string',['目前维度: ',num2str(HSAL.DAT((round(dims(1)/2)),(round(dims(2)/2)),(round(dims(3)/2))))]);
HSAL.DeletePB = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.45,0.2,0.04,0.08],...
    'style','pushbutton',...
    'string','删除');
%%
stepv1 = 1/10;
stepv2 = 1/100;
HSAL.Graysel_slideMax = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.25,0.05,0.13,0.05],...
    'style','slide',...
    'Min',minv,...
    'Max',maxv,...
    'SliderStep',[stepv2,stepv1],...
    'val',maxv);

HSAL.Graysel_slideMin = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.1,0.05,0.13,0.05],...
    'style','slide',...
    'Min',minv,...
    'Max',maxv,...
    'SliderStep',[stepv2,stepv1],...
    'val',minv);
HSAL.GraySel_txt = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.02,0.05,0.08,0.05],...
    'style','text',...
    'string','灰度修正');
HSAL.SNAKE_p1_text = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'style','text',...
    'pos',[0.01,0.11,0.09,0.05],...
    'string','迭代次数');

HSAL.SNAKE_p1_edit = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'style','edit',...
    'pos',[0.1,0.11,0.04,0.05],...
    'string','200');

HSAL.SNAKE_p2_text = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'style','text',...
    'pos',[0.15,0.11,0.14,0.05],...
    'string','平滑权重(alpha)');

HSAL.SNAKE_p2_edit = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'style','edit',...
    'pos',[0.3,0.11,0.04,0.05],...
    'string','0.2');

HSAL.Graysel_text = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.42,0.05,0.25,0.05],...
    'style','text',...
    'string',['当前值 val',['  (最小 ',num2str(round(minv)),';最大 ',num2str(round(maxv)),')']]);

HSAL.Repick_button = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.35,0.11,0.09,0.05],...
    'style','pushbutton',...
    'string','单层选择');
HSAL.OK_button = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.45,0.11,0.04,0.05],...
    'style','pushbutton',...
    'string','单层成功');

HSAL.RelatedInfo_text = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.75,0.4,0.225,0.2],...
    'style','text');

HSAL.RelatedInfo_text2 = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.75,0.2,0.225,0.2],...
    'style','text');

HSAL.ADDROI = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.5,0.11,0.04,0.05],...
    'style','pushbutton',...
    'string','添加');
HSAL.ADDROIFinish = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.55,0.11,0.09,0.05],...
    'style','pushbutton',...
    'string','添加成功');
HSAL.Finish = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.7,0.05,0.15,0.15],...
    'style','pushbutton',...
    'string','完成');
HSAL.Exit = uicontrol('parent',HSAL.total,...
    'units','norm',...
    'pos',[0.88,0.05,0.10,0.15],...
    'style','pushbutton',...
    'string','退出');
%
test_mouse_track2([],[],HSAL,dims,dat);
set(HSAL.Selrad(1),'callback',{@HSAL_seltype1,HSAL,dat,dims})
set(HSAL.Selrad(2),'callback',{@HSAL_seltype2,HSAL,dat,dims})
set(HSAL.Selrad(3),'callback',{@HSAL_seltype3,HSAL,dat,dims})
set(HSAL.sliceslide,'callback',{@HSAL_SLIDE,HSAL,dat,dims})
set(HSAL.PickButton,'callback',{@HSAL_Pickpoint2_Whole,HSAL,dat,dims})
set(HSAL.Graysel_slideMin,'callback',{@HSAL_SetShowThr,HSAL,dat,dims});
set(HSAL.Graysel_slideMax,'callback',{@HSAL_SetShowThr,HSAL,dat,dims});
set(HSAL.Repick_button,'callback',{@HSAL_Pickpoint2,HSAL,dat,dims});
set(HSAL.OK_button,'callback',{@HSAL_PICKOK,HSAL,dat,dims});
set(HSAL.ADDROI,'callback',{@HSAL_Pickpoint2,HSAL,dat,dims});
set(HSAL.ADDROIFinish,'callback',{@HSAL_ADDOK,HSAL,dat,dims});
set(HSAL.Finish,'callback',{@HSAL_FINISH,HSAL,dat,dims});
set(HSAL.Exit,'callback',{@HSAL_EXIT,HSAL});
set(HSAL.DeletePB,'callback',{@HSAL_DEL,HSAL,dat,dims});
end
function HSAL_DEL(varargin)
HSAL = varargin{3};
valsels = get(HSAL.Selrad,'val');
DATX= get(HSAL.Xpos,'string');
tempsx = find(DATX==':');
DATX(tempsx+2:end)
DATXtemp = str2num(DATX(tempsx+2:end));
DATY= get(HSAL.Ypos,'string');
tempsy = find(DATY==':');
DATY(tempsy+2:end)
DATYtemp = str2num(DATY(tempsy+2:end));
DATZ= get(HSAL.Zpos,'string');
tempsz = find(DATZ==':');
DATZ(tempsz+2:end)
DATZtemp = str2num(DATZ(tempsz+2:end));
XDIMS = DATXtemp;
YDIMS = DATYtemp;
ZDIMS = DATZtemp;
OUTS = HSAL.OUT;

if valsels{1}
    delete([OUTS,filesep,'Axial_',num2str(ZDIMS),'.mat'])
    delete([OUTS,filesep,'Axial_',num2str(ZDIMS),'_add.mat'])
elseif valsels{2}
    delete([OUTS,filesep,'Sagittal_',num2str(XDIMS),'.mat'])
    delete([OUTS,filesep,'Sagittal_',num2str(XDIMS),'_add.mat'])
else
    delete([OUTS,filesep,'Coronal_',num2str(YDIMS),'.mat'])
    delete([OUTS,filesep,'Coronal_',num2str(YDIMS),'_add.mat'])
end
end
function HSAL_ADDOK(varargin)
HSAL = varargin{3};
DATS = HSAL.DAT;
dat = varargin{4};
dims = varargin{5};
TEMPINFO = load('temp');
if TEMPINFO.valsels{1}
    Outnames = ['Axial_',num2str(TEMPINFO.DATZtemp),'_add.mat'];
    Showinfo = ['Axial: ',num2str(TEMPINFO.DATZtemp)];
    DAT0 = squeeze(DATS(:,:,TEMPINFO.DATZtemp));
elseif TEMPINFO.valsels{2}
    Outnames = ['Sagittal_',num2str(TEMPINFO.DATXtemp),'_add.mat'];
    Showinfo = ['Sagittal: ',num2str(TEMPINFO.DATXtemp)];
    DAT0 = rot90(squeeze(DATS(TEMPINFO.DATXtemp,:,:)));
else
    Outnames = ['Coronal_',num2str(TEMPINFO.DATYtemp),'_add.mat'];
    Showinfo = ['Coronal: ',num2str(TEMPINFO.DATYtemp)];
    DAT0 = rot90(squeeze(DATS(:,TEMPINFO.DATYtemp,:)));
end
butinfo = 'Restore';
if ~isempty(dir([TEMPINFO.HSAL.OUT,Outnames]))
    butinfo = questdlg(['已经存在的文件: ',Outnames],'Exist files','Restore','Cancel','Restore');
end
if strcmp(butinfo,'Cancel')
    Relatedinfo = load([TEMPINFO.HSAL.OUT,Outnames]);
    INDS = find(Relatedinfo.SEGMENTS);
    set(HSAL.RelatedInfo_text2,'string',{'添加的ROI相应信息',...
        ['ROI体素数目: ',num2str(nnz(Relatedinfo.SEGMENTS))],...
        Showinfo,['最大值: ',num2str(max(DAT0(INDS)))],...
        ['最小值: ',num2str(min(DAT0(INDS)))],...
        ['均值: ',num2str(mean(DAT0(INDS)))]})
    return;
end
MASKS = TEMPINFO.masks;
ITERNUMS = TEMPINFO.valiter;
ALPHA = TEMPINFO.valalpha;
PHI = TEMPINFO.phi;
SEGMENTS = TEMPINFO.seg;
INDS = find(SEGMENTS);
set(HSAL.RelatedInfo_text2,'string',{'添加的ROI相应信息',...
    ['ROI体素数目: ',num2str(nnz(SEGMENTS))],...
    Showinfo,['最大值: ',num2str(max(DAT0(INDS)))],...
    ['最小值: ',num2str(min(DAT0(INDS)))],...
    ['均值: ',num2str(mean(DAT0(INDS)))]})
save([TEMPINFO.HSAL.OUT,Outnames],'MASKS','ITERNUMS','ALPHA','PHI','SEGMENTS');
axis(HSAL.Axial,'off');
axis(HSAL.Coronal,'off');
axis(HSAL.Sagittal,'off');
axis(HSAL.Sel,'off');
end
function HSAL_PICKOK(varargin)
HSAL = varargin{3};
DATS = HSAL.DAT;
dat = varargin{4};
dims = varargin{5};
TEMPINFO = load('temp');
if TEMPINFO.valsels{1}
    Outnames = ['Axial_',num2str(TEMPINFO.DATZtemp),'.mat'];
    Showinfo = ['Axial: ',num2str(TEMPINFO.DATZtemp)];
    DAT0 = squeeze(DATS(:,:,TEMPINFO.DATZtemp));
elseif TEMPINFO.valsels{2}
    Outnames = ['Sagittal_',num2str(TEMPINFO.DATXtemp),'.mat'];
    Showinfo = ['Sagittal: ',num2str(TEMPINFO.DATXtemp)];
    DAT0 = rot90(squeeze(DATS(TEMPINFO.DATXtemp,:,:)));
else
    Outnames = ['Coronal_',num2str(TEMPINFO.DATYtemp),'.mat'];
    Showinfo = ['Coronal: ',num2str(TEMPINFO.DATYtemp)];
    DAT0 = rot90(squeeze(DATS(:,TEMPINFO.DATYtemp,:)));
end
butinfo = 'Restore';
if ~isempty(dir([TEMPINFO.HSAL.OUT,Outnames]))
    butinfo = questdlg(['已经存在的文件: ',Outnames],'Exist files','Restore','Cancel','Restore');
end
if strcmp(butinfo,'Cancel')
    Relatedinfo = load([TEMPINFO.HSAL.OUT,Outnames]);
    INDS = find(Relatedinfo.SEGMENTS);
    set(HSAL.RelatedInfo_text2,'string',{['区域体素数目: ',num2str(nnz(Relatedinfo.SEGMENTS))],...
        Showinfo,['最大值: ',num2str(max(DAT0(INDS)))],...
        ['最小值: ',num2str(min(DAT0(INDS)))],...
        ['平均值: ',num2str(mean(DAT0(INDS)))]})
    return;
end
MASKS = TEMPINFO.masks;
ITERNUMS = TEMPINFO.valiter;
ALPHA = TEMPINFO.valalpha;
PHI = TEMPINFO.phi;
SEGMENTS = TEMPINFO.seg;
INDS = find(SEGMENTS);
set(HSAL.RelatedInfo_text2,'string',{['区域体素数目: ',num2str(nnz(SEGMENTS))],...
    Showinfo,['最大值: ',num2str(max(DAT0(INDS)))],...
    ['最小值: ',num2str(min(DAT0(INDS)))],...
    ['平均值: ',num2str(mean(DAT0(INDS)))]})
save([TEMPINFO.HSAL.OUT,Outnames],'MASKS','ITERNUMS','ALPHA','PHI','SEGMENTS');
axis(HSAL.Axial,'off');
axis(HSAL.Coronal,'off');
axis(HSAL.Sagittal,'off');
axis(HSAL.Sel,'off');
end
function HSAL_PICKOK2(varargin)
HSAL = varargin{3};
DATS = HSAL.DAT;
dat = varargin{4};
dims = varargin{5};
TEMPINFO = load('temp');
if TEMPINFO.valsels{1}
    Outnames = ['Axial_',num2str(TEMPINFO.DATZtemp),'.mat'];
    Showinfo = ['Axial: ',num2str(TEMPINFO.DATZtemp)];
    DAT0 = squeeze(DATS(:,:,TEMPINFO.DATZtemp));
elseif TEMPINFO.valsels{2}
    Outnames = ['Sagittal_',num2str(TEMPINFO.DATXtemp),'.mat'];
    Showinfo = ['Sagittal: ',num2str(TEMPINFO.DATXtemp)];
    DAT0 = rot90(squeeze(DATS(TEMPINFO.DATXtemp,:,:)));
else
    Outnames = ['Coronal_',num2str(TEMPINFO.DATYtemp),'.mat'];
    Showinfo = ['Coronal: ',num2str(TEMPINFO.DATYtemp)];
    DAT0 = rot90(squeeze(DATS(:,TEMPINFO.DATYtemp,:)));
end

MASKS = TEMPINFO.masks;
ITERNUMS = TEMPINFO.valiter;
ALPHA = TEMPINFO.valalpha;
PHI = TEMPINFO.phi;
SEGMENTS = TEMPINFO.seg;
INDS = find(SEGMENTS);
set(HSAL.RelatedInfo_text2,'string',{['区域体素数目: ',num2str(nnz(SEGMENTS))],...
    Showinfo,['最大值: ',num2str(max(DAT0(INDS)))],...
    ['最小值: ',num2str(min(DAT0(INDS)))],...
    ['平均值: ',num2str(mean(DAT0(INDS)))]})
save([TEMPINFO.HSAL.OUT,Outnames],'MASKS','ITERNUMS','ALPHA','PHI','SEGMENTS');
axis(HSAL.Axial,'off');
axis(HSAL.Coronal,'off');
axis(HSAL.Sagittal,'off');
axis(HSAL.Sel,'off');
end
function HSAL_SetShowThr(varargin)
CMAPS = [0:1/127:1;0:1/127:1;0:1/127:1]';
HSAL = varargin{3};
dat = varargin{4};
dims = varargin{5};
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';
maxv = round(max(HSAL.DAT(HSAL.DAT>0)));
valsmin0 = get(HSAL.Graysel_slideMin,'val');
valsmax0 = get(HSAL.Graysel_slideMax,'val');
valsels = get(HSAL.Selrad,'val');
DATS = HSAL.DAT;
valslid = get(HSAL.sliceslide,'val');
set(HSAL.Graysel_text,'string',['当前 最大: ',num2str(valsmax0),',最小: ',num2str(valsmin0)]);
if valsmin0>valsmax0
    set(HSAL.Graysel_slideMax,'val',valsmin0);
end
if valsels{1}  %% val 1:dims(3)
    axialimgtemp = squeeze(DATS(:,:,round(valslid)));
    axialimgtemp(axialimgtemp<valsmin0) = valsmin0;
    axialimgtemp(axialimgtemp>valsmax0) = valsmax0;
    axialimgtemp(axialimgtemp>0) = (axialimgtemp(axialimgtemp>0)-valsmin0)/(valsmax0-valsmin0);
    image(axialimgtemp,'parent',HSAL.Sel,'CDataMapping','scaled');
    colormap(HSAL.Sel,cmaps);
    axis(HSAL.Sel,'off');
elseif valsels{2}
    Sagittalimgtemp = rot90(squeeze(DATS(round(valslid),:,:)));
    Sagittalimgtemp(Sagittalimgtemp<valsmin0) = valsmin0;
    Sagittalimgtemp(Sagittalimgtemp>valsmax0) = valsmax0;
    Sagittalimgtemp(Sagittalimgtemp>0) = (Sagittalimgtemp(Sagittalimgtemp>0)-valsmin0)/(valsmax0-valsmin0);
    image(Sagittalimgtemp,'parent',HSAL.Sel,'CDataMapping','scaled');
    colormap(HSAL.Sel,cmaps);
    axis(HSAL.Sel,'off');
else
    TEMPIMG = rot90(squeeze(DATS(:,round(valslid),:)));
    TEMPIMG(TEMPIMG<valsmin0) = valsmin0;
    TEMPIMG(TEMPIMG>valsmax0) = valsmax0;
    TEMPIMG(TEMPIMG>0) = (TEMPIMG(TEMPIMG>0)-valsmin0)/(valsmax0-valsmin0);
    image(TEMPIMG,'parent',HSAL.Sel,'CDataMapping','scaled');
    colormap(HSAL.Sel,cmaps);
    axis(HSAL.Sel,'off');
end
axis(HSAL.Axial,'off');
axis(HSAL.Coronal,'off');
axis(HSAL.Sagittal,'off');
axis(HSAL.Sel,'off');
end
function HSAL_seltype1(varargin)
CMAPS = [0:1/127:1;0:1/127:1;0:1/127:1]';
HSAL = varargin{3};
dat = varargin{4};
dims = varargin{5};
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';
minv = round(mean(HSAL.DAT(HSAL.DAT>0)));
maxv = round(max(HSAL.DAT(HSAL.DAT>0)));

set(HSAL.Selrad(1),'value',1);
set(HSAL.Selrad(2),'value',0);
set(HSAL.Selrad(3),'value',0);
Selouts = squeeze(dat(:,:,round(dims(3)/2)));
image(Selouts,'parent',HSAL.Sel,'CDataMapping','scaled');
colormap(HSAL.Sel,CMAPS);

set(HSAL.sliceslide,'max',dims(3));
set(HSAL.sliceslide,'SliderStep',[1/dims(3),1/dims(3)]);
set(HSAL.sliceslide,'val',round(dims(3)/2));

Axialimgtemp = squeeze(dat(:,:,round(dims(3)/2)));
image(Axialimgtemp,'parent',HSAL.Axial,'CDataMapping','scaled');
colormap(HSAL.Axial,CMAPS);
Coronalimgtemp1 = squeeze(dat(:,round(dims(2)/2),:));
Coronalimgtemp = rot90(Coronalimgtemp1);
image(Coronalimgtemp,'parent',HSAL.Coronal,'CDataMapping','scaled');
colormap(HSAL.Coronal,CMAPS);
Sagittalimgtemp1 = squeeze(dat(round(dims(1)/2),:,:));
Sagittalimgtemp = rot90(Sagittalimgtemp1);
image(Sagittalimgtemp,'parent',HSAL.Sagittal,'CDataMapping','scaled');
colormap(HSAL.Sagittal,CMAPS);


set(HSAL.Xpos,'string',['左右维度（矢状位）: ',num2str(round(dims(1)/2))])
set(HSAL.Ypos,'string',['前后维度（冠状位）: ',num2str(round(dims(2)/2))])
set(HSAL.Zpos,'string',['上下维度（横断位）: ',num2str(round(dims(3)/2))])
XDIMS = round(dims(1)/2);
YDIMS = round(dims(2)/2);
ZDIMS = round(dims(3)/2);
Outs = HSAL.OUT;
mats = dir([Outs,'*.mat']);
DATScont = zeros(size(HSAL.DAT));
if ~isempty(mats)
    axismats = dir([Outs,'Axial*.mat']);
    Coronalmats = dir([Outs,'Coronal*.mat']);
    Sagittalmats = dir([Outs,'Sagittal*.mat']);
    if ~isempty(axismats)
        for i = 1:length(axismats)
            temps = load([Outs,axismats(i).name]);
            nametemp = axismats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            DATScont(:,:,slicenum) = logical(squeeze(DATScont(:,:,slicenum))+temps.SEGMENTS);
        end
    end
    if ~isempty(Coronalmats)
        for i = 1:length(Coronalmats)
            temps = load([Outs,Coronalmats(i).name]);
            nametemp = Coronalmats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            %             rot90(squeeze(DATS(:,DATYtemp,:)))
            DATScont(:,slicenum,:) = logical(squeeze(DATScont(:,slicenum,:))+rot90(temps.SEGMENTS,3));
        end
    end
    if ~isempty(Sagittalmats)
        for i = 1:length(Sagittalmats)
            temps = load([Outs,Sagittalmats(i).name]);
            nametemp = Sagittalmats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            DATScont(slicenum,:,:) = logical(squeeze(DATScont(slicenum,:,:))+rot90(temps.SEGMENTS,3));
        end
    end
end
axismask = squeeze(DATScont(:,:,ZDIMS));
coronalmask = rot90(squeeze(DATScont(:,YDIMS,:)));
sagittalmask = rot90(squeeze(DATScont(XDIMS,:,:)));
if sum(axismask(:))
    hold(HSAL.Axial,'on');
    contour(HSAL.Axial,axismask, [1 1], 'r','LineWidth',2);
    hold(HSAL.Axial,'off');
end
if sum(coronalmask(:))
    hold(HSAL.Coronal,'on');
    contour(HSAL.Coronal,coronalmask, [1 1], 'r','LineWidth',2);
    hold(HSAL.Coronal,'off');
end
if sum(sagittalmask(:))
    hold(HSAL.Sagittal,'on');
    contour(HSAL.Sagittal,sagittalmask, [1 1], 'r','LineWidth',2);
    hold(HSAL.Sagittal,'off');
end
axis(HSAL.Axial,'off');
axis(HSAL.Coronal,'off');
axis(HSAL.Sagittal,'off');
axis(HSAL.Sel,'off');
end
function HSAL_seltype2(varargin)
CMAPS = [0:1/127:1;0:1/127:1;0:1/127:1]';
HSAL = varargin{3};
dat = varargin{4};
dims = varargin{5};
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';
minv = round(mean(HSAL.DAT(HSAL.DAT>0)));
maxv = round(max(HSAL.DAT(HSAL.DAT>0)));


set(HSAL.Selrad(1),'value',0);
set(HSAL.Selrad(2),'value',1);
set(HSAL.Selrad(3),'value',0);

Selouts = rot90(squeeze(dat(round(dims(1)/2),:,:)));
image(Selouts,'parent',HSAL.Sel,'CDataMapping','scaled');
colormap(HSAL.Sel,CMAPS);

set(HSAL.sliceslide,'max',dims(1));
set(HSAL.sliceslide,'SliderStep',[1/dims(1),1/dims(1)]);
set(HSAL.sliceslide,'val',round(dims(1)/2));

Axialimgtemp = squeeze(dat(:,:,round(dims(3)/2)));
image(Axialimgtemp,'parent',HSAL.Axial,'CDataMapping','scaled');
colormap(HSAL.Axial,CMAPS);
Coronalimgtemp1 = squeeze(dat(:,round(dims(2)/2),:));
Coronalimgtemp = rot90(Coronalimgtemp1);
image(Coronalimgtemp,'parent',HSAL.Coronal,'CDataMapping','scaled');
colormap(HSAL.Coronal,CMAPS);
Sagittalimgtemp1 = squeeze(dat(round(dims(1)/2),:,:));
Sagittalimgtemp = rot90(Sagittalimgtemp1);
image(Sagittalimgtemp,'parent',HSAL.Sagittal,'CDataMapping','scaled');
colormap(HSAL.Sagittal,CMAPS);

set(HSAL.Xpos,'string',['左右维度（矢状位）: ',num2str(round(dims(1)/2))])
set(HSAL.Ypos,'string',['前后维度（冠状位）: ',num2str(round(dims(2)/2))])
set(HSAL.Zpos,'string',['上下维度（横断位）: ',num2str(round(dims(3)/2))])
XDIMS = round(dims(1)/2);
YDIMS = round(dims(2)/2);
ZDIMS = round(dims(3)/2);
Outs = HSAL.OUT;
mats = dir([Outs,'*.mat']);
DATScont = zeros(size(HSAL.DAT));
if ~isempty(mats)
    axismats = dir([Outs,'Axial*.mat']);
    Coronalmats = dir([Outs,'Coronal*.mat']);
    Sagittalmats = dir([Outs,'Sagittal*.mat']);
    if ~isempty(axismats)
        for i = 1:length(axismats)
            temps = load([Outs,axismats(i).name]);
            nametemp = axismats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            DATScont(:,:,slicenum) = logical(squeeze(DATScont(:,:,slicenum))+temps.SEGMENTS);
        end
    end
    if ~isempty(Coronalmats)
        for i = 1:length(Coronalmats)
            temps = load([Outs,Coronalmats(i).name]);
            nametemp = Coronalmats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            %             rot90(squeeze(DATS(:,DATYtemp,:)))
            DATScont(:,slicenum,:) = logical(squeeze(DATScont(:,slicenum,:))+rot90(temps.SEGMENTS,3));
        end
    end
    if ~isempty(Sagittalmats)
        for i = 1:length(Sagittalmats)
            temps = load([Outs,Sagittalmats(i).name]);
            nametemp = Sagittalmats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            DATScont(slicenum,:,:) = logical(squeeze(DATScont(slicenum,:,:))+rot90(temps.SEGMENTS,3));
        end
    end
end
axismask = squeeze(DATScont(:,:,ZDIMS));
coronalmask = rot90(squeeze(DATScont(:,YDIMS,:)));
sagittalmask = rot90(squeeze(DATScont(XDIMS,:,:)));
if sum(axismask(:))
    hold(HSAL.Axial,'on');
    contour(HSAL.Axial,axismask, [1 1], 'r','LineWidth',2);
    hold(HSAL.Axial,'off');
end
if sum(coronalmask(:))
    hold(HSAL.Coronal,'on');
    contour(HSAL.Coronal,coronalmask, [1 1], 'r','LineWidth',2);
    hold(HSAL.Coronal,'off');
end
if sum(sagittalmask(:))
    hold(HSAL.Sagittal,'on');
    contour(HSAL.Sagittal,sagittalmask, [1 1], 'r','LineWidth',2);
    hold(HSAL.Sagittal,'off');
end
axis(HSAL.Axial,'off');
axis(HSAL.Coronal,'off');
axis(HSAL.Sagittal,'off');
axis(HSAL.Sel,'off');
end
function HSAL_seltype3(varargin)
CMAPS = [0:1/127:1;0:1/127:1;0:1/127:1]';
HSAL = varargin{3};
dat = varargin{4};
dims = varargin{5};
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';
minv = round(mean(HSAL.DAT(HSAL.DAT>0)));
maxv = round(max(HSAL.DAT(HSAL.DAT>0)));

set(HSAL.Selrad(1),'value',0);
set(HSAL.Selrad(2),'value',0);
set(HSAL.Selrad(3),'value',1);
Selouts = rot90(squeeze(dat(:,round(dims(2)/2),:)));
image(Selouts,'parent',HSAL.Sel,'CDataMapping','scaled');
colormap(HSAL.Sel,CMAPS);

set(HSAL.sliceslide,'max',dims(2));
set(HSAL.sliceslide,'SliderStep',[1/dims(2),1/dims(2)]);
set(HSAL.sliceslide,'val',round(dims(2)/2));

Axialimgtemp = squeeze(dat(:,:,round(dims(3)/2)));
image(Axialimgtemp,'parent',HSAL.Axial,'CDataMapping','scaled');
colormap(HSAL.Axial,CMAPS);
Coronalimgtemp1 = squeeze(dat(:,round(dims(2)/2),:));
Coronalimgtemp = rot90(Coronalimgtemp1);
image(Coronalimgtemp,'parent',HSAL.Coronal,'CDataMapping','scaled');
colormap(HSAL.Coronal,CMAPS);
Sagittalimgtemp1 = squeeze(dat(round(dims(1)/2),:,:));
Sagittalimgtemp = rot90(Sagittalimgtemp1);
image(Sagittalimgtemp,'parent',HSAL.Sagittal,'CDataMapping','scaled');
colormap(HSAL.Sagittal,CMAPS);

set(HSAL.Xpos,'string',['左右维度（矢状位）: ',num2str(round(dims(1)/2))])
set(HSAL.Ypos,'string',['前后维度（冠状位）: ',num2str(round(dims(2)/2))])
set(HSAL.Zpos,'string',['上下维度（横断位）: ',num2str(round(dims(3)/2))])
XDIMS = round(dims(1)/2);
YDIMS = round(dims(2)/2);
ZDIMS = round(dims(3)/2);
Outs = HSAL.OUT;
mats = dir([Outs,'*.mat']);
DATScont = zeros(size(HSAL.DAT));
if ~isempty(mats)
    axismats = dir([Outs,'Axial*.mat']);
    Coronalmats = dir([Outs,'Coronal*.mat']);
    Sagittalmats = dir([Outs,'Sagittal*.mat']);
    if ~isempty(axismats)
        for i = 1:length(axismats)
            temps = load([Outs,axismats(i).name]);
            nametemp = axismats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            DATScont(:,:,slicenum) = logical(squeeze(DATScont(:,:,slicenum))+temps.SEGMENTS);
        end
    end
    if ~isempty(Coronalmats)
        for i = 1:length(Coronalmats)
            temps = load([Outs,Coronalmats(i).name]);
            nametemp = Coronalmats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            %             rot90(squeeze(DATS(:,DATYtemp,:)))
            DATScont(:,slicenum,:) = logical(squeeze(DATScont(:,slicenum,:))+rot90(temps.SEGMENTS,3));
        end
    end
    if ~isempty(Sagittalmats)
        for i = 1:length(Sagittalmats)
            temps = load([Outs,Sagittalmats(i).name]);
            nametemp = Sagittalmats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            DATScont(slicenum,:,:) = logical(squeeze(DATScont(slicenum,:,:))+rot90(temps.SEGMENTS,3));
        end
    end
end
axismask = squeeze(DATScont(:,:,ZDIMS));
coronalmask = rot90(squeeze(DATScont(:,YDIMS,:)));
sagittalmask = rot90(squeeze(DATScont(XDIMS,:,:)));
if sum(axismask(:))
    hold(HSAL.Axial,'on');
    contour(HSAL.Axial,axismask, [1 1], 'r','LineWidth',2);
    hold(HSAL.Axial,'off');
end
if sum(coronalmask(:))
    hold(HSAL.Coronal,'on');
    contour(HSAL.Coronal,coronalmask, [1 1], 'r','LineWidth',2);
    hold(HSAL.Coronal,'off');
end
if sum(sagittalmask(:))
    hold(HSAL.Sagittal,'on');
    contour(HSAL.Sagittal,sagittalmask, [1 1], 'r','LineWidth',2);
    hold(HSAL.Sagittal,'off');
end
axis(HSAL.Axial,'off');
axis(HSAL.Coronal,'off');
axis(HSAL.Sagittal,'off');
axis(HSAL.Sel,'off');
end
function HSAL_SLIDE(varargin)
HSAL = varargin{3};
dat = varargin{4};
dims = varargin{5};
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';
minv = round(min(HSAL.DAT(HSAL.DAT>0)));
maxv = round(max(HSAL.DAT(HSAL.DAT>0)));
% set(HSAL.Graysel_slideMin,'val',get(HSAL.Graysel_slideMin,'min'))
% set(HSAL.Graysel_slideMax,'val',get(HSAL.Graysel_slideMax,'max'))
valsels = get(HSAL.Selrad,'val');
valslid = get(HSAL.sliceslide,'val');

valsmax0 = get(HSAL.Graysel_slideMax,'val');
valsmin0 = get(HSAL.Graysel_slideMin,'val');
%
Outs = HSAL.OUT;
mats = dir([Outs,'*.mat']);
DATScont = zeros(size(HSAL.DAT));
if ~isempty(mats)
    axismats = dir([Outs,'Axial*.mat']);
    Coronalmats = dir([Outs,'Coronal*.mat']);
    Sagittalmats = dir([Outs,'Sagittal*.mat']);
    if ~isempty(axismats)
        for i = 1:length(axismats)
            temps = load([Outs,axismats(i).name]);
            nametemp = axismats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            DATScont(:,:,slicenum) = logical(squeeze(DATScont(:,:,slicenum))+temps.SEGMENTS);
        end
    end
    if ~isempty(Coronalmats)
        for i = 1:length(Coronalmats)
            temps = load([Outs,Coronalmats(i).name]);
            nametemp = Coronalmats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            %             rot90(squeeze(DATS(:,DATYtemp,:)))
            DATScont(:,slicenum,:) = logical(squeeze(DATScont(:,slicenum,:))+rot90(temps.SEGMENTS,3));
        end
    end
    if ~isempty(Sagittalmats)
        for i = 1:length(Sagittalmats)
            temps = load([Outs,Sagittalmats(i).name]);
            nametemp = Sagittalmats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            DATScont(slicenum,:,:) = logical(squeeze(DATScont(slicenum,:,:))+rot90(temps.SEGMENTS,3));
        end
    end
end
%

DATX= get(HSAL.Xpos,'string');
tempsx = find(DATX==':');
DATXtemp = str2num(DATX(tempsx+2:end));
DATY= get(HSAL.Ypos,'string');
tempsy = find(DATY==':');
DATYtemp = str2num(DATY(tempsy+2:end));
DATZ= get(HSAL.Zpos,'string');
tempsz = find(DATZ==':');
DATZtemp = str2num(DATZ(tempsz+2:end));
XDIMS = DATXtemp;
YDIMS = DATYtemp;
ZDIMS = DATZtemp;

if valsels{1}  %% val 1:dims(3)
    ZDIMS = round(valslid);
    XDIMS = round(dims(1)/2);
    YDIMS = round(dims(2)/2);
    set(HSAL.Xpos,'string',['左右维度（矢状位）: ',num2str(XDIMS)])
    set(HSAL.Ypos,'string',['前后维度（冠状位）: ',num2str(YDIMS)])
    set(HSAL.Zpos,'string',['上下维度（横断位）: ',num2str(ZDIMS)])
    set(HSAL.Val,'string',['当前: ',num2str(HSAL.DAT(XDIMS,YDIMS,ZDIMS))]);
    axialimgtemp = squeeze(dat(:,:,round(valslid)));
    axialimgtemp(1,1) = 0;
    axialimgtemp(end,end) = maxv;
    axialimgtemp0 = axialimgtemp;
    axialimgtemp0(axialimgtemp0<valsmin0) = valsmin0;
    axialimgtemp0(axialimgtemp0>valsmax0) = valsmax0;
    axialimgtemp0(axialimgtemp0>0) = (axialimgtemp0(axialimgtemp0>0)-valsmin0)/(valsmax0-valsmin0);
    image(axialimgtemp0,'parent',HSAL.Sel,'CDataMapping','scaled');
    colormap(HSAL.Sel,cmaps);
    image(axialimgtemp,'parent',HSAL.Axial,'CDataMapping','scaled');
    colormap(HSAL.Axial,cmaps);
    TEMPIMG = rot90(squeeze(dat(round(dims(1)/2),:,:)));
    TEMPIMG(1,1) = 0;
    TEMPIMG(end,end) = maxv;
    image(TEMPIMG,'parent',HSAL.Sagittal,'CDataMapping','scaled');
    colormap(HSAL.Sagittal,cmaps);
    %     axis(HSAL.Sagittal,'off');
    TEMPIMG = rot90(squeeze(dat(:,round(dims(2)/2),:)));
    TEMPIMG(1,1) = 0;
    TEMPIMG(end,end) = maxv;
    image(TEMPIMG,'parent',HSAL.Coronal,'CDataMapping','scaled');
    colormap(HSAL.Coronal,cmaps);
    %     axis(HSAL.Coronal,'off');
    hold(HSAL.Axial,'on');
    plot(HSAL.Axial,[0,dims(2)],[round(dims(1)/2),round(dims(1)/2)]);
    plot(HSAL.Axial,[round(dims(2)/2),round(dims(2)/2)],[0,dims(1)]);
    hold(HSAL.Axial,'off');
    hold(HSAL.Sagittal,'on');
    plot(HSAL.Sagittal,[0,dims(2)],[dims(3)+1-round(valslid),dims(3)+1-round(valslid)])
    plot(HSAL.Sagittal,[round(dims(2)/2),round(dims(2)/2)],[0,dims(3)]);
    hold(HSAL.Sagittal,'off');
    hold(HSAL.Coronal,'on');
    plot(HSAL.Coronal,[0,dims(1)],[dims(3)+1-round(valslid),dims(3)+1-round(valslid)])
    plot(HSAL.Coronal,[round(dims(1)/2),round(dims(1)/2)],[0,dims(3)]);
    hold(HSAL.Coronal,'off');
    
elseif valsels{2}
    XDIMS = round(valslid);
    ZDIMS = round(dims(3)/2);
    YDIMS = round(dims(2)/2);
    set(HSAL.Xpos,'string',['左右维度（矢状位）: ',num2str(XDIMS)])
    set(HSAL.Ypos,'string',['前后维度（冠状位）: ',num2str(YDIMS)])
    set(HSAL.Zpos,'string',['上下维度（横断位）: ',num2str(ZDIMS)])
    set(HSAL.Val,'string',['当前: ',num2str(HSAL.DAT(XDIMS,YDIMS,ZDIMS))]);
    Sagittalimgtemp = rot90(squeeze(dat(round(valslid),:,:)));
    Sagittalimgtemp(1,1) = 0;
    Sagittalimgtemp(end,end) = maxv;
    
    Sagittalimgtemp0 = Sagittalimgtemp;
    Sagittalimgtemp0(Sagittalimgtemp0<valsmin0) = valsmin0;
    Sagittalimgtemp0(Sagittalimgtemp0>valsmax0) = valsmax0;
    Sagittalimgtemp0(Sagittalimgtemp0>0) = (Sagittalimgtemp0(Sagittalimgtemp0>0)-valsmin0)/(valsmax0-valsmin0);
    image(Sagittalimgtemp0,'parent',HSAL.Sel,'CDataMapping','scaled');
    colormap(HSAL.Sel,cmaps);
    %     axis(HSAL.Sel,'off');
    TEMPIMG = squeeze(dat(:,:,round(dims(3)/2)));
    TEMPIMG(1,1) = 0;
    TEMPIMG(end,end) = maxv;
    image(TEMPIMG,'parent',HSAL.Axial,'CDataMapping','scaled');
    colormap(HSAL.Axial,cmaps);
    %     axis(HSAL.Axial,'off');
    image(Sagittalimgtemp,'parent',HSAL.Sagittal,'CDataMapping','scaled');
    colormap(HSAL.Sagittal,cmaps);
    %     axis(HSAL.Sagittal,'off');
    TEMPIMG = rot90(squeeze(dat(:,round(dims(2)/2),:)));
    TEMPIMG(1,1) = 0;
    TEMPIMG(end,end) = maxv;
    image(TEMPIMG,'parent',HSAL.Coronal,'CDataMapping','scaled');
    colormap(HSAL.Coronal,cmaps);
    %     axis(HSAL.Coronal,'off');
    
    hold(HSAL.Sagittal,'on');
    plot(HSAL.Sagittal,[0,dims(2)],[round(dims(3)/2),round(dims(3)/2)])
    plot(HSAL.Sagittal,[round(dims(2)/2),round(dims(2)/2)],[0,dims(3)]);
    hold(HSAL.Sagittal,'off');
    
    hold(HSAL.Axial,'on');
    plot(HSAL.Axial,[0,dims(2)],[round(valslid),round(valslid)]);
    plot(HSAL.Axial,[round(dims(2)/2),round(dims(2)/2)],[0,dims(1)]);
    hold(HSAL.Axial,'off');
    
    hold(HSAL.Coronal,'on');
    plot(HSAL.Coronal,[0,dims(1)],[round(dims(3)/2),round(dims(3)/2)])
    plot(HSAL.Coronal,[round(valslid),round(valslid)],[0,dims(3)]);
    hold(HSAL.Coronal,'off');
else
    
    YDIMS = round(valslid);
    ZDIMS = round(dims(3)/2);
    XDIMS = round(dims(1)/2);
    set(HSAL.Xpos,'string',['左右维度（矢状位）: ',num2str(XDIMS)])
    set(HSAL.Ypos,'string',['前后维度（冠状位）: ',num2str(YDIMS)])
    set(HSAL.Zpos,'string',['上下维度（横断位）: ',num2str(ZDIMS)])
    set(HSAL.Val,'string',['当前: ',num2str(HSAL.DAT(XDIMS,YDIMS,ZDIMS))]);
    TEMPIMG = rot90(squeeze(dat(:,round(valslid),:)));
    TEMPIMG(1,1) = 0;
    TEMPIMG(end,end) = maxv;
    
    TEMPIMG0 = TEMPIMG;
    TEMPIMG0(TEMPIMG0<valsmin0) = valsmin0;
    TEMPIMG0(TEMPIMG0>valsmax0) = valsmax0;
    TEMPIMG0(TEMPIMG0>0) = (TEMPIMG0(TEMPIMG0>0)-valsmin0)/(valsmax0-valsmin0);
    image(TEMPIMG0,'parent',HSAL.Sel,'CDataMapping','scaled');
    colormap(HSAL.Sel,cmaps);
    %     axis(HSAL.Sel,'off');
    TEMPIMG = squeeze(dat(:,:,round(dims(3)/2)));
    TEMPIMG(1,1) = 0;
    TEMPIMG(end,end) = maxv;
    image(TEMPIMG,'parent',HSAL.Axial,'CDataMapping','scaled');
    colormap(HSAL.Axial,cmaps);
    %     axis(HSAL.Axial,'off');
    TEMPIMG = rot90(squeeze(dat(round(dims(1)/2),:,:)));
    TEMPIMG(1,1) = 0;
    TEMPIMG(end,end) = maxv;
    image(TEMPIMG,'parent',HSAL.Sagittal,'CDataMapping','scaled');
    colormap(HSAL.Sagittal,cmaps);
    %     axis(HSAL.Sagittal,'off');
    TEMPIMG = rot90(squeeze(dat(:,round(valslid),:)));
    TEMPIMG(1,1) = 0;
    TEMPIMG(end,end) = maxv;
    image(TEMPIMG,'parent',HSAL.Coronal,'CDataMapping','scaled');
    colormap(HSAL.Coronal,cmaps);
    %     axis(HSAL.Coronal,'off');
    
    hold(HSAL.Coronal,'on');
    plot(HSAL.Coronal,[0,dims(1)],[round(dims(3)/2),round(dims(3)/2)])
    plot(HSAL.Coronal,[round(dims(1)/2),round(dims(1)/2)],[0,dims(3)]);
    hold(HSAL.Coronal,'off');
    
    hold(HSAL.Sagittal,'on');
    plot(HSAL.Sagittal,[0,dims(2)],[round(dims(3)/2),round(dims(3)/2)])
    plot(HSAL.Sagittal,[round(valslid),round(valslid)],[0,dims(3)]);
    hold(HSAL.Sagittal,'off');
    
    hold(HSAL.Axial,'on');
    plot(HSAL.Axial,[0,dims(2)],[round(dims(1)/2),round(dims(1)/2)]);
    plot(HSAL.Axial,[round(valslid),round(valslid)],[0,dims(1)]);
    hold(HSAL.Axial,'off');
end
axismask = squeeze(DATScont(:,:,ZDIMS));
coronalmask = rot90(squeeze(DATScont(:,YDIMS,:)));
sagittalmask = rot90(squeeze(DATScont(XDIMS,:,:)));
if sum(axismask(:))
    hold(HSAL.Axial,'on');
    contour(HSAL.Axial,axismask, [1 1], 'r','LineWidth',2);
    hold(HSAL.Axial,'off');
end
if sum(coronalmask(:))
    hold(HSAL.Coronal,'on');
    contour(HSAL.Coronal,coronalmask, [1 1], 'r','LineWidth',2);
    hold(HSAL.Coronal,'off');
end
if sum(sagittalmask(:))
    hold(HSAL.Sagittal,'on');
    contour(HSAL.Sagittal,sagittalmask, [1 1], 'r','LineWidth',2);
    hold(HSAL.Sagittal,'off');
end
DATORIG = HSAL.DAT;

if valsels{1}
    %     dimused = ZDIMS;
    datmask = squeeze(DATScont(:,:,ZDIMS));
    DATSHOWRES = squeeze(DATORIG(:,:,ZDIMS));
    INDS = find(datmask);
    Showinfo = ['Axial: ',num2str(ZDIMS)];
    set(HSAL.RelatedInfo_text2,'string',{['区域体素数目: ',num2str(nnz(datmask))],...
        Showinfo,['最大值: ',num2str(max(DATSHOWRES(INDS)))],...
        ['最小值: ',num2str(min(DATSHOWRES(INDS)))],...
        ['平均值: ',num2str(mean(DATSHOWRES(INDS)))]})
elseif valsels{2}
    datmask = squeeze(DATScont(XDIMS,:,:));
    DATSHOWRES = squeeze(DATORIG(XDIMS,:,:));
    INDS = find(datmask);
    Showinfo = ['Sagittal: ',num2str(XDIMS)];
    set(HSAL.RelatedInfo_text2,'string',{['区域体素数目: ',num2str(nnz(datmask))],...
        Showinfo,['最大值: ',num2str(max(DATSHOWRES(INDS)))],...
        ['最小值: ',num2str(min(DATSHOWRES(INDS)))],...
        ['平均值: ',num2str(mean(DATSHOWRES(INDS)))]})
else
    datmask = squeeze(DATScont(:,YDIMS,:));
    DATSHOWRES = squeeze(DATORIG(:,YDIMS,:));
    INDS = find(datmask);
    Showinfo = ['Coronal: ',num2str(YDIMS)];
    set(HSAL.RelatedInfo_text2,'string',{['区域体素数目: ',num2str(nnz(datmask))],...
        Showinfo,['最大值: ',num2str(max(DATSHOWRES(INDS)))],...
        ['最小值: ',num2str(min(DATSHOWRES(INDS)))],...
        ['平均值: ',num2str(mean(DATSHOWRES(INDS)))]})
end
axis(HSAL.Axial,'off');
axis(HSAL.Coronal,'off');
axis(HSAL.Sagittal,'off');
axis(HSAL.Sel,'off');
end
function HSAL_Pickpoint2(varargin)
%% actually, this is the subfunction of region selection.
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';
HSAL = varargin{3};
dat = varargin{4};
dims = varargin{5};
DATX= get(HSAL.Xpos,'string');
tempsx = find(DATX==':');
DATXtemp = str2num(DATX(tempsx+2:end));
DATY= get(HSAL.Ypos,'string');
tempsy = find(DATY==':');
DATYtemp = str2num(DATY(tempsy+2:end));
DATZ= get(HSAL.Zpos,'string');
tempsz = find(DATZ==':');
DATZtemp = str2num(DATZ(tempsz+2:end));
valsels = get(HSAL.Selrad,'val');
DATS = HSAL.DAT;
valsmin0 = get(HSAL.Graysel_slideMin,'val');
valsmax0 = get(HSAL.Graysel_slideMax,'val');
if valsels{1}
    DATTEMP = squeeze(DATS(:,:,DATZtemp));
    Showinfo = ['Axial: ',num2str(DATZtemp)];
    DAT0 = squeeze(DATS(:,:,DATZtemp));
elseif valsels{2}
    DATTEMP = rot90(squeeze(DATS(DATXtemp,:,:)));
    Showinfo = ['Sagittal: ',num2str(DATXtemp)];
    DAT0 = rot90(squeeze(DATS(DATXtemp,:,:)));
else
    DATTEMP = rot90(squeeze(DATS(:,DATYtemp,:)));
    Showinfo = ['Cornoral: ',num2str(DATYtemp)];
    DAT0 = rot90(squeeze(DATS(:,DATYtemp,:)));
end
DATTEMP(DATTEMP<valsmin0) = valsmin0;
DATTEMP(DATTEMP>valsmax0) = valsmax0;
DATTEMP(DATTEMP>0) = (DATTEMP(DATTEMP>0)-valsmin0)*(valsmax0-valsmin0);
% hold(HSAL.Sel,'on');
image(DATTEMP,'parent',HSAL.Sel,'CDataMapping','scaled');
colormap(HSAL.Sel,cmaps);
X = DATTEMP;
rects = getrect(HSAL.Sel);
hold(HSAL.Sel,'on');
plot([rects(1),rects(1)+rects(3)],[rects(2),rects(2)],'r--');
plot([rects(1),rects(1)+rects(3)],[rects(2)+rects(4),rects(2)+rects(4)],'r--');
plot([rects(1),rects(1)],[rects(2),rects(2)+rects(4)],'r--');
plot([rects(1)+rects(3),rects(1)+rects(3)],[rects(2),rects(2)+rects(4)],'r--');
hold(HSAL.Sel,'off');
X(X>0) = X(X>0)/max(X(X>0))*255;
masks = zeros(size(X));
masks(round([rects(2):rects(2)+rects(4)]),round([rects(1):rects(1)+rects(3)])) = 1;
% seg = region_seg(img,msk,250,0.2,0);
valiter = str2num(get(HSAL.SNAKE_p1_edit,'string'));
valalpha = str2num(get(HSAL.SNAKE_p2_edit,'string'));
if valiter<=0
    errordlg('错误的迭代次数');
    return;
end
if valalpha>1||valalpha<0
    errordlg('错误的平滑参数(0<alpha<1)');
    return;
end
[seg phi]= region_seg2(X,masks,valiter,valalpha,0);
hold(HSAL.Sel,'on');
contour(HSAL.Sel,phi, [0 0], 'g','LineWidth',4);
contour(HSAL.Sel,phi, [0 0], 'k','LineWidth',2);
hold(HSAL.Sel,'off');

MASKS = masks;
ITERNUMS = valiter;
ALPHA = valalpha;
PHI = phi;
SEGMENTS = seg;
INDS = find(SEGMENTS);
set(HSAL.RelatedInfo_text,'string',{['区域体素数目: ',num2str(nnz(SEGMENTS))],...
    Showinfo,['最大值: ',num2str(max(DAT0(INDS)))],...
    ['最小值: ',num2str(min(DAT0(INDS)))],...
    ['平均值: ',num2str(mean(DAT0(INDS)))]})
save('temp')
axis(HSAL.Axial,'off');
axis(HSAL.Coronal,'off');
axis(HSAL.Sagittal,'off');
axis(HSAL.Sel,'off');
end
function HSAL_Pickpoint2_Whole(varargin)
%% actually, this is the subfunction of region selection.
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';
HSAL = varargin{3};
dat = varargin{4};
dims = varargin{5};
DATX= get(HSAL.Xpos,'string');
tempsx = find(DATX==':');
DATXtemp = str2num(DATX(tempsx+2:end));
DATY= get(HSAL.Ypos,'string');
tempsy = find(DATY==':');
DATYtemp = str2num(DATY(tempsy+2:end));
DATZ= get(HSAL.Zpos,'string');
tempsz = find(DATZ==':');
DATZtemp = str2num(DATZ(tempsz+2:end));
valsels = get(HSAL.Selrad,'val');
DATS = HSAL.DAT;
valsmin0 = get(HSAL.Graysel_slideMin,'val');
valsmax0 = get(HSAL.Graysel_slideMax,'val');
if valsels{1}
    answers = questdlg('选定范围','选定范围（Yes）还是全脑（No）','Yes','No','Yes');
    SETRAGE = answers;
    if strcmp(SETRAGE,'Yes')
        answers = inputdlg({['最小层, 大于 0, 当前: ',num2str(DATZtemp)],...
            ['最大层, 小于 ',num2str(dims(3)),', 当前: ',num2str(DATZtemp)]},...
            '层数范围',1,{'1',num2str(dims(3))});
        RANGE = round([str2num(answers{1}),str2num(answers{2})]);
        if RANGE(1)>=RANGE(2)
            error('错误的输入：最小层应该小于最大层');
        end
        if RANGE(1)<1
            error('最小层应该大于 0');
        end
        if RANGE(2)>dims(3)
            error(['最大层应该小于最大维度 (',num2str(dims(3)),')']);
        end
    else
        RANGE = [1,dims(3)];
    end
    DATTEMP = squeeze(DATS(:,:,DATZtemp));
    Showinfo = ['Axial: ',num2str(DATZtemp)];
    DAT0 = squeeze(DATS(:,:,DATZtemp));
    DATtemp = DATZtemp;
elseif valsels{2}
    answers = questdlg('选定范围','选定范围（Yes）还是全脑（No）','Yes','No','Yes');
    SETRAGE = answers;
    if strcmp(SETRAGE,'Yes')
        answers = inputdlg({['最小层, 大于 0, 当前: ',num2str(DATXtemp)],...
            ['最大层, 小于 ',num2str(dims(1)),', 当前: ',num2str(DATXtemp)]},...
            '层数范围',1,{'1',num2str(dims(1))});
        RANGE = round([str2num(answers{1}),str2num(answers{2})]);
        if RANGE(1)>=RANGE(2)
            error('错误的输入：最小层应该小于最大层');
        end
        if RANGE(1)<1
            error('最小层应该大于 0');
        end
        if RANGE(2)>dims(1)
            error(['最大层应该小于最大维度(',num2str(dims(1)),')']);
        end
    else
        RANGE = [1,dims(1)];
    end
    DATTEMP = rot90(squeeze(DATS(DATXtemp,:,:)));
    Showinfo = ['Sagittal: ',num2str(DATXtemp)];
    DAT0 = rot90(squeeze(DATS(DATXtemp,:,:)));
    DATtemp = DATXtemp;
else
    answers = questdlg('选定范围','选定范围（Yes）还是全脑（No）','Yes','No','Yes');
    SETRAGE = answers;
    if strcmp(SETRAGE,'Yes')
        answers = inputdlg({['最小层, 大于 0, 当前: ',num2str(DATYtemp)],...
            ['最大层, 小于 ',num2str(dims(2)),', 当前: ',num2str(DATYtemp)]},...
            '层数范围',1,{'1',num2str(dims(2))});
        RANGE = round([str2num(answers{1}),str2num(answers{2})]);
        if RANGE(1)>=RANGE(2)
            error('错误的输入：最小层应该小于最大层');
        end
        if RANGE(1)<1
            error('最小层应该大于 0');
        end
        if RANGE(2)>dims(2)
            error(['最大层应该小于最大维度(',num2str(dims(2)),')']);
        end
    else
        RANGE = [1,dims(2)];
    end
    DATTEMP = rot90(squeeze(DATS(:,DATYtemp,:)));
    Showinfo = ['Cornoral: ',num2str(DATYtemp)];
    DAT0 = rot90(squeeze(DATS(:,DATYtemp,:)));
    DATtemp = DATYtemp;
end
DATTEMP(DATTEMP<valsmin0) = valsmin0;
DATTEMP(DATTEMP>valsmax0) = valsmax0;
DATTEMP(DATTEMP>0) = (DATTEMP(DATTEMP>0)-valsmin0)*(valsmax0-valsmin0);
% hold(HSAL.Sel,'on');
image(DATTEMP,'parent',HSAL.Sel,'CDataMapping','scaled');
colormap(HSAL.Sel,cmaps);
X = DATTEMP;
rects = getrect(HSAL.Sel);
hold(HSAL.Sel,'on');
plot([rects(1),rects(1)+rects(3)],[rects(2),rects(2)],'r--');
plot([rects(1),rects(1)+rects(3)],[rects(2)+rects(4),rects(2)+rects(4)],'r--');
plot([rects(1),rects(1)],[rects(2),rects(2)+rects(4)],'r--');
plot([rects(1)+rects(3),rects(1)+rects(3)],[rects(2),rects(2)+rects(4)],'r--');
hold(HSAL.Sel,'off');
X(X>0) = X(X>0)/max(X(X>0))*255;
masks = zeros(size(X));
masks(round([rects(2):rects(2)+rects(4)]),round([rects(1):rects(1)+rects(3)])) = 1;
% seg = region_seg(img,msk,250,0.2,0);
valiter = str2num(get(HSAL.SNAKE_p1_edit,'string'));
valalpha = str2num(get(HSAL.SNAKE_p2_edit,'string'));
if valiter<=0
    errordlg('错误的迭代次数');
    return;
end
if valalpha>1||valalpha<0
    errordlg('错误的平滑参数(0<alpha<1)');
    return;
end
[seg phi]= region_seg2(X,masks,valiter,valalpha,0);
hold(HSAL.Sel,'on');
contour(HSAL.Sel,phi, [0 0], 'g','LineWidth',4);
contour(HSAL.Sel,phi, [0 0], 'k','LineWidth',2);
hold(HSAL.Sel,'off');

MASKS = masks;
ITERNUMS = valiter;
ALPHA = valalpha;
PHI = phi;
SEGMENTS = seg;
INDS = find(SEGMENTS);
set(HSAL.RelatedInfo_text,'string',{['区域体素数目: ',num2str(nnz(SEGMENTS))],...
    Showinfo,['最大值: ',num2str(max(DAT0(INDS)))],...
    ['最小值: ',num2str(min(DAT0(INDS)))],...
    ['平均值: ',num2str(mean(DAT0(INDS)))]})
save('temp')
Outrelated(DATtemp).MASKS = MASKS;
Outrelated(DATtemp).ITERNUMS = ITERNUMS;
Outrelated(DATtemp).ALPHA = ALPHA;
Outrelated(DATtemp).PHI = PHI;
Outrelated(DATtemp).SEGMENTS = SEGMENTS;

HSAL_SLIDE('','',HSAL,dat,dims);
HSAL_PICKOK2('','',HSAL,dat,dims);
% save TEMP00
%
labs = 1;
if valsels{1}
    for i = DATZtemp-1:-1:RANGE(1)
        pause(0.005)
        masks = Outrelated(i+1).SEGMENTS;
        if nnz(masks)==0||labs==0
            break;
        end
        [Outrelated(i) labs]= turnaround(masks,HSAL,dims,dat,i);
        %         save('TEST0.mat','Outrelated')
    end
    labs = 1;
    for i = DATZtemp+1:RANGE(2)
        pause(0.005)
        masks = Outrelated(i-1).SEGMENTS;
        if nnz(masks)==0||labs==0
            break;
        end
        [Outrelated(i) labs] = turnaround(masks,HSAL,dims,dat,i);
        save('CurrentDebug')
    end
    
elseif valsels{2}
    for i = DATXtemp-1:-1:RANGE(1)
        masks = Outrelated(i+1).SEGMENTS;
        if nnz(masks)==0
            break;
        end
        Outrelated(i) = turnaround(masks,HSAL,dims,dat,i);
    end

    labs = 1;
    for i = DATXtemp+1:RANGE(2)
        masks = Outrelated(i-1).SEGMENTS;
        if nnz(masks)==0
            break;
        end
        Outrelated(i) = turnaround(masks,HSAL,dims,dat,i);
    end
else
    for i = DATYtemp-1:-1:RANGE(1)
        masks = Outrelated(i+1).SEGMENTS;
        if nnz(masks)==0
            break;
        end
        Outrelated(i) = turnaround(masks,HSAL,dims,dat,i);
    end
    labs = 1;
    for i = DATYtemp+1:RANGE(2)
        masks = Outrelated(i-1).SEGMENTS;
        if nnz(masks)==0
            break;
        end
        Outrelated(i) = turnaround(masks,HSAL,dims,dat,i);
    end
end
axis(HSAL.Axial,'off');
axis(HSAL.Coronal,'off');
axis(HSAL.Sagittal,'off');
axis(HSAL.Sel,'off');
uiwait(msgbox('Auto Segment Finished!'))
%
end
function test_mouse_track2(varargin)
HSAL = varargin{3};
dims = varargin{4};
dat = varargin{5};
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';
minv = round(mean(HSAL.DAT(HSAL.DAT>0)));
maxv = round(max(HSAL.DAT(HSAL.DAT>0)));
set(HSAL.total,'WindowButtonDownFcn',{@ButttonDownFcn,HSAL,dims,dat});
end
function ButttonDownFcn(varargin)
HSAL = varargin{3};
dims = varargin{4};
dat = varargin{5};
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';
minv = round(min(HSAL.DAT(HSAL.DAT>0)));
maxv = round(max(HSAL.DAT(HSAL.DAT>0)));
% set(HSAL.Selrad(1),'enable','off');
% set(HSAL.Selrad(2),'enable','off');
% set(HSAL.Selrad(3),'enable','off');
% set(HSAL.sliceslide,'enable','off');

%
Outs = HSAL.OUT;
mats = dir([Outs,'*.mat']);
DATScont = zeros(size(HSAL.DAT));
if ~isempty(mats)
    axismats = dir([Outs,'Axial*.mat']);
    Coronalmats = dir([Outs,'Coronal*.mat']);
    Sagittalmats = dir([Outs,'Sagittal*.mat']);
    if ~isempty(axismats)
        for i = 1:length(axismats)
            temps = load([Outs,axismats(i).name]);
            nametemp = axismats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            DATScont(:,:,slicenum) = logical(squeeze(DATScont(:,:,slicenum))+temps.SEGMENTS);
        end
    end
    if ~isempty(Coronalmats)
        for i = 1:length(Coronalmats)
            temps = load([Outs,Coronalmats(i).name]);
            nametemp = Coronalmats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            %             rot90(squeeze(DATS(:,DATYtemp,:)))
            DATScont(:,slicenum,:) = logical(squeeze(DATScont(:,slicenum,:))+rot90(temps.SEGMENTS,3));
        end
    end
    if ~isempty(Sagittalmats)
        for i = 1:length(Sagittalmats)
            temps = load([Outs,Sagittalmats(i).name]);
            nametemp = Sagittalmats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            DATScont(slicenum,:,:) = logical(squeeze(DATScont(slicenum,:,:))+rot90(temps.SEGMENTS,3));
        end
    end
end
%
pt = get(HSAL.total,'CurrentPoint');
x = pt(1,1);
y = pt(1,2);

fprintf('x=%f,y=%f\n',x,y);

cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';

valsels = get(HSAL.Selrad,'val');
valslid = get(HSAL.sliceslide,'val');
% 0.1,0.425,0.3,0.45
if x>0.1&&x<0.4&&y>0.425&&y<0.875
    PointPos = [(x-0.1)/0.3,1-(y-0.425)/0.45]
    if valsels{1}
        ZDIMS = round(valslid);
        XDIMS = round(dims(1)*PointPos(2));
        YDIMS = round(PointPos(1)*dims(2));
        set(HSAL.Xpos,'string',['左右维度（矢状位）: ',num2str(XDIMS)])
        set(HSAL.Ypos,'string',['前后维度（冠状位）: ',num2str(YDIMS)])
        set(HSAL.Zpos,'string',['上下维度（横断位）: ',num2str(ZDIMS)])
        set(HSAL.Val,'string',['当前: ',num2str(HSAL.DAT(XDIMS,YDIMS,ZDIMS))]);
        axialtemp = squeeze(dat(:,:,ZDIMS));
        axialtemp(1,1) = 0;
        axialtemp(end,end) = maxv;
        image(axialtemp,'parent',HSAL.Axial,'CDataMapping','scaled');
        colormap(HSAL.Axial,cmaps)
        sagittaltemp = rot90(squeeze(dat(XDIMS,:,:)));
        sagittaltemp(1,1) = 0;
        sagittaltemp(end,end) = maxv;
        image(sagittaltemp,'parent',HSAL.Sagittal,'CDataMapping','scaled');
        colormap(HSAL.Sagittal,cmaps)
        coronaltemp = rot90(squeeze(dat(:,YDIMS,:)));
        coronaltemp(1,1) = 0;
        coronaltemp(end,end) = maxv;
        image(coronaltemp,'parent',HSAL.Coronal,'CDataMapping','scaled');
        colormap(HSAL.Coronal,cmaps)
        
        image(axialtemp,'parent',HSAL.Sel,'CDataMapping','scaled');
        colormap(HSAL.Sel,cmaps);
        hold(HSAL.Sel,'on');
        plot(HSAL.Sel,[0,dims(2)],[XDIMS,XDIMS])
        plot(HSAL.Sel,[YDIMS,YDIMS],[0,dims(1)])
        hold(HSAL.Sel,'off')
        
        hold(HSAL.Axial,'on');
        plot(HSAL.Axial,[0,dims(2)],[XDIMS,XDIMS])
        plot(HSAL.Axial,[YDIMS,YDIMS],[0,dims(1)])
        hold(HSAL.Axial,'off')
        
        hold(HSAL.Sagittal,'on');
        plot(HSAL.Sagittal,[0,dims(2)],[dims(3)-ZDIMS,dims(3)-ZDIMS])
        plot(HSAL.Sagittal,[YDIMS,YDIMS],[0,dims(3)])
        hold(HSAL.Sagittal,'off')
        
        hold(HSAL.Coronal,'on');
        plot(HSAL.Coronal,[0,dims(1)],[dims(3)-ZDIMS,dims(3)-ZDIMS])
        plot(HSAL.Coronal,[XDIMS,XDIMS],[0,dims(3)])
        hold(HSAL.Coronal,'off')
    elseif valsels{2}
        XDIMS = round(valslid);
        YDIMS = round(PointPos(1)*dims(2));
        ZDIMS = round(dims(3)-PointPos(2)*dims(3));
        
        set(HSAL.Xpos,'string',['左右维度（矢状位）: ',num2str(XDIMS)])
        set(HSAL.Ypos,'string',['前后维度（冠状位）: ',num2str(YDIMS)])
        set(HSAL.Zpos,'string',['上下维度（横断位）: ',num2str(ZDIMS)])
        set(HSAL.Val,'string',['当前: ',num2str(HSAL.DAT(XDIMS,YDIMS,ZDIMS))]);
        axialtemp = squeeze(dat(:,:,ZDIMS));
        axialtemp(1,1) = 0;
        axialtemp(end,end) = maxv;
        image(axialtemp,'parent',HSAL.Axial,'CDataMapping','scaled');
        colormap(HSAL.Axial,cmaps)
        sagittaltemp = rot90(squeeze(dat(XDIMS,:,:)));
        sagittaltemp(1,1) = 0;
        sagittaltemp(end,end) = maxv;
        image(sagittaltemp,'parent',HSAL.Sagittal,'CDataMapping','scaled');
        colormap(HSAL.Sagittal,cmaps)
        coronaltemp = rot90(squeeze(dat(:,YDIMS,:)));
        coronaltemp(1,1) = 0;
        coronaltemp(end,end) = maxv;
        image(coronaltemp,'parent',HSAL.Coronal,'CDataMapping','scaled');
        colormap(HSAL.Coronal,cmaps)
        
        image(sagittaltemp,'parent',HSAL.Sel,'CDataMapping','scaled');
        colormap(HSAL.Sel,cmaps);
        hold(HSAL.Sel,'on');
        plot(HSAL.Sel,[0,dims(2)],[dims(3)+1-ZDIMS,dims(3)+1-ZDIMS])
        plot(HSAL.Sel,[YDIMS,YDIMS],[0,dims(3)])
        hold(HSAL.Sel,'off')
        
        
        hold(HSAL.Sagittal,'on');
        plot(HSAL.Sagittal,[0,dims(2)],[dims(3)+1-ZDIMS,dims(3)+1-ZDIMS])
        plot(HSAL.Sagittal,[YDIMS,YDIMS],[0,dims(3)])
        hold(HSAL.Sagittal,'off')
        
        hold(HSAL.Axial,'on');
        plot(HSAL.Axial,[0,dims(2)],[XDIMS,XDIMS])
        plot(HSAL.Axial,[YDIMS,YDIMS],[0,dims(1)])
        hold(HSAL.Axial,'off')
        
        hold(HSAL.Coronal,'on');
        plot(HSAL.Coronal,[0,dims(1)],[dims(3)-ZDIMS,dims(3)-ZDIMS])
        plot(HSAL.Coronal,[XDIMS,XDIMS],[0,dims(3)])
        hold(HSAL.Coronal,'off')
    else
        YDIMS = round(valslid);
        ZDIMS = round(dims(3)-PointPos(2)*dims(3));
        XDIMS = round(PointPos(1)*dims(1));
        set(HSAL.Xpos,'string',['左右维度（矢状位）: ',num2str(XDIMS)])
        set(HSAL.Ypos,'string',['前后维度（冠状位）: ',num2str(YDIMS)])
        set(HSAL.Zpos,'string',['上下维度（横断位）: ',num2str(ZDIMS)])
        set(HSAL.Val,'string',['当前: ',num2str(HSAL.DAT(XDIMS,YDIMS,ZDIMS))]);
        
        axialtemp = squeeze(dat(:,:,ZDIMS));
        axialtemp(1,1) = 0;
        axialtemp(end,end) = maxv;
        image(axialtemp,'parent',HSAL.Axial,'CDataMapping','scaled');
        colormap(HSAL.Axial,cmaps)
        sagittaltemp = rot90(squeeze(dat(XDIMS,:,:)));
        sagittaltemp(1,1) = 0;
        sagittaltemp(end,end) = maxv;
        image(sagittaltemp,'parent',HSAL.Sagittal,'CDataMapping','scaled');
        colormap(HSAL.Sagittal,cmaps)
        coronaltemp = rot90(squeeze(dat(:,YDIMS,:)));
        coronaltemp(1,1) = 0;
        coronaltemp(end,end) = maxv;
        image(coronaltemp,'parent',HSAL.Coronal,'CDataMapping','scaled');
        colormap(HSAL.Coronal,cmaps)
        
        image(coronaltemp,'parent',HSAL.Sel,'CDataMapping','scaled');
        colormap(HSAL.Sel,cmaps);
        hold(HSAL.Sel,'on');
        plot(HSAL.Sel,[0,dims(1)],[dims(3)+1-ZDIMS,dims(3)+1-ZDIMS])
        plot(HSAL.Sel,[XDIMS,XDIMS],[0,dims(3)])
        hold(HSAL.Sel,'off')
        
        
        hold(HSAL.Sagittal,'on');
        plot(HSAL.Sagittal,[0,dims(2)],[dims(3)+1-ZDIMS,dims(3)+1-ZDIMS])
        plot(HSAL.Sagittal,[YDIMS,YDIMS],[0,dims(3)])
        hold(HSAL.Sagittal,'off')
        
        hold(HSAL.Axial,'on');
        plot(HSAL.Axial,[0,dims(2)],[XDIMS,XDIMS])
        plot(HSAL.Axial,[YDIMS,YDIMS],[0,dims(1)])
        hold(HSAL.Axial,'off')
        
        hold(HSAL.Coronal,'on');
        plot(HSAL.Coronal,[0,dims(1)],[dims(3)-ZDIMS,dims(3)-ZDIMS])
        plot(HSAL.Coronal,[XDIMS,XDIMS],[0,dims(3)])
        hold(HSAL.Coronal,'off')
    end
    axismask = squeeze(DATScont(:,:,ZDIMS));
    coronalmask = rot90(squeeze(DATScont(:,YDIMS,:)));
    sagittalmask = rot90(squeeze(DATScont(XDIMS,:,:)));
    if sum(axismask(:))
        hold(HSAL.Axial,'on');
        contour(HSAL.Axial,axismask, [1 1], 'r','LineWidth',2);
        hold(HSAL.Axial,'off');
    end
    if sum(coronalmask(:))
        hold(HSAL.Coronal,'on');
        contour(HSAL.Coronal,coronalmask, [1 1], 'r','LineWidth',2);
        hold(HSAL.Coronal,'off');
    end
    if sum(sagittalmask(:))
        hold(HSAL.Sagittal,'on');
        contour(HSAL.Sagittal,sagittalmask, [1 1], 'r','LineWidth',2);
        hold(HSAL.Sagittal,'off');
    end
    DATORIG = HSAL.DAT;
    if valsels{1}
        %     dimused = ZDIMS;
        datmask = squeeze(DATScont(:,:,ZDIMS));
        DATSHOWRES = squeeze(DATORIG(:,:,ZDIMS));
        INDS = find(datmask);
        Showinfo = ['Axial: ',num2str(ZDIMS)];
        set(HSAL.RelatedInfo_text2,'string',{['区域体素数目: ',num2str(nnz(datmask))],...
            Showinfo,['最大值: ',num2str(max(DATSHOWRES(INDS)))],...
            ['最小值: ',num2str(min(DATSHOWRES(INDS)))],...
            ['平均值: ',num2str(mean(DATSHOWRES(INDS)))]})
    elseif valsels{2}
        datmask = squeeze(DATScont(XDIMS,:,:));
        DATSHOWRES = squeeze(DATORIG(XDIMS,:,:));
        INDS = find(datmask);
        Showinfo = ['Sagittal: ',num2str(XDIMS)];
        set(HSAL.RelatedInfo_text2,'string',{['区域体素数目: ',num2str(nnz(datmask))],...
            Showinfo,['最大值: ',num2str(max(DATSHOWRES(INDS)))],...
            ['最小值: ',num2str(min(DATSHOWRES(INDS)))],...
            ['平均值: ',num2str(mean(DATSHOWRES(INDS)))]})
    else
        datmask = squeeze(DATScont(:,YDIMS,:));
        DATSHOWRES = squeeze(DATORIG(:,YDIMS,:));
        INDS = find(datmask);
        Showinfo = ['Coronal: ',num2str(YDIMS)];
        set(HSAL.RelatedInfo_text2,'string',{['区域体素数目: ',num2str(nnz(datmask))],...
            Showinfo,['最大值: ',num2str(max(DATSHOWRES(INDS)))],...
            ['最小值: ',num2str(min(DATSHOWRES(INDS)))],...
            ['平均值: ',num2str(mean(DATSHOWRES(INDS)))]})
    end
else
    test_mouse_track2([],[],HSAL,dims,dat);
end
axis(HSAL.Axial,'off');
axis(HSAL.Coronal,'off');
axis(HSAL.Sagittal,'off');
axis(HSAL.Sel,'off');
end
function HSAL_FINISH(varargin)
HSAL = varargin{3};
dat = varargin{4};
dims = varargin{5};
Outs = HSAL.OUT;
mats = dir([Outs,'*.mat']);
DATScont = zeros(size(HSAL.DAT));
if ~isempty(mats)
    axismats = dir([Outs,'Axial*.mat']);
    Coronalmats = dir([Outs,'Coronal*.mat']);
    Sagittalmats = dir([Outs,'Sagittal*.mat']);
    if ~isempty(axismats)
        for i = 1:length(axismats)
            temps = load([Outs,axismats(i).name]);
            nametemp = axismats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            DATScont(:,:,slicenum) = logical(squeeze(DATScont(:,:,slicenum))+temps.SEGMENTS);
        end
    end
    if ~isempty(Coronalmats)
        for i = 1:length(Coronalmats)
            temps = load([Outs,Coronalmats(i).name]);
            nametemp = Coronalmats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            %             rot90(squeeze(DATS(:,DATYtemp,:)))
            DATScont(:,slicenum,:) = logical(squeeze(DATScont(:,slicenum,:))+rot90(temps.SEGMENTS,3));
        end
    end
    if ~isempty(Sagittalmats)
        for i = 1:length(Sagittalmats)
            temps = load([Outs,Sagittalmats(i).name]);
            nametemp = Sagittalmats(i).name;
            namecomps = nametemp(end-6:end-4);
            ind_ = find(nametemp=='_');
            if strcmpi(namecomps,'add')
                slicenum = str2num(nametemp(ind_(1)+1:ind_(2)-1));
            else
                slicenum = str2num(nametemp(ind_(1)+1:end-4));
            end
            DATScont(slicenum,:,:) = logical(squeeze(DATScont(slicenum,:,:))+rot90(temps.SEGMENTS,3));
        end
    end
end
HDRS = HSAL.HDR;
almat = HDRS.mat(1:3,1:3);
vsize = [abs(max(almat(1,:))),abs(max(almat(2,:))),abs(max(almat(3,:)))];
rest_writefile(DATScont,[Outs,'LesionMask.nii'],dims,vsize,HSAL.HDR,'uint8');
uiwait(msgbox('成功保存ROI!'))
end
function HSAL_EXIT(varargin)
HSAL = varargin{3};
close(HSAL.total);
HSIDR_cn;
end

function [Outrelated labs]= turnaround(masks,HSAL,dims,dat,DATtemp)
labs = 1;
if nnz(masks)==0
    return;
end
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';
valsels = get(HSAL.Selrad,'val');
DATS = HSAL.DAT;
valsmin0 = get(HSAL.Graysel_slideMin,'val');
valsmax0 = get(HSAL.Graysel_slideMax,'val');
if valsels{1}
    DATTEMP = squeeze(DATS(:,:,DATtemp));
    Showinfo = ['Axial: ',num2str(DATtemp)];
    DAT0 = squeeze(DATS(:,:,DATtemp));
    DATZtemp = DATtemp;
elseif valsels{2}
    DATTEMP = rot90(squeeze(DATS(DATtemp,:,:)));
    Showinfo = ['Sagittal: ',num2str(DATtemp)];
    DAT0 = rot90(squeeze(DATS(DATtemp,:,:)));
    DATXtemp = DATtemp;
else
    DATTEMP = rot90(squeeze(DATS(:,DATtemp,:)));
    Showinfo = ['Cornoral: ',num2str(DATtemp)];
    DAT0 = rot90(squeeze(DATS(:,DATtemp,:)));
    DATYtemp = DATtemp;
end
DATTEMP(DATTEMP<valsmin0) = valsmin0;
DATTEMP(DATTEMP>valsmax0) = valsmax0;
DATTEMP(DATTEMP>0) = (DATTEMP(DATTEMP>0)-valsmin0)*(valsmax0-valsmin0);
% hold(HSAL.Sel,'on');
image(DATTEMP,'parent',HSAL.Sel,'CDataMapping','scaled');
colormap(HSAL.Sel,cmaps);
X = DATTEMP;
X(X>0) = X(X>0)/max(X(X>0))*255;
% seg = region_seg(img,msk,250,0.2,0);
valiter = str2num(get(HSAL.SNAKE_p1_edit,'string'));
valalpha = str2num(get(HSAL.SNAKE_p2_edit,'string'));
if valiter<=0
    errordlg('错误的迭代次数');
    return;
end
if valalpha>1||valalpha<0
    errordlg('错误的平缓参数(0<alpha<1)');
    return;
end
try
    [seg phi]= region_seg2(X,masks,valiter,valalpha,0);
catch
    labs = 0;
    Outrelated.MASKS = 0;
    Outrelated.ITERNUMS = 0;
    Outrelated.ALPHA = 0;
    Outrelated.PHI = 0;
    Outrelated.SEGMENTS = 0;
    return
end
hold(HSAL.Sel,'on');
contour(HSAL.Sel,phi, [0 0], 'g','LineWidth',4);
contour(HSAL.Sel,phi, [0 0], 'k','LineWidth',2);
hold(HSAL.Sel,'off');

MASKS = masks;
ITERNUMS = valiter;
ALPHA = valalpha;
PHI = phi;
SEGMENTS = seg;
Outrelated.MASKS = MASKS;
Outrelated.ITERNUMS = ITERNUMS;
Outrelated.ALPHA = ALPHA;
Outrelated.PHI = PHI;
Outrelated.SEGMENTS = SEGMENTS;
INDS = find(SEGMENTS);
set(HSAL.RelatedInfo_text,'string',{['区域体素数目: ',num2str(nnz(SEGMENTS))],...
    Showinfo,['最大值: ',num2str(max(DAT0(INDS)))],...
    ['最小值: ',num2str(min(DAT0(INDS)))],...
    ['平均值: ',num2str(mean(DAT0(INDS)))]})
save('temp')
set(HSAL.sliceslide,'val',DATtemp);

axis(HSAL.Axial,'off');
axis(HSAL.Coronal,'off');
axis(HSAL.Sagittal,'off');
axis(HSAL.Sel,'off');
HSAL_SLIDE('','',HSAL,dat,dims);
HSAL_PICKOK2('','',HSAL,dat,dims);
end