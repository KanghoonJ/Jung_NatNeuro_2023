% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023

edge=0:25:250; bw=edge(2)-edge(1);
idx=find(RES1(:,8)>0);
RES=RES1(idx,:);
precolnum=8;
postcolnum=9;
distcolnum=10;

N=[]; mPreAll=[];mPostAll=[];sPreAll=[];sPostAll=[];
for i=1:max(RES(:,1))
    id=(RES(:,1)==i);
    tmpRES=RES(id,:);
    pre=tmpRES(:,precolnum);
    post=tmpRES(:,postcolnum);
    d=tmpRES(:,distcolnum);
    n=[]; mPre=[];mPost=[];sPre=[];sPost=[];
    for j=1:length(edge)-1
        idx=logical((d>=edge(j)).*(d<edge(j+1)));
        n=[n sum(idx)];
        mPre=[mPre mean(pre(idx),'omitnan')];
        mPost=[mPost mean(post(idx),'omitnan')];
        sPre=[sPre std(pre(idx),'omitnan')];
        sPost=[sPost std(post(idx),'omitnan')];
    end

    mPreAll=[mPreAll; mPre];
    mPostAll=[mPostAll; mPost];
    sPreAll=[sPreAll; sPre];
    sPostAll=[sPostAll; sPost];
    N=[N; n];
end
mPreAllFW=mPreAll;
mPostAllFW=mPostAll;
sPreAllFW=sPreAll;
sPostAllFW=sPostAll;
NFW=N;

idx=find(RES2(:,8)>0);
RES=RES2(idx,:);
N=[]; mPreAll=[];mPostAll=[];sPreAll=[];sPostAll=[];
for i=1:max(RES(:,1))
    id=(RES(:,1)==i);
    tmpRES=RES(id,:);
    pre=tmpRES(:,precolnum);
    post=tmpRES(:,postcolnum);
    d=tmpRES(:,distcolnum);
    n=[]; mPre=[];mPost=[];sPre=[];sPost=[];
    for j=1:length(edge)-1
        idx=logical((d>=edge(j)).*(d<edge(j+1)));
        n=[n sum(idx)];
        mPre=[mPre mean(pre(idx),'omitnan')];
        mPost=[mPost mean(post(idx),'omitnan')];
        sPre=[sPre std(pre(idx),'omitnan')];
        sPost=[sPost std(post(idx),'omitnan')];
    end

    mPreAll=[mPreAll; mPre];
    mPostAll=[mPostAll; mPost];
    sPreAll=[sPreAll; sPre];
    sPostAll=[sPostAll; sPost];
    N=[N; n];
end

mPreAllWR=mPreAll;
mPostAllWR=mPostAll;
sPreAllWR=sPreAll;
sPostAllWR=sPostAll;
NWR=N;


figure();
b1=bar(edge(2:end)-bw/2,mean(mPreAllFW,1,'omitnan'),1)
b1.FaceColor='red';
b1.FaceAlpha=0.5;
hold on
e1=errorbar(edge(2:end)-bw/2,mean(mPreAllFW,1,'omitnan'),std(mPreAllFW,1,'omitnan'))
e1.Color='red';
b2=bar(edge(2:end)-bw/2,mean(mPreAllWR,1,'omitnan'),1)
b2.FaceColor='yellow';
b2.FaceAlpha=0.5;
e2=errorbar(edge(2:end)-bw/2,mean(mPreAllWR,1,'omitnan'),std(mPreAllWR,1,'omitnan'))
e2.Color='yellow';
xticks(edge)
xlabel('PreSSE')

figure();
b1=bar(edge(2:end)-bw/2,mean(mPostAllFW,1,'omitnan'),1)
b1.FaceColor='red';
b1.FaceAlpha=0.5;
hold on
e1=errorbar(edge(2:end)-bw/2,mean(mPostAllFW,1,'omitnan'),std(mPostAllFW,1,'omitnan'))
e1.Color='red';
b2=bar(edge(2:end)-bw/2,mean(mPostAllWR,1,'omitnan'),1)
b2.FaceColor='yellow';
b2.FaceAlpha=0.5;
e2=errorbar(edge(2:end)-bw/2,mean(mPostAllWR,1,'omitnan'),std(mPostAllWR,1,'omitnan'))
e2.Color='yellow';
xticks(edge)
xlabel('PostSSE')

NFWnm=NFW./(sum(NFW,2,'omitnan'));
NWRnm=NWR./(sum(NWR,2,'omitnan'));

figure();
b1=bar(edge(2:end)-bw/2,mean(NFWnm,1,'omitnan'),1)
b1.FaceColor='red';
b1.FaceAlpha=0.5;
hold on
e1=errorbar(edge(2:end)-bw/2,mean(NFWnm,1,'omitnan'),std(NFWnm,1,'omitnan'))
e1.Color='red';
b2=bar(edge(2:end)-bw/2,mean(NWRnm,1,'omitnan'),1)
b2.FaceColor='yellow';
b2.FaceAlpha=0.5;
e2=errorbar(edge(2:end)-bw/2,mean(NWRnm,1,'omitnan'),std(NWRnm,1,'omitnan'))
e2.Color='yellow';
xticks(edge)
xlabel('Distribution')


d1=RES1(:,distcolnum);d2=RES2(:,distcolnum);
PreP=[];PostP=[];NP=[];PreU=[];PostU=[];
for j=1:length(edge)-1
    idx1=logical((d1>=edge(j)).*(d1<edge(j+1)));
    idx2=logical((d2>=edge(j)).*(d2<edge(j+1)));

%     PreP=[PreP ranksum(RES1(idx1,5),RES2(idx2,5))];
%     PostP=[PostP ranksum(RES1(idx1,14),RES2(idx2,14))];
    PreP=[PreP ranksum(mPreAllFW(:,j),mPreAllWR(:,j))];
    PostP=[PostP ranksum(mPostAllFW(:,j),mPostAllWR(:,j))];
    PreU=[PreU getU(mPreAllFW(:,j),mPreAllWR(:,j))];
    PostU=[PostU getU(mPostAllFW(:,j),mPostAllWR(:,j))];
%     [h,p]=ttest2(mPreAllFW(:,j),mPreAllWR(:,j));
%     PreP=[PreP p];
%     [h,p]=ttest2(mPostAllFW(:,j),mPostAllWR(:,j));
%     PostP=[PostP p];

    NP=[NP ranksum(NFWnm(:,j),NWRnm(:,j))]
end
