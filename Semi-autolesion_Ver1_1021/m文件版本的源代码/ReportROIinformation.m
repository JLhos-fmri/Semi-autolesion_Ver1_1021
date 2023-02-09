function ReportROIinformation(dat,dat2,hdr,hdr2,outputs)
CMAPS = [0:1/127:1;0:1/127:1;0:1/127:1]';
dims = size(dat);
HREP.DAT = dat;
HREP.HDR = hdr;
HREP.DAT2 = dat2;
HREP.HDR2 = hdr2;
HREP.OUT = outputs;
HREP.total = figure('menubar','none',...
    'color','w',...
    'units','normalized',...
    'position',[0.2,0.07,0.6,0.86],...
    'name','Report ROI Informations Toolkit Version 1.0');
HREP.Sagittal = axes('parent',HREP.total,...
    'units','norm',...
    'pos',[0.505,0.75,0.225,0.2]);
HREP.Coronal = axes('parent',HREP.total,...
    'units','norm',...
    'pos',[0.75,0.75,0.225,0.2]);
HREP.Axial = axes('parent',HREP.total,...
    'units','norm',...
    'pos',[0.505,0.525,0.225,0.2]);
HREP.Sel = axes('parent',HREP.total,...
    'units','norm',...
    'pos',[0.1,0.6,0.3,0.3]);
HREP.Selrad(1) = uicontrol('parent',HREP.total,...
    'units','norm',...
    'pos',[0.1,0.925,0.1,0.025],...
    'style','rad',...
    'val',1,...
    'string','axial');
HREP.Selrad(2) = uicontrol('parent',HREP.total,...
    'units','norm',...
    'pos',[0.2,0.925,0.1,0.025],...
    'style','rad',...
    'val',0,...
    'string','sagittal');
HREP.Selrad(3) = uicontrol('parent',HREP.total,...
    'units','norm',...
    'pos',[0.3,0.925,0.1,0.025],...
    'style','rad',...
    'val',0,...
    'string','Coronal');
HREP.sliceslide = uicontrol('parent',HREP.total,...
    'units','norm',...
    'pos',[0.1,0.52,0.3,0.05],...
    'style','slide',...
    'Min',1,...
    'Max',dims(3),...
    'val',round(dims(3)/2),...
    'SliderStep',[1/dims(3) 1/dims(3)]);
axis(HREP.Axial,[0,size(dat,2),0,size(dat,1)])
axis(HREP.Coronal,[0,size(dat,1),0,size(dat,3)])
axis(HREP.Sagittal,[0,size(dat,2),0,size(dat,3)])
axis(HREP.Sel,[0,size(dat,2),0,size(dat,1)]);
HREP.axes = axes('parent',HREP.total,...
    'unit','norm',...
    'pos',[0 0 1 1]);
hold(HREP.axes,'on')
plot(HREP.axes,[0,1],[0.5,0.5],'k','linewidth',2);
plot(HREP.axes,[0.5,0.5],[0,0.5],'k','linewidth',2);
axis(HREP.axes,[0 1 0 1]);
axis(HREP.axes,'off')
hold(HREP.axes,'off')

indexs = find(dat2);
wholedat = dat(indexs);
HREP.WholeAxes = axes('parent',HREP.total,...
    'units','norm',...
    'pos',[0.05,0.26,0.4,0.22]);
hist(HREP.WholeAxes,wholedat,1000);
dim0 = round(dims(3)/2);
SELTEMPMAP2 = squeeze(dat2(:,:,dim0));
SELTEMPMAP = squeeze(dat(:,:,dim0));
HREP.SliceAxes = axes('parent',HREP.total,...
    'units','norm',...
    'pos',[0.55,0.26,0.4,0.22]);

INDS = find(SELTEMPMAP2);
slicedat = SELTEMPMAP(INDS);
hist(HREP.SliceAxes,slicedat,1000);



Axialimgtemp = squeeze(dat(:,:,round(dims(3)/2)));
minv = round(min(Axialimgtemp(Axialimgtemp>0)));
maxv = round(max(Axialimgtemp(Axialimgtemp>0)));
Axialimgtemp(1,1) = minv;
Axialimgtemp(end,end) = maxv;
image(Axialimgtemp,'parent',HREP.Axial,'CDataMapping','scaled');
colormap(HREP.Axial,CMAPS);

Coronalimgtemp1 = squeeze(dat(:,round(dims(2)/2),:));
Coronalimgtemp = rot90(Coronalimgtemp1);
minv = round(min(Coronalimgtemp(Coronalimgtemp>0)));
maxv = round(max(Coronalimgtemp(Coronalimgtemp>0)));
Coronalimgtemp(1,1) = minv;
Coronalimgtemp(end,end) = maxv;
image(Coronalimgtemp,'parent',HREP.Coronal,'CDataMapping','scaled');
colormap(HREP.Coronal,CMAPS);
Sagittalimgtemp1 = squeeze(dat(round(dims(1)/2),:,:));
Sagittalimgtemp = rot90(Sagittalimgtemp1);
minv = round(min(Sagittalimgtemp(Sagittalimgtemp>0)));
maxv = round(max(Sagittalimgtemp(Sagittalimgtemp>0)));
Sagittalimgtemp(1,1) = minv;
Sagittalimgtemp(end,end) = maxv;
image(Sagittalimgtemp,'parent',HREP.Sagittal,'CDataMapping','scaled');
colormap(HREP.Sagittal,CMAPS);

image(Axialimgtemp,'parent',HREP.Sel,'CDataMapping','scaled');
colormap(HREP.Sel,CMAPS);
axis(HREP.Sel,'off')
axis(HREP.Axial,'off')
axis(HREP.Sagittal,'off')
axis(HREP.Coronal,'off')

XDIMS = round(dims(1)/2);
YDIMS = round(dims(2)/2);
ZDIMS = round(dims(3)/2);


axialmask = squeeze(dat2(:,:,ZDIMS));
coronalmask = rot90(squeeze(dat2(:,YDIMS,:)));
sagittalmask = rot90(squeeze(dat2(XDIMS,:,:)));
if sum(axialmask(:))
    hold(HREP.Axial,'on');
    contour(HREP.Axial,axialmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Axial,'off');
    hold(HREP.Sel,'on');
    contour(HREP.Sel,axialmask, [1 1], 'g','LineWidth',4);
    contour(HREP.Sel,axialmask, [1 1], 'k','LineWidth',2);
    hold(HREP.Sel,'off');
end
if sum(coronalmask(:))
    hold(HREP.Coronal,'on');
    contour(HREP.Coronal,coronalmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Coronal,'off');
end
if sum(sagittalmask(:))
    hold(HREP.Sagittal,'on');
    contour(HREP.Sagittal,sagittalmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Sagittal,'off');
end

string1 = ['Whole ROI voxel nums: ',num2str(nnz(dat2))];
almat = hdr.mat(1:3,1:3);
 vsize = [max(abs(almat(1,:))),max(abs(almat(2,:))),max(abs(almat(3,:)))];
vols = prod(vsize)*nnz(dat2);
volshow = round(vols);
string2 = ['Whole ROI volume(ml): ',num2str(volshow/1000)];
string3 = ['min/max value in ROI: ',num2str(min(dat(indexs))),'/',num2str(max(dat(indexs)))];
% string4 = ['max value in ROI: ',num2str(max(dat(indexs)))];
string5 = ['mean/std value in ROI: ',num2str(mean(dat(indexs))),'/',num2str(std(dat(indexs)))];
% string6 = ['std : ',num2str(std(dat(indexs)))];
string7 = ['median value in ROI: ',num2str(median(dat(indexs)))];
datsort = sort(dat(indexs));
string8 = ['Q1(25%) value in ROI: ',num2str(datsort(round(length(datsort)/4)))];
string9 = ['Q3(75%) value in ROI: ',num2str(datsort(round(length(datsort)/4*3)))];
KUR = kurtosis(dat(indexs));
string10 = ['Kurtosis value in ROI: ',num2str(KUR)];
SKE = skewness(dat(indexs));
string11 = ['Skewness value in ROI: ',num2str(SKE)];
HREP.st1 = uicontrol('parent',HREP.total,...
    'units','norm',...
    'pos',[0.05,0.02,0.4,0.2],...
    'style','text',...
    'string',{string1,string2,string3,string5,string7,string8,string9,string10,string11});

