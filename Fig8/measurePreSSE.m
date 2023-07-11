function [preSSE,L_AIS,L_ChC,L_AISChC,A_AISChC]=measurePreSSE(idAIS,ChCmsk,AISmsk,img561,img637,zi,zf)
% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023

warning('off')
sz=size(img561);
boxsz=5;
for i=1:length(idAIS)
    id=idAIS(i);
    mChC=ChCmsk{id}; mAIS=AISmsk{id};

    %Make projected 561/637 images
    proj561=zeros(sz(1),sz(2));proj637=zeros(sz(1),sz(2));
    for z=zi:zf
        proj561=max(double(mChC(:,:,z)).*double(img561(:,:,z)),proj561);
        proj637=max(double(mAIS(:,:,z)).*double(img637(:,:,z)),proj637);
    end
    proj637msk=max(double(mAIS),[],3);
    proj561msk=max(double(mChC),[],3);

    %% Rotation
    bb=regionprops(proj637msk+proj561msk, 'BoundingBox');
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
    proj561seg=proj561(y1b:y2b,x1b:x2b);
    proj561pad=padarray(proj561seg,[round(pdszb-((y2b-y1b))) round(pdszb-(x2b-x1b))],0);
    proj561pad=imrotate(proj561pad,ang,'bilinear','crop'); %Rotation
    proj561pad(proj561pad==0)=NaN;
    proj637seg=proj637(y1b:y2b,x1b:x2b);
    proj637pad=padarray(proj637seg,[round(pdszb-((y2b-y1b))) round(pdszb-(x2b-x1b))],0);
    proj637pad=imrotate(proj637pad,ang,'bilinear','crop'); %Rotation
    proj637pad(proj637pad==0)=NaN;

    % Retrieve length info
    prof561=mean(proj561pad,2,'omitnan');
    prof561=prof561/max(prof561);
    idx=find(prof561>0.5);
    ChCid=[idx(1) idx(end)];

    prof637=mean(proj637pad,2,'omitnan');
    prof637=prof637/max(prof637);
    idx=find(prof637>0.5);
    AISid=[idx(1) idx(end)];

    L_AIS(id)=AISid(2)-AISid(1);
    L_ChC(id)=ChCid(2)-ChCid(1);
    ll=min(ChCid(2),AISid(2))-max(ChCid(1),AISid(1));
    if ll<0
        L_AISChC(id)=0;
    else
        L_AISChC(id)=ll;
    end
    
    A_AISChC(id)=sum(proj561msk.*proj637msk,"all");
    preSSE(id)=A_AISChC(id)*L_AISChC(id)/L_AIS(id)/L_ChC(id);

%     % Measure AIS position
%     [y,x]=find(proj637msk);
%     [xpos(id,1), xpos(id,2)]=centroid(polyshape(x,y));
    
end