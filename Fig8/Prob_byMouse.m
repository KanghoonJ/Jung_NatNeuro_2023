% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023
mousenumFW=max(RES1(:,1));
mousenumWR=max(RES2(:,1));
figure();
for i=1:mousenumFW
    subplot(2,3,i)
    b=bar(Binwidth1(2:end),PRE_FW_bin(i,:),1)
    b.FaceAlpha=0.5;
    b.FaceColor='k';
    b.LineStyle='none';
    ylabel('Probability')
    xlim([Binwidth1(2)-Bin1/2 Binwidth1(end)])
    ylim([0 0.75])
    title(['PRE FW ' num2str(i)])
end

figure();
for i=1:mousenumFW
    subplot(2,3,i)
    b=bar(Binwidth2(2:end),POST_FW_bin(i,:),1)
    b.FaceAlpha=0.5;
    b.FaceColor='k';
    b.LineStyle='none';
    ylabel('Probability')
    xlim([Binwidth2(2)-Bin2/2 Binwidth2(end)])
    ylim([0 0.75])
    title(['POST FW ' num2str(i)])
end

figure();
for i=1:mousenumWR
    subplot(2,3,i)
    b=bar(Binwidth1(2:end),PRE_WR_bin(i,:),1)
    b.FaceAlpha=0.5;
    b.FaceColor='g';
    b.LineStyle='none';
    ylabel('Probability')
    xlim([Binwidth1(2)-Bin1/2 Binwidth1(end)])
    ylim([0 0.75])
    title(['PRE WR ' num2str(i)])
end

figure();
for i=1:mousenumWR
    subplot(2,3,i)
    b=bar(Binwidth2(2:end),POST_WR_bin(i,:),1)
    b.FaceAlpha=0.5;
    b.FaceColor='g';
    b.LineStyle='none';
    ylabel('Probability')
    xlim([Binwidth2(2)-Bin2/2 Binwidth2(end)])
    ylim([0 0.75])
    title(['POST WR ' num2str(i)])
end