%     'string',{string1,string2,string3,string4,string5,string6,string7,string8,string9,string10,string11});
%%
SELTEMPMAP2 = squeeze(dat2(:,:,dim0));
SELTEMPMAP = squeeze(dat(:,:,dim0));
INDS = find(SELTEMPMAP2);

string0s = ['Current Slice: Axiel ',num2str(ZDIMS),'(range: 1-',num2str(dims(3)),')'];
if length(INDS)>0
    string1s = ['ROI in slice voxel nums: ',num2str(nnz(SELTEMPMAP2))];
    almat = hdr.mat(1:3,1:3);
    vsize = [max(abs(almat(1,:))),max(abs(almat(2,:))),max(abs(almat(3,:)))];
    vols = prod(vsize)*nnz(SELTEMPMAP2);
    volshow = round(vols);
    string2s = ['ROI in slice volume(ml): ',num2str(volshow/1000)];
    string3s = ['min/max value in ROI in slice: ',num2str(min(SELTEMPMAP(INDS))),'/',num2str(max(SELTEMPMAP(INDS)))];
%     string4s = ['max value in ROI in slice: ',num2str(max(SELTEMPMAP(INDS)))];
    string5s = ['mean value in ROI in slice: ',num2str(mean(SELTEMPMAP(INDS)))];
    string6s = ['std : ',num2str(std(SELTEMPMAP(INDS)))];
    string7s = ['median value in ROI in slice: ',num2str(median(SELTEMPMAP(INDS)))];
    datsorts = sort(SELTEMPMAP(INDS));
    string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4))),'/',num2str(datsorts(round(length(datsorts)/4*3)))];
%     string9s = ['Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4*3)))];
    KUR = kurtosis(SELTEMPMAP(INDS));
    string10s = ['Kurtosis value in ROI in slice: ',num2str(KUR)];
    SKE = skewness(SELTEMPMAP(INDS));
    string11s = ['Skewness value in ROI in slice: ',num2str(SKE)];
else
    string1s = ['ROI in slice voxel nums: 0'];
    string2s = ['ROI in slice volume(ml): 0'];
    string3s = ['min/max value in ROI in slice: NaN/NaN'];
%     string4s = ['max value in ROI in slice: NaN'];
    string5s = ['mean value in ROI in slice: NaN'];
    string6s = ['std : NaN'];
    string7s = ['median value in ROI in slice: NaN'];
    string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: NaN/NaN'];
%     string9s = ['Q3(75%) value in ROI in slice: NaN'];
    string10s = ['Kurtosis value in ROI in slice: NaN'];
    string11s = ['Skewness value in ROI in slice: NaN'];
end

HREP.st2 = uicontrol('parent',HREP.total,...
    'units','norm',...
    'pos',[0.55,0.02,0.4,0.2],...
    'style','text',...
    'string',{string0s,string1s,string2s,string3s,[string5s,' ',string6s],string7s,string8s,string10s,string11s});
%
HREP.sentreport = uicontrol('parent',HREP.total,...
    'units','norm',...
    'pos',[0.8,0.625,0.1,0.08],...
    'style','pushbutton',...
    'string','Report');
HREP.Finish = uicontrol('parent',HREP.total,...
    'units','norm',...
    'pos',[0.8,0.525,0.1,0.08],...
    'style','pushbutton',...
    'string','Finish');

%
set(HREP.Selrad(1),'callback',{@HREP_seltype1,HREP,dat,dims,dat2})
set(HREP.Selrad(2),'callback',{@HREP_seltype2,HREP,dat,dims,dat2})
set(HREP.Selrad(3),'callback',{@HREP_seltype3,HREP,dat,dims,dat2})
set(HREP.sliceslide,'callback',{@HREP_SLIDE,HREP,dat,dims,dat2});
set(HREP.sentreport,'callback',{@HREP_REP,HREP,dat,dims,dat2});
set(HREP.Finish,'callback',{@HREP_FINISH,HREP});
end

function HREP_SLIDE(varargin)
HREP = varargin{3};
dat = varargin{4};
dims = varargin{5};
dat2 = varargin{6};
hdr = HREP.HDR;
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';
valsels = get(HREP.Selrad,'val');
valslid = get(HREP.sliceslide,'val'); 


XDIMS = round(dims(1)/2);
YDIMS = round(dims(2)/2);
ZDIMS = round(dims(3)/2);

if valsels{1}  %% val 1:dims(3)
    ZDIMS = round(valslid);
    axialimgtemp = squeeze(dat(:,:,round(valslid)));
    image(axialimgtemp,'parent',HREP.Sel,'CDataMapping','scaled');
    colormap(HREP.Sel,cmaps);
    axis(HREP.Sel,'off');
    image(axialimgtemp,'parent',HREP.Axial,'CDataMapping','scaled');
    colormap(HREP.Axial,cmaps);
    axis(HREP.Axial,'off');
    TEMPIMG = rot90(squeeze(dat(round(dims(1)/2),:,:)));
    image(TEMPIMG,'parent',HREP.Sagittal,'CDataMapping','scaled');
    colormap(HREP.Sagittal,cmaps);
    axis(HREP.Sagittal,'off');
    TEMPIMG = rot90(squeeze(dat(:,round(dims(2)/2),:)));
    image(TEMPIMG,'parent',HREP.Coronal,'CDataMapping','scaled');
    colormap(HREP.Coronal,cmaps);
    axis(HREP.Coronal,'off');
    hold(HREP.Axial,'on');
    plot(HREP.Axial,[0,dims(2)],[round(dims(1)/2),round(dims(1)/2)]);
    plot(HREP.Axial,[round(dims(2)/2),round(dims(2)/2)],[0,dims(1)]);
    hold(HREP.Axial,'off');
    hold(HREP.Sagittal,'on');
    plot(HREP.Sagittal,[0,dims(2)],[dims(3)+1-round(valslid),dims(3)+1-round(valslid)])
    plot(HREP.Sagittal,[round(dims(2)/2),round(dims(2)/2)],[0,dims(3)]);
    hold(HREP.Sagittal,'off');
    hold(HREP.Coronal,'on');
    plot(HREP.Coronal,[0,dims(1)],[dims(3)+1-round(valslid),dims(3)+1-round(valslid)])
    plot(HREP.Coronal,[round(dims(1)/2),round(dims(1)/2)],[0,dims(3)]);
    hold(HREP.Coronal,'off');
elseif valsels{2}
    XDIMS = round(valslid);
    Sagittalimgtemp = rot90(squeeze(dat(round(valslid),:,:)));
    image(Sagittalimgtemp,'parent',HREP.Sel,'CDataMapping','scaled');
    colormap(HREP.Sel,cmaps);
    axis(HREP.Sel,'off');
    TEMPIMG = squeeze(dat(:,:,round(dims(3)/2)));
    image(TEMPIMG,'parent',HREP.Axial,'CDataMapping','scaled');
    colormap(HREP.Axial,cmaps);
    axis(HREP.Axial,'off');
    image(Sagittalimgtemp,'parent',HREP.Sagittal,'CDataMapping','scaled');
    colormap(HREP.Sagittal,cmaps);
    axis(HREP.Sagittal,'off');
    TEMPIMG = rot90(squeeze(dat(:,round(dims(2)/2),:)));
    image(TEMPIMG,'parent',HREP.Coronal,'CDataMapping','scaled');
    colormap(HREP.Coronal,cmaps);
    axis(HREP.Coronal,'off');hold(HREP.Sagittal,'on');
    plot(HREP.Sagittal,[0,dims(2)],[round(dims(3)/2),round(dims(3)/2)])
    plot(HREP.Sagittal,[round(dims(2)/2),round(dims(2)/2)],[0,dims(3)]);
    hold(HREP.Sagittal,'off');
    
    hold(HREP.Axial,'on');
    plot(HREP.Axial,[0,dims(2)],[round(valslid),round(valslid)]);
    plot(HREP.Axial,[round(dims(2)/2),round(dims(2)/2)],[0,dims(1)]);
    hold(HREP.Axial,'off');
    
    hold(HREP.Coronal,'on');
    plot(HREP.Coronal,[0,dims(1)],[round(dims(3)/2),round(dims(3)/2)])
    plot(HREP.Coronal,[round(valslid),round(valslid)],[0,dims(3)]);
    hold(HREP.Coronal,'off');
else    
    YDIMS = round(valslid);
    TEMPIMG = rot90(squeeze(dat(:,round(valslid),:)));
    image(TEMPIMG,'parent',HREP.Sel,'CDataMapping','scaled');
    colormap(HREP.Sel,cmaps);
    axis(HREP.Sel,'off');
    TEMPIMG = squeeze(dat(:,:,round(dims(3)/2)));
    image(TEMPIMG,'parent',HREP.Axial,'CDataMapping','scaled');
    colormap(HREP.Axial,cmaps);
    axis(HREP.Axial,'off');
    TEMPIMG = rot90(squeeze(dat(round(dims(1)/2),:,:)));
    image(TEMPIMG,'parent',HREP.Sagittal,'CDataMapping','scaled');
    colormap(HREP.Sagittal,cmaps);
    axis(HREP.Sagittal,'off');
    TEMPIMG = rot90(squeeze(dat(:,round(valslid),:)));
    image(TEMPIMG,'parent',HREP.Coronal,'CDataMapping','scaled');
    colormap(HREP.Coronal,cmaps);
    axis(HREP.Coronal,'off');hold(HREP.Coronal,'on');
    plot(HREP.Coronal,[0,dims(1)],[round(dims(3)/2),round(dims(3)/2)])
    plot(HREP.Coronal,[round(dims(1)/2),round(dims(1)/2)],[0,dims(3)]);
    hold(HREP.Coronal,'off');
    
    hold(HREP.Sagittal,'on');
    plot(HREP.Sagittal,[0,dims(2)],[round(dims(3)/2),round(dims(3)/2)])
    plot(HREP.Sagittal,[round(valslid),round(valslid)],[0,dims(3)]);
    hold(HREP.Sagittal,'off');
    
    hold(HREP.Axial,'on');
    plot(HREP.Axial,[0,dims(2)],[round(dims(1)/2),round(dims(1)/2)]);
    plot(HREP.Axial,[round(valslid),round(valslid)],[0,dims(1)]);
    hold(HREP.Axial,'off');
end

axialmask = squeeze(dat2(:,:,ZDIMS));
coronalmask = rot90(squeeze(dat2(:,YDIMS,:)));
sagittalmask = rot90(squeeze(dat2(XDIMS,:,:)));
if sum(axialmask(:))
    hold(HREP.Axial,'on');
    contour(HREP.Axial,axialmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Axial,'off');
end
if sum(coronalmask(:))
    hold(HREP.Coronal,'on');
    contour(HREP.Coronal,coronalmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Coronal,'off');
end
if sum(sagittalmask(:))
    hold(HREP.Sagittal,'on');
    contour(HREP.Sagittal,sagittalmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Sagittal,'off');
end
if valsels{1}
    hold(HREP.Sel,'on');
    if nnz(axialmask)>0
        contour(HREP.Sel,axialmask, [1 1], 'g','LineWidth',4);
        contour(HREP.Sel,axialmask, [1 1], 'k','LineWidth',2);
    end
    hold(HREP.Sel,'off');
    SELTEMPMAP2 = squeeze(dat2(:,:,ZDIMS));
    SELTEMPMAP = squeeze(dat(:,:,ZDIMS));
    INDS = find(SELTEMPMAP2);
    string0s = ['Current Slice: Axiel ',num2str(ZDIMS),'(range: 1-',num2str(dims(3)),')'];
    if length(INDS)>0
        string1s = ['ROI in slice voxel nums: ',num2str(nnz(SELTEMPMAP2))];
        almat = hdr.mat(1:3,1:3);
        vsize = [max(abs(almat(1,:))),max(abs(almat(2,:))),max(abs(almat(3,:)))];
        vols = prod(vsize)*nnz(SELTEMPMAP2);
        volshow = round(vols);
        string2s = ['ROI in slice volume(ml): ',num2str(volshow/1000)];
        string3s = ['min/max value in ROI in slice: ',num2str(min(SELTEMPMAP(INDS))),'/',num2str(max(SELTEMPMAP(INDS)))];
%         string4s = ['max value in ROI in slice: ',num2str(max(SELTEMPMAP(INDS)))];
        string5s = ['mean value in ROI in slice: ',num2str(mean(SELTEMPMAP(INDS)))];
        string6s = ['std : ',num2str(std(SELTEMPMAP(INDS)))];
        string7s = ['median value in ROI in slice: ',num2str(median(SELTEMPMAP(INDS)))];
        datsorts = sort(SELTEMPMAP(INDS));
        string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4))),'/',num2str(datsorts(round(length(datsorts)/4*3)))];
