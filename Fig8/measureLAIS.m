function [L_AIS, xpos]=measureLAIS(idM,img637,zi,zf)
% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023

warning('off')
sz=size(img637);
boxsz=5;
mAIS=idM;

%Make projected 561/637 images
proj637=zeros(sz(1),sz(2));
for z=zi:zf
    proj637=max(double(mAIS(:,:,z)).*double(img637(:,:,z)),proj637);
end
proj637msk=max(double(mAIS),[],3);

% Measure AIS position
[y,x]=find(proj637msk);
[xpos(1), xpos(2)]=centroid(polyshape(x,y));

%% Rotation
bb=regionprops(proj637msk, 'BoundingBox');
bbb=bb.BoundingBox;

% Set the ROI
y1b=(floor(bbb(2))-boxsz); x1b=(floor(bbb(1))-boxsz);
if y1b<1 y1b=1; end
if x1b<1 x1b=1; end

y2b=(ceil(bbb(2)+bbb(4))+boxsz);x2b=(ceil(bbb(1)+bbb(3))+boxsz);
if y2b>sz(1) y2b=sz(1); end
if x2b>sz(2) x2b=sz(2); end

% Find angle from AIS
mask637=proj637msk(y1b:y2b,x1b:x2b);
mass1=sum(mask637(1:ceil((y2b-y1b)/2),:),1,'omitnan');
mass2=sum(mask637(ceil((y2b-y1b)/2)+1:end,:),1,'omitnan');
dl=((y2b-y1b)-2*boxsz)/2;
dp=sum([1:length(mass1)].*mass1)/sum(mass1)-sum([1:length(mass2)].*mass2)/sum(mass2);
ang=rad2deg(atan(dp/dl));
if isnan(ang)
    ang=-90;
end

% Rotate
pdszb=(sqrt(((y2b-y1b))^2+((x2b-x1b))^2));
proj637seg=proj637(y1b:y2b,x1b:x2b);
proj637pad=padarray(proj637seg,[round(pdszb-((y2b-y1b))) round(pdszb-(x2b-x1b))],0);
proj637pad=imrotate(proj637pad,ang,'bilinear','crop'); %Rotation
proj637pad(proj637pad==0)=NaN;

% Retrieve length info
prof637=mean(proj637pad,2,'omitnan');
prof637=prof637/max(prof637);
idx=find(prof637>0.5);
AISid=[idx(1) idx(end)];

L_AIS=AISid(2)-AISid(1);