% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023

bootnum=3000;
%% (1) PRE
foldchng1=[];pval1=[];foldchngnull1=[];
for kk=1:10
    rawfw=PRE_FW_bin_rng';
    rawwr=PRE_WR_bin_rng';
    %     edge=Binwidth1;
    %     x=edge(2:end)-(edge(2)-edge(1))/2;
    %     x=x';
    x=1:3;
    [bootstat1,bootraw1]=Histogram_FoldBootStrap(rawfw,rawwr,bootnum);
    [nullstat1,nullgroup]=Histogram_FoldBootStrap([rawfw rawwr],[rawfw rawwr],bootnum);
    p1=[];
%     nullgroup=zeros(1,bootnum);
    for j=1:length(x)
        [h,p1(j)]=ttest(nullgroup(j,:),bootraw1(j,:));
    end
    foldchng1=[foldchng1 bootstat1(:,1)];
    foldchngnull1=[foldchngnull1 nullstat1(:,1)];
    pval1=[pval1; p1];
end
foldchng1=foldchng1.*100;
foldchngnull1=foldchngnull1.*100;
figure();

plot(x,foldchng1,'g')
hold on
b1=bar(x,mean(foldchng1,2),0.6);
b1.FaceAlpha=0.5;
b1.FaceColor='green';
hold on
errorbar(x,mean(foldchng1,2),std(foldchng1,0,2))
hold on
plot(x,foldchngnull1,'k')
hold on
b2=bar(x,mean(foldchngnull1,2),0.6);
b2.FaceAlpha=0.5;
b2.FaceColor='black';
hold on
errorbar(x,mean(foldchngnull1,2),std(foldchngnull1,0,2))

%% (2) POST
foldchng2=[];pval2=[];foldchngnull2=[];
for kk=1:10
    rawfw=POST_FW_bin_rng';
    rawwr=POST_WR_bin_rng';
    %     edge=Binwidth2;
    %     x=edge(2:end)-(edge(2)-edge(1))/2;
    %     x=x';
    x=1:3;
    [bootstat2,bootraw2]=Histogram_FoldBootStrap(rawfw,rawwr,bootnum);
    [nullstat2,nullgroup]=Histogram_FoldBootStrap([rawfw rawwr],[rawfw rawwr],bootnum);
    p2=[];
%     nullgroup=zeros(1,bootnum);
    for j=1:length(x)
        [h,p2(j)]=ttest(nullgroup(j,:),bootraw2(j,:));
    end
    pval2=[pval2; p2];
    foldchng2=[foldchng2 bootstat2(:,1)];
    foldchngnull2=[foldchngnull2 nullstat2(:,1)];
end
foldchng2=foldchng2.*100;
foldchngnull2=foldchngnull2.*100;
figure();
plot(x,foldchng2,'g')
hold on
b3=bar(x,mean(foldchng2,2),0.6);
b3.FaceAlpha=0.5;
b3.FaceColor='green';
hold on
errorbar(x,mean(foldchng2,2),std(foldchng2,0,2))
hold on
plot(x,foldchngnull2,'k')
hold on
b4=bar(x,mean(foldchngnull2,2),0.6);
b4.FaceAlpha=0.5;
b4.FaceColor='black';
hold on
errorbar(x,mean(foldchngnull2,2),std(foldchngnull2,0,2))