%         string9s = ['Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4*3)))];
        KUR = kurtosis(SELTEMPMAP(INDS));
        string10s = ['Kurtosis value in ROI in slice: ',num2str(KUR)];
        SKE = skewness(SELTEMPMAP(INDS));
        string11s = ['Skewness value in ROI in slice: ',num2str(SKE)];
    else
        string1s = ['ROI in slice voxel nums: 0'];
        string2s = ['ROI in slice volume(ml): 0'];
        string3s = ['min value in ROI in slice: NaN/NaN'];
%         string4s = ['max value in ROI in slice: NaN'];
        string5s = ['mean value in ROI in slice: NaN'];
        string6s = ['std : NaN'];
        string7s = ['median value in ROI in slice: NaN'];
        string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: NaN/NaN'];
%         string9s = ['Q3(75%) value in ROI in slice: NaN'];
        string10s = ['Kurtosis value in ROI in slice: NaN'];
        string11s = ['Skewness value in ROI in slice: NaN'];
    end
    
    HREP.st2 = uicontrol('parent',HREP.total,...
        'units','norm',...
        'pos',[0.55,0.02,0.4,0.2],...
        'style','text',...
        'string',{string0s,string1s,string2s,string3s,[string5s,' ',string6s],string7s,string8s,string10s,string11s});
    
    INDS = find(SELTEMPMAP2);
    slicedat = SELTEMPMAP(INDS);
    hist(HREP.SliceAxes,slicedat,1000);
elseif valsels{2}
    hold(HREP.Sel,'on');
    if nnz(sagittalmask)>0
        contour(HREP.Sel,sagittalmask, [1 1], 'g','LineWidth',4);
        contour(HREP.Sel,sagittalmask, [1 1], 'k','LineWidth',2);
    end
    hold(HREP.Sel,'off');
    SELTEMPMAP2 = squeeze(dat2(XDIMS,:,:));
    SELTEMPMAP = squeeze(dat(XDIMS,:,:));
    INDS = find(SELTEMPMAP2);
    string0s = ['Current Slice: Sagittal ',num2str(XDIMS),'(range: 1-',num2str(dims(1)),')'];
    if length(INDS)>0
        string1s = ['ROI in slice voxel nums: ',num2str(nnz(SELTEMPMAP2))];
        almat = hdr.mat(1:3,1:3);
        vsize = [max(abs(almat(1,:))),max(abs(almat(2,:))),max(abs(almat(3,:)))];
        vols = prod(vsize)*nnz(SELTEMPMAP2);
        volshow = round(vols);
        string2s = ['ROI in slice volume(ml): ',num2str(volshow/1000)];
        string3s = ['min/max value in ROI in slice: ',num2str(min(SELTEMPMAP(INDS))),'/',num2str(max(SELTEMPMAP(INDS)))];
%         string4s = ['max value in ROI in slice: ',num2str(max(SELTEMPMAP(INDS)))];
        string5s = ['mean value in ROI in slice: ',num2str(mean(SELTEMPMAP(INDS)))];
        string6s = ['std : ',num2str(std(SELTEMPMAP(INDS)))];
        string7s = ['median value in ROI in slice: ',num2str(median(SELTEMPMAP(INDS)))];
        datsorts = sort(SELTEMPMAP(INDS));
        string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4))),'/',num2str(datsorts(round(length(datsorts)/4*3)))];
