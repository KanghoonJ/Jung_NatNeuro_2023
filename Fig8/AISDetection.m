% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023

% Loading images and normalization
img488=loadtiff(img_Gephyrin); % Gephyrin Channel
img561=loadtiff(img_ChC); % ChC Channel
img637=loadtiff(img_AnkG); % AnkG Channel
sz=size(img561);

%% PART1: Gephyrin Puncta DETECTION
y = sort(img488(:), 'descend');
idx=round(length(y)*pixelL); % One-sigma in normal distribution
vs=double(y(idx));
med_raw=double(median(y));
normimg488=double((img488-med_raw))./vs;
PM488nm=[];
for z=zi:zf
    s488=normimg488(:,:,z);
    [pstruct, mask, imgLM, imgLoG] = pointSourceDetection(s488, 1.5);
    y=pstruct.y_init;x=pstruct.x_init;
    pointmask=[];pointsmask=zeros(sz(1),sz(2));
    for i=1:length(y)
        pointsmask(y(i),x(i))=1;
    end
    PM488nm(:,:,z)=pointsmask;
end
clearvars img488

%% PART2: SEGMENTATION
tic
for z=zi:zf
    %% Segmentation: 561
    img561z=img561(:,:,z);
    T1 = adaptthresh(img561z,0,'NeighborhoodSize',15);
    timg561= imbinarize(img561z,T1);
    M=mean(img561z,'all');S=std(single(img561z),[],'all');
    [B561,L561] = bwboundaries(timg561); % boundaries of single image (zpos)

    for i=1:length(B561)
        l(i)=length(B561{i});
    end
    lst=find(l>15);

    newL=zeros(sz(1),sz(2)); k=1;
    for i=1:length(lst)
        tmsk=(L561==lst(i));
        [r,c]=find(L561==lst(i));
        if (length(r)>50)  && (mean(img561z(r,c),"all")>M+S*2)
            %     if (mean(img561z(r,c),"all")>M+S*2)
            newL=newL+tmsk.*k;
            k=k+1;
        end
    end
    L561stack(:,:,z)=newL;

    %% Segmentation: 637
    img637z=img637(:,:,z);
    T2 = adaptthresh(img637z,0.08,'NeighborhoodSize',19);
    timg637= imbinarize(img637z,T2);
    M=mean(img637z,'all');S=std(single(img637z),[],'all');
    [B637,L637] = bwboundaries(timg637); % boundaries of single image (zpos)

    for i=1:length(B637)
        l(i)=length(B637{i});
    end
    lst=find(l>15);

    newL=zeros(sz(1),sz(2)); k=1;
    for i=1:length(lst)
        tmsk=(L637==lst(i));
        [r,c]=find(L637==lst(i));
        if (length(r)>50) && (mean(img637z(r,c),"all")>M)
            %     if (mean(img637z(r,c),"all")>M+S*2)
            newL=newL+tmsk.*k;
            k=k+1;
        end
    end
    L637stack(:,:,z)=newL;
end
toc
clearvars img637z img561z
tic
%% Part3: Merging & Measure SSEs
[LM561]=mergeLabelM(L561stack);
[LM561]=RenumberLM(LM561);
[LM637]=mergeLabelM(L637stack);
[LM637]=RenumberLM(LM637);
save('Results_Detection.mat','LM637','LM561','PM488nm','L637stack');

clearvars L637stack
%Associate ChC and Gephyrin for each AIS
lst=unique(LM637);idChC={};idAIS=[];

%initialization of maps
ChCmap=zeros(sz(1),sz(2));
AISmap=ChCmap;
GepAISmap=ChCmap;
GepComap=ChCmap;
CM=[];

for i=2:length(lst)
    id=lst(i); % id of AIS to investigate
    idM=(LM637==id);
    zid=squeeze(sum(sum(idM,2),1));
    v=find(zid);

    % Filter by the size of ROI
    if sum(idM,'all')>300

        %measure L
        [L(id,1), CM(id,:)]=measureLAIS(idM,img637,min(v),max(v));
        L(id,1)=L(id,1).*0.156;
        Lrev(id,1)=sqrt(L(id,1)^2+(max(v)-min(v))^2); % Revised L_AIS

        if Lrev(id,1)>=10
            lstChC=[];s1=0;s2=0;
            for z=zi:zf
                if sum(idM(:,:,z),'all')
                    msk2=PM488nm(:,:,z).*logical(idM(:,:,z)); % All on AIS
                    s2=s2+sum(double(normimg488(:,:,z)).*msk2,'all');
                    ChCAISmsk=idM(:,:,z).*LM561(:,:,z);

                    if length(unique(ChCAISmsk))>1
                        lstChC=[lstChC; unique(ChCAISmsk)]; % sort associated ChC ROIs

                        %% Calculate postSSE
                        msk1=PM488nm(:,:,z).*logical(ChCAISmsk); % only on AIS-ChC
                        s1=s1+sum(double(normimg488(:,:,z)).*msk1,'all');

                        GepComap=GepComap+msk1;
                    end
                    GepAISmap=GepAISmap+msk2;
                end
            end
            if s1==0 && s2==0
                postSSE(id)=0;
            else        postSSE(id)=s1/s2;
            end
            GephCAIS(id)=s1; GephAIS(id)=s2;

            idCs=unique(lstChC);idChC{id}=idCs;
            if length(idCs)>1
                idAIS=[idAIS; id];
                ChCmsk{id}=logical(zeros(sz(1),sz(2),sz(3)));
                for k=2:length(idCs)
                    ChCmsk{id}= logical(ChCmsk{id}+(LM561==idCs(k)));
                end
                ChCmap=ChCmap+max(ChCmsk{id},[],3)*id;
                AISmap=AISmap+max(double(idM),[],3)*id;
                AISmsk{id}=double(idM);
            end
        end
    end
end

idd=find(Lrev>=10);
%% Calculate preSSE
[preSSE,L_AIS,L_ChC,L_AISChC,A_AISChC]=measurePreSSE(idAIS,ChCmsk,AISmsk,img561,img637,zi,zf);
preSSE(end+1:length(postSSE))=0;

Dist=[];
CM=CM.*0.156;
%% Calculate DfromL1
for j=1:size(CM,1)
    cm=CM(j,:);
    D=pdist2(lin, cm);
    [tmp,idx]=min(D);
    nearst=lin(idx,:);
    if (cm(2)-nearst(2))<0
        tmp=tmp*-1;
    end
    Dist=[Dist;tmp];
end
toc


RESall=[idd CM(idd,:) L(idd) Lrev(idd) preSSE(idd)' postSSE(idd)' Dist(idd) GephCAIS(idd)' GephAIS(idd)'];
saveastiff(AISmap,'DetectionMap_AIS.tif')
saveastiff(ChCmap,'DetectionMap_ChC.tif')
save('Results_Analysis.mat','RESall','ChCmap','AISmap','GepAISmap','GepComap','idAIS');