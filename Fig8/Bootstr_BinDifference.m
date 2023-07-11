% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023

bootnum=3000;
figure();
P1=[];P2=[];P3=[];P4=[];
diff1=[];diff2=[];diff3=[];diff=[];
for kk=1:10
    % (1) PRE
    rawfw=PRE_FW_bin';
    rawwr=PRE_WR_bin';
    edge=Binwidth1;

%     % (2) POST
%     rawfw=POST_FW_bin';
%     rawwr=POST_WR_bin';
%     edge=Binwidth2;

    x=edge(2:end)-(edge(2)-edge(1))/2;
    x=x';

    [bootstat1,bootraw1]=Histogram_subBootStrap(rawfw,rawfw,bootnum);
    [bootstat2,bootraw2]=Histogram_subBootStrap(rawwr,rawwr,bootnum);
    [bootstat3,bootraw3]=Histogram_subBootStrap([rawfw rawwr],[rawfw rawwr],bootnum);
    [bootstat4,bootraw4]=Histogram_subBootStrap(rawfw,rawwr,bootnum);
    p1=[];p2=[];p3=[];p4=[];
    nullgroup=zeros(1,bootnum);
    for j=1:length(x)
        [h,p1(j)]=ttest(nullgroup,bootraw1(j,:));
        [h,p2(j)]=ttest(nullgroup,bootraw2(j,:));
        [h,p3(j)]=ttest(nullgroup,bootraw3(j,:));
        [h,p4(j)]=ttest(nullgroup,bootraw4(j,:));
%             p1(j)=ranksum(nullgroup,bootraw1(j,:));
%             p2(j)=ranksum(nullgroup,bootraw2(j,:));
%             p3(j)=ranksum(nullgroup,bootraw3(j,:));
%             p4(j)=ranksum(nullgroup,bootraw4(j,:));
%             p1(j)=getU(nullgroup,bootraw1(j,:));
%             p2(j)=getU(nullgroup,bootraw2(j,:));
%             p3(j)=getU(nullgroup,bootraw3(j,:));
%             p4(j)=getU(nullgroup,bootraw4(j,:));
    end

    %     %Normalization
    %     bootstat1=bootstat1./sum(bootstat1(:,1),'all');
    %     bootstat2=bootstat2./sum(bootstat2(:,1),'all');
    %     bootstat3=bootstat3./sum(bootstat3(:,1),'all');


    subplot(2,4,1)
    bar(x,bootstat1(:,1),1,'b','FaceAlpha',0.2)
    hold on
    plot(x,bootstat1(:,1),'b','LineWidth',2)
    xlim([edge(1) edge(end)])
    ylim([-0.05 0.1])
    title('in FW')
    ylabel('Probability')

    hold on
    subplot(2,4,2)
    bar(x,bootstat2(:,1),1,'r','FaceAlpha',0.2)
    hold on
    plot(x,bootstat2(:,1),'r','LineWidth',2)
    xlim([edge(1) edge(end)])
    ylim([-0.05 0.1])
    title('in WR')
    ylabel('Probability')

    hold on
    subplot(2,4,3)
    bar(x,bootstat3(:,1),1,'y','FaceAlpha',0.2)
    hold on
    plot(x,bootstat3(:,1),'y','LineWidth',2)
    xlim([edge(1) edge(end)])
    ylim([-0.05 0.1])
    title('shupple in FW+WR')
    ylabel('Probability')

    hold on
    subplot(2,4,4)
    bar(x,bootstat4(:,1),1,'g','FaceAlpha',0.2)
    hold on
    plot(x,bootstat4(:,1),'g','LineWidth',2)
    xlim([edge(1) edge(end)])
    ylim([-0.05 0.1])
    title('WR-FW')
    ylabel('Probability')

    subplot(2,4,5)
    plot(x,p1,'b','LineWidth',2)
    xlim([edge(1) edge(end)])
    ylim([0 1])
    title('in FW')
    ylabel('P-value')

    hold on
    subplot(2,4,6)
    plot(x,p2,'r','LineWidth',2)
    xlim([edge(1) edge(end)])
    ylim([0 1])
    title('in WR')
    ylabel('P-value')

    hold on
    subplot(2,4,7)
    plot(x,p3,'y','LineWidth',2)
    xlim([edge(1) edge(end)])
    ylim([0 1])
    title('shupple in FW+WR')
    ylabel('P-value')

    hold on
    subplot(2,4,8)
    plot(x,p4,'g','LineWidth',2)
    xlim([edge(1) edge(end)])
    ylim([0 1])
    title('WR-FW')
    ylabel('P-value')
    
    diff1=[diff1 bootstat1(:,1)];
    diff2=[diff2 bootstat2(:,1)];
    diff3=[diff3 bootstat3(:,1)];
    diff=[diff bootstat4(:,1)];
    P1=[P1;p1];P2=[P2;p2];P3=[P3;p3];P4=[P4;p4];
end

figure();
hold on
scatter(x,diff,20,'k','filled')
% plot(x,diff,'k','LineWidth',0.5)
b=bar(x,mean(diff,2),1)
b.FaceAlpha=0.5;
b.FaceColor='green';
errorbar(x,mean(diff,2),std(diff,0,2))