%         string9s = ['Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4*3)))];
        KUR = kurtosis(SELTEMPMAP(INDS));
        string10s = ['Kurtosis value in ROI in slice: ',num2str(KUR)];
        SKE = skewness(SELTEMPMAP(INDS));
        string11s = ['Skewness value in ROI in slice: ',num2str(SKE)];
    else
        string1s = ['ROI in slice voxel nums: 0'];
        string2s = ['ROI in slice volume(ml): 0'];
        string3s = ['min value in ROI in slice: NaN/NaN'];
%         string4s = ['max value in ROI in slice: NaN'];
        string5s = ['mean value in ROI in slice: NaN'];
        string6s = ['std : NaN'];
        string7s = ['median value in ROI in slice: NaN'];
        string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: NaN/NaN'];
%         string9s = ['Q3(75%) value in ROI in slice: NaN'];
        string10s = ['Kurtosis value in ROI in slice: NaN'];
        string11s = ['Skewness value in ROI in slice: NaN'];
    end
    
    HREP.st2 = uicontrol('parent',HREP.total,...
        'units','norm',...
        'pos',[0.55,0.02,0.4,0.2],...
        'style','text',...
        'string',{string0s,string1s,string2s,string3s,[string5s,' ',string6s],string7s,string8s,string10s,string11s});
    
    INDS = find(SELTEMPMAP2);
    slicedat = SELTEMPMAP(INDS);
    hist(HREP.SliceAxes,slicedat,1000);
else
    hold(HREP.Sel,'on');
%     if sum(coronalmask)>0
        contour(HREP.Sel,coronalmask, [1 1], 'g','LineWidth',4);
        contour(HREP.Sel,coronalmask, [1 1], 'k','LineWidth',2);
%     end
    hold(HREP.Sel,'off');
    SELTEMPMAP2 = squeeze(dat2(:,YDIMS,:));
    SELTEMPMAP = squeeze(dat(:,YDIMS,:));
    INDS = find(SELTEMPMAP2);
    string0s = ['Current Slice: Coronal ',num2str(YDIMS),'(range: 1-',num2str(dims(2)),')'];
    if length(INDS)>0
        string1s = ['ROI in slice voxel nums: ',num2str(nnz(SELTEMPMAP2))];
        almat = hdr.mat(1:3,1:3);
        vsize = [max(abs(almat(1,:))),max(abs(almat(2,:))),max(abs(almat(3,:)))];
        vols = prod(vsize)*nnz(SELTEMPMAP2);
        volshow = round(vols);
        string2s = ['ROI in slice volume(ml): ',num2str(volshow/1000)];
        string3s = ['min/max value in ROI in slice: ',num2str(min(SELTEMPMAP(INDS))),'/',num2str(max(SELTEMPMAP(INDS)))];
%         string4s = ['max value in ROI in slice: ',num2str(max(SELTEMPMAP(INDS)))];
        string5s = ['mean value in ROI in slice: ',num2str(mean(SELTEMPMAP(INDS)))];
        string6s = ['std : ',num2str(std(SELTEMPMAP(INDS)))];
        string7s = ['median value in ROI in slice: ',num2str(median(SELTEMPMAP(INDS)))];
        datsorts = sort(SELTEMPMAP(INDS));
        string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4))),'/',num2str(datsorts(round(length(datsorts)/4*3)))];
%         string9s = ['Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4*3)))];
        KUR = kurtosis(SELTEMPMAP(INDS));
        string10s = ['Kurtosis value in ROI in slice: ',num2str(KUR)];
        SKE = skewness(SELTEMPMAP(INDS));
        string11s = ['Skewness value in ROI in slice: ',num2str(SKE)];
    else
        string1s = ['ROI in slice voxel nums: 0'];
        string2s = ['ROI in slice volume(ml): 0'];
        string3s = ['min value in ROI in slice: NaN/NaN'];
%         string4s = ['max value in ROI in slice: NaN'];
        string5s = ['mean value in ROI in slice: NaN'];
        string6s = ['std : NaN'];
        string7s = ['median value in ROI in slice: NaN'];
        string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: NaN/NaN'];
%         string9s = ['Q3(75%) value in ROI in slice: NaN'];
        string10s = ['Kurtosis value in ROI in slice: NaN'];
        string11s = ['Skewness value in ROI in slice: NaN'];
    end
    
    HREP.st2 = uicontrol('parent',HREP.total,...
        'units','norm',...
        'pos',[0.55,0.02,0.4,0.2],...
        'style','text',...
        'string',{string0s,string1s,string2s,string3s,[string5s,' ',string6s],string7s,string8s,string10s,string11s});
    
    INDS = find(SELTEMPMAP2);
    slicedat = SELTEMPMAP(INDS);
    hist(HREP.SliceAxes,slicedat,1000);
end

end
function HREP_seltype1(varargin)
CMAPS = [0:1/127:1;0:1/127:1;0:1/127:1]';
HREP = varargin{3};
dat = varargin{4};
dims = varargin{5};
dat2 = varargin{6};
hdr = HREP.HDR;
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';

set(HREP.Selrad(1),'value',1);
set(HREP.Selrad(2),'value',0);
set(HREP.Selrad(3),'value',0);
XDIMS = round(dims(1)/2);
YDIMS = round(dims(2)/2);
ZDIMS = round(dims(3)/2);

Selouts = squeeze(dat(:,:,ZDIMS));
image(Selouts,'parent',HREP.Sel,'CDataMapping','scaled');
colormap(HREP.Sel,CMAPS);

set(HREP.sliceslide,'max',dims(3));
set(HREP.sliceslide,'SliderStep',[1/dims(3),1/dims(3)]);
set(HREP.sliceslide,'val',round(dims(3)/2));

Axialimgtemp = squeeze(dat(:,:,ZDIMS));
image(Axialimgtemp,'parent',HREP.Axial,'CDataMapping','scaled');
colormap(HREP.Axial,CMAPS);
Coronalimgtemp1 = squeeze(dat(:,YDIMS,:));
Coronalimgtemp = rot90(Coronalimgtemp1);
image(Coronalimgtemp,'parent',HREP.Coronal,'CDataMapping','scaled');
colormap(HREP.Coronal,CMAPS);
Sagittalimgtemp1 = squeeze(dat(XDIMS,:,:));
Sagittalimgtemp = rot90(Sagittalimgtemp1);
image(Sagittalimgtemp,'parent',HREP.Sagittal,'CDataMapping','scaled');
colormap(HREP.Sagittal,CMAPS);
%
axialmask = squeeze(dat2(:,:,ZDIMS));
coronalmask = rot90(squeeze(dat2(:,YDIMS,:)));
sagittalmask = rot90(squeeze(dat2(XDIMS,:,:)));
if sum(axialmask(:))
    hold(HREP.Axial,'on');
    contour(HREP.Axial,axialmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Axial,'off');
    hold(HREP.Sel,'on');
    contour(HREP.Sel,axialmask, [1 1], 'g','LineWidth',4);
    contour(HREP.Sel,axialmask, [1 1], 'k','LineWidth',2);
    hold(HREP.Sel,'off');
end
if sum(coronalmask(:))
    hold(HREP.Coronal,'on');
    contour(HREP.Coronal,coronalmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Coronal,'off');
end
if sum(sagittalmask(:))
    hold(HREP.Sagittal,'on');
    contour(HREP.Sagittal,sagittalmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Sagittal,'off');
end
%
SELTEMPMAP2 = squeeze(dat2(:,:,ZDIMS));
SELTEMPMAP = squeeze(dat(:,:,ZDIMS));
INDS = find(SELTEMPMAP2);
string0s = ['Current Slice: Axiel ',num2str(ZDIMS),'(range: 1-',num2str(dims(3)),')'];
if length(INDS)>0
    string1s = ['ROI in slice voxel nums: ',num2str(nnz(SELTEMPMAP2))];
    almat = hdr.mat(1:3,1:3);
    vsize = [max(abs(almat(1,:))),max(abs(almat(2,:))),max(abs(almat(3,:)))];
    vols = prod(vsize)*nnz(SELTEMPMAP2);
    volshow = round(vols);
    string2s = ['ROI in slice volume(ml): ',num2str(volshow/1000)];
    string3s = ['min/max value in ROI in slice: ',num2str(min(SELTEMPMAP(INDS))),'/',num2str(max(SELTEMPMAP(INDS)))];
    %         string4s = ['max value in ROI in slice: ',num2str(max(SELTEMPMAP(INDS)))];
    string5s = ['mean value in ROI in slice: ',num2str(mean(SELTEMPMAP(INDS)))];
    string6s = ['std : ',num2str(std(SELTEMPMAP(INDS)))];
    string7s = ['median value in ROI in slice: ',num2str(median(SELTEMPMAP(INDS)))];
    datsorts = sort(SELTEMPMAP(INDS));
    string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4))),'/',num2str(datsorts(round(length(datsorts)/4*3)))];
    %         string9s = ['Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4*3)))];
    KUR = kurtosis(SELTEMPMAP(INDS));
    string10s = ['Kurtosis value in ROI in slice: ',num2str(KUR)];
    SKE = skewness(SELTEMPMAP(INDS));
    string11s = ['Skewness value in ROI in slice: ',num2str(SKE)];
else
    string1s = ['ROI in slice voxel nums: 0'];
    string2s = ['ROI in slice volume(ml): 0'];
    string3s = ['min value in ROI in slice: NaN/NaN'];
    %         string4s = ['max value in ROI in slice: NaN'];
    string5s = ['mean value in ROI in slice: NaN'];
    string6s = ['std : NaN'];
    string7s = ['median value in ROI in slice: NaN'];
    string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: NaN/NaN'];
    %         string9s = ['Q3(75%) value in ROI in slice: NaN'];
    string10s = ['Kurtosis value in ROI in slice: NaN'];
    string11s = ['Skewness value in ROI in slice: NaN'];
end

HREP.st2 = uicontrol('parent',HREP.total,...
    'units','norm',...
    'pos',[0.55,0.02,0.4,0.2],...
    'style','text',...
    'string',{string0s,string1s,string2s,string3s,[string5s,' ',string6s],string7s,string8s,string10s,string11s});
% string0s = ['Current Slice: Axiel ',num2str(ZDIMS),'(range: 1-',num2str(dims(3)),')'];
% if length(INDS)>0
%     string1s = ['ROI in slice voxel nums: ',num2str(nnz(SELTEMPMAP2))];
%     almat = hdr.mat(1:3,1:3);
%     vsize = [max(abs(almat(1,:))),max(abs(almat(2,:))),max(abs(almat(3,:)))];
%     vols = prod(vsize)*nnz(SELTEMPMAP2);
%     volshow = round(vols);
%     string2s = ['ROI in slice volume(ml): ',num2str(volshow/1000)];
%     string3s = ['min value in ROI in slice: ',num2str(min(SELTEMPMAP(INDS)))];
%     string4s = ['max value in ROI in slice: ',num2str(max(SELTEMPMAP(INDS)))];
%     string5s = ['mean value in ROI in slice: ',num2str(mean(SELTEMPMAP(INDS)))];
%     string6s = ['std : ',num2str(std(SELTEMPMAP(INDS)))];
%     string7s = ['median value in ROI in slice: ',num2str(median(SELTEMPMAP(INDS)))];
%     datsorts = sort(SELTEMPMAP(INDS));
%     string8s = ['Q1(25%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4)))];
%     string9s = ['Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4*3)))];
% else
%     string1s = ['ROI in slice voxel nums: 0'];
%     string2s = ['ROI in slice volume(ml): 0'];
%     string3s = ['min value in ROI in slice: NaN'];
%     string4s = ['max value in ROI in slice: NaN'];
%     string5s = ['mean value in ROI in slice: NaN'];
%     string6s = ['std : NaN'];
%     string7s = ['median value in ROI in slice: NaN'];
%     string8s = ['Q1(25%) value in ROI in slice: NaN'];
%     string9s = ['Q3(75%) value in ROI in slice: NaN'];
% end
% 
% HREP.st2 = uicontrol('parent',HREP.total,...
%     'units','norm',...
%     'pos',[0.55,0.02,0.4,0.2],...
%     'style','text',...
%     'string',{string0s,string1s,string2s,string3s,string4s,[string5s,' ',string6s],string7s,string8s,string9s});

INDS = find(SELTEMPMAP2);
slicedat = SELTEMPMAP(INDS);
hist(HREP.SliceAxes,slicedat,1000);

axis(HREP.Axial,'off')
axis(HREP.Sagittal,'off')
axis(HREP.Coronal,'off')
axis(HREP.Sel,'off')
end
function HREP_seltype2(varargin)
CMAPS = [0:1/127:1;0:1/127:1;0:1/127:1]';
HREP = varargin{3};
dat = varargin{4};
dims = varargin{5};
dat2 = varargin{6};
hdr = HREP.HDR;
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';
XDIMS = round(dims(1)/2);
YDIMS = round(dims(2)/2);
ZDIMS = round(dims(3)/2);

set(HREP.Selrad(1),'value',0);
set(HREP.Selrad(2),'value',1);
set(HREP.Selrad(3),'value',0);

Selouts = rot90(squeeze(dat(XDIMS,:,:)));
image(Selouts,'parent',HREP.Sel,'CDataMapping','scaled');
colormap(HREP.Sel,CMAPS);

set(HREP.sliceslide,'max',dims(1));
set(HREP.sliceslide,'SliderStep',[1/dims(1),1/dims(1)]);
set(HREP.sliceslide,'val',round(dims(1)/2));

Axialimgtemp = squeeze(dat(:,:,ZDIMS));
image(Axialimgtemp,'parent',HREP.Axial,'CDataMapping','scaled');
colormap(HREP.Axial,CMAPS);
Coronalimgtemp1 = squeeze(dat(:,YDIMS,:));
Coronalimgtemp = rot90(Coronalimgtemp1);
image(Coronalimgtemp,'parent',HREP.Coronal,'CDataMapping','scaled');
colormap(HREP.Coronal,CMAPS);
Sagittalimgtemp1 = squeeze(dat(XDIMS,:,:));
Sagittalimgtemp = rot90(Sagittalimgtemp1);
image(Sagittalimgtemp,'parent',HREP.Sagittal,'CDataMapping','scaled');
colormap(HREP.Sagittal,CMAPS);
%
axialmask = squeeze(dat2(:,:,ZDIMS));
coronalmask = rot90(squeeze(dat2(:,YDIMS,:)));
sagittalmask = rot90(squeeze(dat2(XDIMS,:,:)));
if sum(axialmask(:))
    hold(HREP.Axial,'on');
    contour(HREP.Axial,axialmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Axial,'off');
    
end
if sum(coronalmask(:))
    hold(HREP.Coronal,'on');
    contour(HREP.Coronal,coronalmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Coronal,'off');
end
if sum(sagittalmask(:))
    hold(HREP.Sagittal,'on');
    contour(HREP.Sagittal,sagittalmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Sagittal,'off');
    hold(HREP.Sel,'on');
    contour(HREP.Sel,sagittalmask, [1 1], 'g','LineWidth',4);
    contour(HREP.Sel,sagittalmask, [1 1], 'k','LineWidth',2);
    hold(HREP.Sel,'off');
end
%
SELTEMPMAP2 = squeeze(dat2(XDIMS,:,:));
SELTEMPMAP = squeeze(dat(XDIMS,:,:));
INDS = find(SELTEMPMAP2);
string0s = ['Current Slice: Sagittal ',num2str(XDIMS),'(range: 1-',num2str(dims(1)),')'];
if length(INDS)>0
    string1s = ['ROI in slice voxel nums: ',num2str(nnz(SELTEMPMAP2))];
    almat = hdr.mat(1:3,1:3);
    vsize = [max(abs(almat(1,:))),max(abs(almat(2,:))),max(abs(almat(3,:)))];
    vols = prod(vsize)*nnz(SELTEMPMAP2);
    volshow = round(vols);
    string2s = ['ROI in slice volume(ml): ',num2str(volshow/1000)];
    string3s = ['min/max value in ROI in slice: ',num2str(min(SELTEMPMAP(INDS))),'/',num2str(max(SELTEMPMAP(INDS)))];
    %         string4s = ['max value in ROI in slice: ',num2str(max(SELTEMPMAP(INDS)))];
    string5s = ['mean value in ROI in slice: ',num2str(mean(SELTEMPMAP(INDS)))];
    string6s = ['std : ',num2str(std(SELTEMPMAP(INDS)))];
    string7s = ['median value in ROI in slice: ',num2str(median(SELTEMPMAP(INDS)))];
    datsorts = sort(SELTEMPMAP(INDS));
    string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4))),'/',num2str(datsorts(round(length(datsorts)/4*3)))];
    %         string9s = ['Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4*3)))];
    KUR = kurtosis(SELTEMPMAP(INDS));
    string10s = ['Kurtosis value in ROI in slice: ',num2str(KUR)];
    SKE = skewness(SELTEMPMAP(INDS));
    string11s = ['Skewness value in ROI in slice: ',num2str(SKE)];
else
    string1s = ['ROI in slice voxel nums: 0'];
    string2s = ['ROI in slice volume(ml): 0'];
    string3s = ['min value in ROI in slice: NaN/NaN'];
    %         string4s = ['max value in ROI in slice: NaN'];
    string5s = ['mean value in ROI in slice: NaN'];
    string6s = ['std : NaN'];
    string7s = ['median value in ROI in slice: NaN'];
    string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: NaN/NaN'];
    %         string9s = ['Q3(75%) value in ROI in slice: NaN'];
    string10s = ['Kurtosis value in ROI in slice: NaN'];
    string11s = ['Skewness value in ROI in slice: NaN'];
end

HREP.st2 = uicontrol('parent',HREP.total,...
    'units','norm',...
    'pos',[0.55,0.02,0.4,0.2],...
    'style','text',...
    'string',{string0s,string1s,string2s,string3s,[string5s,' ',string6s],string7s,string8s,string10s,string11s});
% string0s = ['Current Slice: Sagittal ',num2str(XDIMS),'(range: 1-',num2str(dims(1)),')'];
% if length(INDS)>0
%     string1s = ['ROI in slice voxel nums: ',num2str(nnz(SELTEMPMAP2))];
%     almat = hdr.mat(1:3,1:3);
%     vsize = [max(abs(almat(1,:))),max(abs(almat(2,:))),max(abs(almat(3,:)))];
%     vols = prod(vsize)*nnz(SELTEMPMAP2);
%     volshow = round(vols);
%     string2s = ['ROI in slice volume(ml): ',num2str(volshow/1000)];
%     string3s = ['min value in ROI in slice: ',num2str(min(SELTEMPMAP(INDS)))];
%     string4s = ['max value in ROI in slice: ',num2str(max(SELTEMPMAP(INDS)))];
%     string5s = ['mean value in ROI in slice: ',num2str(mean(SELTEMPMAP(INDS)))];
%     string6s = ['std : ',num2str(std(SELTEMPMAP(INDS)))];
%     string7s = ['median value in ROI in slice: ',num2str(median(SELTEMPMAP(INDS)))];
%     datsorts = sort(SELTEMPMAP(INDS));
%     string8s = ['Q1(25%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4)))];
%     string9s = ['Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4*3)))];
% else
%     string1s = ['ROI in slice voxel nums: 0'];
%     string2s = ['ROI in slice volume(ml): 0'];
%     string3s = ['min value in ROI in slice: NaN'];
%     string4s = ['max value in ROI in slice: NaN'];
%     string5s = ['mean value in ROI in slice: NaN'];
%     string6s = ['std : NaN'];
%     string7s = ['median value in ROI in slice: NaN'];
%     string8s = ['Q1(25%) value in ROI in slice: NaN'];
%     string9s = ['Q3(75%) value in ROI in slice: NaN'];
% end
% HREP.st2 = uicontrol('parent',HREP.total,...
%     'units','norm',...
%     'pos',[0.55,0.02,0.4,0.2],...
%     'style','text',...
%     'string',{string0s,string1s,string2s,string3s,string4s,[string5s,' ',string6s],string7s,string8s,string9s});

INDS = find(SELTEMPMAP2);
slicedat = SELTEMPMAP(INDS);
hist(HREP.SliceAxes,slicedat,1000);

axis(HREP.Axial,'off')
axis(HREP.Sagittal,'off')
axis(HREP.Coronal,'off')
axis(HREP.Sel,'off')
end
function HREP_seltype3(varargin)
CMAPS = [0:1/127:1;0:1/127:1;0:1/127:1]';
HREP = varargin{3};
dat = varargin{4};
dims = varargin{5};
dat2 = varargin{6};
hdr = HREP.HDR;
cmaps = [0:1/127:1;0:1/127:1;0:1/127:1]';

set(HREP.Selrad(1),'value',0);
set(HREP.Selrad(2),'value',0);
set(HREP.Selrad(3),'value',1);
XDIMS = round(dims(1)/2);
YDIMS = round(dims(2)/2);
ZDIMS = round(dims(3)/2);

Selouts = rot90(squeeze(dat(:,YDIMS,:)));
image(Selouts,'parent',HREP.Sel,'CDataMapping','scaled');
colormap(HREP.Sel,CMAPS);

set(HREP.sliceslide,'max',dims(2));
set(HREP.sliceslide,'SliderStep',[1/dims(2),1/dims(2)]);
set(HREP.sliceslide,'val',round(dims(2)/2));

Axialimgtemp = squeeze(dat(:,:,ZDIMS));
image(Axialimgtemp,'parent',HREP.Axial,'CDataMapping','scaled');
colormap(HREP.Axial,CMAPS);
Coronalimgtemp1 = squeeze(dat(:,YDIMS,:));
Coronalimgtemp = rot90(Coronalimgtemp1);
image(Coronalimgtemp,'parent',HREP.Coronal,'CDataMapping','scaled');
colormap(HREP.Coronal,CMAPS);
Sagittalimgtemp1 = squeeze(dat(XDIMS,:,:));
Sagittalimgtemp = rot90(Sagittalimgtemp1);
image(Sagittalimgtemp,'parent',HREP.Sagittal,'CDataMapping','scaled');
colormap(HREP.Sagittal,CMAPS);

%
axialmask = squeeze(dat2(:,:,ZDIMS));
coronalmask = rot90(squeeze(dat2(:,YDIMS,:)));
sagittalmask = rot90(squeeze(dat2(XDIMS,:,:)));
if sum(axialmask(:))
    hold(HREP.Axial,'on');
    contour(HREP.Axial,axialmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Axial,'off');
end
if sum(coronalmask(:))
    hold(HREP.Coronal,'on');
    contour(HREP.Coronal,coronalmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Coronal,'off');
    hold(HREP.Sel,'on');
    contour(HREP.Sel,coronalmask, [1 1], 'g','LineWidth',4);
    contour(HREP.Sel,coronalmask, [1 1], 'k','LineWidth',2);
    hold(HREP.Sel,'off');
end
if sum(sagittalmask(:))
    hold(HREP.Sagittal,'on');
    contour(HREP.Sagittal,sagittalmask, [1 1], 'r','LineWidth',2);
    hold(HREP.Sagittal,'off');
end
%
SELTEMPMAP2 = squeeze(dat2(:,YDIMS,:));
SELTEMPMAP = squeeze(dat(:,YDIMS,:));
INDS = find(SELTEMPMAP2);
string0s = ['Current Slice: Coronal ',num2str(YDIMS),'(range: 1-',num2str(dims(2)),')'];
if length(INDS)>0
    string1s = ['ROI in slice voxel nums: ',num2str(nnz(SELTEMPMAP2))];
    almat = hdr.mat(1:3,1:3);
    vsize = [max(abs(almat(1,:))),max(abs(almat(2,:))),max(abs(almat(3,:)))];
    vols = prod(vsize)*nnz(SELTEMPMAP2);
    volshow = round(vols);
    string2s = ['ROI in slice volume(ml): ',num2str(volshow/1000)];
    string3s = ['min/max value in ROI in slice: ',num2str(min(SELTEMPMAP(INDS))),'/',num2str(max(SELTEMPMAP(INDS)))];
    %         string4s = ['max value in ROI in slice: ',num2str(max(SELTEMPMAP(INDS)))];
    string5s = ['mean value in ROI in slice: ',num2str(mean(SELTEMPMAP(INDS)))];
    string6s = ['std : ',num2str(std(SELTEMPMAP(INDS)))];
    string7s = ['median value in ROI in slice: ',num2str(median(SELTEMPMAP(INDS)))];
    datsorts = sort(SELTEMPMAP(INDS));
    string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4))),'/',num2str(datsorts(round(length(datsorts)/4*3)))];
    %         string9s = ['Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4*3)))];
    KUR = kurtosis(SELTEMPMAP(INDS));
    string10s = ['Kurtosis value in ROI in slice: ',num2str(KUR)];
    SKE = skewness(SELTEMPMAP(INDS));
    string11s = ['Skewness value in ROI in slice: ',num2str(SKE)];
else
    string1s = ['ROI in slice voxel nums: 0'];
    string2s = ['ROI in slice volume(ml): 0'];
    string3s = ['min value in ROI in slice: NaN/NaN'];
    %         string4s = ['max value in ROI in slice: NaN'];
    string5s = ['mean value in ROI in slice: NaN'];
    string6s = ['std : NaN'];
    string7s = ['median value in ROI in slice: NaN'];
    string8s = ['Q1(25%)/Q3(75%) value in ROI in slice: NaN/NaN'];
    %         string9s = ['Q3(75%) value in ROI in slice: NaN'];
    string10s = ['Kurtosis value in ROI in slice: NaN'];
    string11s = ['Skewness value in ROI in slice: NaN'];
end

HREP.st2 = uicontrol('parent',HREP.total,...
    'units','norm',...
    'pos',[0.55,0.02,0.4,0.2],...
    'style','text',...
    'string',{string0s,string1s,string2s,string3s,[string5s,' ',string6s],string7s,string8s,string10s,string11s});
% string0s = ['Current Slice: Coronal ',num2str(YDIMS),'(range: 1-',num2str(dims(2)),')'];
% if length(INDS)>0
%     string1s = ['ROI in slice voxel nums: ',num2str(nnz(SELTEMPMAP2))];
%     almat = hdr.mat(1:3,1:3);
%     vsize = [max(abs(almat(1,:))),max(abs(almat(2,:))),max(abs(almat(3,:)))];
%     vols = prod(vsize)*nnz(SELTEMPMAP2);
%     volshow = round(vols);
%     string2s = ['ROI in slice volume(ml): ',num2str(volshow/1000)];
%     string3s = ['min value in ROI in slice: ',num2str(min(SELTEMPMAP(INDS)))];
%     string4s = ['max value in ROI in slice: ',num2str(max(SELTEMPMAP(INDS)))];
%     string5s = ['mean value in ROI in slice: ',num2str(mean(SELTEMPMAP(INDS)))];
%     string6s = ['std : ',num2str(std(SELTEMPMAP(INDS)))];
%     string7s = ['median value in ROI in slice: ',num2str(median(SELTEMPMAP(INDS)))];
%     datsorts = sort(SELTEMPMAP(INDS));
%     string8s = ['Q1(25%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4)))];
%     string9s = ['Q3(75%) value in ROI in slice: ',num2str(datsorts(round(length(datsorts)/4*3)))];
% else
%     string1s = ['ROI in slice voxel nums: 0'];
%     string2s = ['ROI in slice volume(ml): 0'];
%     string3s = ['min value in ROI in slice: NaN'];
%     string4s = ['max value in ROI in slice: NaN'];
%     string5s = ['mean value in ROI in slice: NaN'];
%     string6s = ['std : NaN'];
%     string7s = ['median value in ROI in slice: NaN'];
%     string8s = ['Q1(25%) value in ROI in slice: NaN'];
%     string9s = ['Q3(75%) value in ROI in slice: NaN'];
% end
% HREP.st2 = uicontrol('parent',HREP.total,...
%     'units','norm',...
%     'pos',[0.55,0.02,0.4,0.2],...
%     'style','text',...
%     'string',{string0s,string1s,string2s,string3s,string4s,[string5s,' ',string6s],string7s,string8s,string9s});

INDS = find(SELTEMPMAP2);
slicedat = SELTEMPMAP(INDS);
hist(HREP.SliceAxes,slicedat,1000);
axis(HREP.Axial,'off')
axis(HREP.Sagittal,'off')
axis(HREP.Coronal,'off')
axis(HREP.Sel,'off')
end
function HREP_REP(varargin)
HREP = varargin{3};
dat = varargin{4};
dims = varargin{5};
dat2 = varargin{6};
hdr = HREP.HDR;
indexs = find(dat2);
[ix iy iz] = ind2sub(dims,indexs);
wholedat = dat(indexs);
WholeROIinfo{1,1} = 'Whole ROI nums';
WholeROIinfo{1,2} = length(indexs);
almat = hdr.mat(1:3,1:3);
vsize = [max(abs(almat(1,:))),max(abs(almat(2,:))),max(abs(almat(3,:)))];
WholeROIinfo{2,1} = 'Whole ROI volume(mm3)';
WholeROIinfo{2,2} = prod(vsize)*length(indexs);
WholeROIinfo{3,1} = 'min value in ROI';
WholeROIinfo{3,2} = min(wholedat);
WholeROIinfo{4,1} = 'max value in ROI';
WholeROIinfo{4,2} = max(wholedat);
WholeROIinfo{5,1} = 'mean value in ROI';
WholeROIinfo{5,2} = mean(wholedat);
WholeROIinfo{6,1} = 'std value in ROI';
WholeROIinfo{6,2} = std(wholedat);
WholeROIinfo{7,1} = 'median value in ROI';
WholeROIinfo{7,2} = median(wholedat);
datsort = sort(wholedat);
WholeROIinfo{8,1} = 'Q1(25%) value in ROI';
WholeROIinfo{8,2} = datsort(round(length(datsort)/4));
WholeROIinfo{9,1} = 'Q3(75%) value in ROI';
WholeROIinfo{9,2} = datsort(round(length(datsort)/4*3));
WholeROIinfo{10,1} = 'kurtosis value in ROI';
WholeROIinfo{10,2} = kurtosis(wholedat);
WholeROIinfo{11,1} = 'Skewness value in ROI';
WholeROIinfo{11,2} = skewness(wholedat);
Outs = HREP.OUT;
save([Outs,'WholeROIinformation.mat'],'WholeROIinfo','wholedat');
SagittalROIinfo{1,1} = 'Slice Nums';
SagittalROIinfo{1,2} = 'Slice ROI nums';
SagittalROIinfo{1,3} = 'Slice ROI volume(mm3)';
SagittalROIinfo{1,4} = 'min value';
SagittalROIinfo{1,5} = 'max value';
SagittalROIinfo{1,6} = 'mean value';
SagittalROIinfo{1,7} = 'std value';
SagittalROIinfo{1,8} = 'median value';
SagittalROIinfo{1,9} = 'Q1(25%) value';
SagittalROIinfo{1,10} = 'Q3(75%) value';
SagittalROIinfo{1,11} = 'kurtosis value';
SagittalROIinfo{1,12} = 'Skewness value';
ixsort = unique(sort(ix));
for i = 1:length(ixsort)
    TEMPMASK = squeeze(dat2(ixsort(i),:,:));
    TEMPDAT = squeeze(dat(ixsort(i),:,:));
    INDEXSTEMP = find(TEMPMASK);
    SagittalROIdat{i} = TEMPDAT(INDEXSTEMP);
    SagittalROIinfo{i+1,1} = ixsort(i);
    SagittalROIinfo{i+1,2} =  nnz(TEMPMASK);
    SagittalROIinfo{i+1,3} = prod(vsize)*nnz(TEMPMASK);
    SagittalROIinfo{i+1,4} = min(TEMPDAT(INDEXSTEMP));
    SagittalROIinfo{i+1,5} = max(TEMPDAT(INDEXSTEMP));
    SagittalROIinfo{i+1,6} = mean(TEMPDAT(INDEXSTEMP));
    SagittalROIinfo{i+1,7} = std(TEMPDAT(INDEXSTEMP));
    SagittalROIinfo{i+1,8} = median(TEMPDAT(INDEXSTEMP));
    datsort0 = sort(TEMPDAT(INDEXSTEMP));
    if length(datsort0)>4
        SagittalROIinfo{i+1,9} = datsort0(round(length(datsort0)/4));
        SagittalROIinfo{i+1,10} = datsort0(round(length(datsort0)/4*3));
        SagittalROIinfo{i+1,11} = kurtosis(TEMPDAT);
        SagittalROIinfo{i+1,12} = skewness(TEMPDAT);
    end
end
CornoralROIinfo{1,1} = 'Slice Nums';
CornoralROIinfo{1,2} = 'Slice ROI nums';
CornoralROIinfo{1,3} = 'Slice ROI volume(mm3)';
CornoralROIinfo{1,4} = 'min value';
CornoralROIinfo{1,5} = 'max value';
CornoralROIinfo{1,6} = 'mean value';
CornoralROIinfo{1,7} = 'std value';
CornoralROIinfo{1,8} = 'median value';
CornoralROIinfo{1,9} = 'Q1(25%) value';
CornoralROIinfo{1,10} = 'Q3(75%) value';
CornoralROIinfo{1,11} = 'Kurtosis value';
CornoralROIinfo{1,12} = 'Skewness value';
iysort = unique(sort(iy));
for i = 1:length(iysort)
    TEMPMASK = squeeze(dat2(:,iysort(i),:));
    TEMPDAT = squeeze(dat(:,iysort(i),:));
    INDEXSTEMP = find(TEMPMASK);
    CornoralROIdat{i} = TEMPDAT(INDEXSTEMP);
    CornoralROIinfo{i+1,1} = iysort(i);
    CornoralROIinfo{i+1,2} =  nnz(TEMPMASK);
    CornoralROIinfo{i+1,3} = prod(vsize)*nnz(TEMPMASK);
    CornoralROIinfo{i+1,4} = min(TEMPDAT(INDEXSTEMP));
    CornoralROIinfo{i+1,5} = max(TEMPDAT(INDEXSTEMP));
    CornoralROIinfo{i+1,6} = mean(TEMPDAT(INDEXSTEMP));
    CornoralROIinfo{i+1,7} = std(TEMPDAT(INDEXSTEMP));
    CornoralROIinfo{i+1,8} = median(TEMPDAT(INDEXSTEMP));
    datsort0 = sort(TEMPDAT(INDEXSTEMP));
    if length(datsort0)>4
        CornoralROIinfo{i+1,9} = datsort0(round(length(datsort0)/4));
        CornoralROIinfo{i+1,10} = datsort0(round(length(datsort0)/4*3));
        CornoralROIinfo{i+1,11} = kurtosis(TEMPDAT);
        CornoralROIinfo{i+1,12} = skewness(TEMPDAT);
    end
end
AxialROIinfo{1,1} = 'Slice Nums';
AxialROIinfo{1,2} = 'Slice ROI nums';
AxialROIinfo{1,3} = 'Slice ROI volume(mm3)';
AxialROIinfo{1,4} = 'min value';
AxialROIinfo{1,5} = 'max value';
AxialROIinfo{1,6} = 'mean value';
AxialROIinfo{1,7} = 'std value';
AxialROIinfo{1,8} = 'median value';
AxialROIinfo{1,9} = 'Q1(25%) value';
AxialROIinfo{1,10} = 'Q3(75%) value';
AxialROIinfo{1,11} = 'Kurtosis value';
AxialROIinfo{1,12} = 'Skewness value';
izsort = unique(sort(iz));
for i = 1:length(izsort)
    TEMPMASK = squeeze(dat2(:,:,izsort(i)));
    TEMPDAT = squeeze(dat(:,:,izsort(i)));
    INDEXSTEMP = find(TEMPMASK);
    AxialROIdat{i} = TEMPDAT(INDEXSTEMP);
    AxialROIinfo{i+1,1} = izsort(i);
    AxialROIinfo{i+1,2} =  nnz(TEMPMASK);
    AxialROIinfo{i+1,3} = prod(vsize)* nnz(TEMPMASK);
    AxialROIinfo{i+1,4} = min(TEMPDAT(INDEXSTEMP));
    AxialROIinfo{i+1,5} = max(TEMPDAT(INDEXSTEMP));
    AxialROIinfo{i+1,6} = mean(TEMPDAT(INDEXSTEMP));
    AxialROIinfo{i+1,7} = std(TEMPDAT(INDEXSTEMP));
    AxialROIinfo{i+1,8} = median(TEMPDAT(INDEXSTEMP));
    datsort0 = sort(TEMPDAT(INDEXSTEMP));
    if length(datsort0)>4
        AxialROIinfo{i+1,9} = datsort0(round(length(datsort0)/4));
        AxialROIinfo{i+1,10} = datsort0(round(length(datsort0)/4*3));
        AxialROIinfo{i+1,11} = kurtosis(TEMPDAT);
        AxialROIinfo{i+1,12} = skewness(TEMPDAT);
    end
end
save([Outs,'AxialROIinformation.mat'],'AxialROIinfo');
save([Outs,'CornoralROIinformation.mat'],'CornoralROIinfo');
save([Outs,'SagittalROIinformation.mat'],'SagittalROIinfo');
save([Outs,'AxialROIDAT.mat'],'AxialROIdat');
save([Outs,'CornoralROIDAT.mat'],'CornoralROIdat');
save([Outs,'SagittalROIDAT.mat'],'SagittalROIdat');
uiwait(msgbox('Report Sucessfully!'))
end
function HREP_FINISH(varargin)
HREP = varargin{3};
close(HREP.total);
clear HREP;
HSIDR_en;
end
