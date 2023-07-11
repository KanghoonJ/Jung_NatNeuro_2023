%% Cumulative probability of Correlations between ChC and M2 neurons
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023
Base_folder = 'C:\Users\jungk\Google Drive\[Kwon Lab @ MPFI]\Project #3 - ChC\Manuscript\Working manuscript\Nat Neurosci version\Editing\Code_KJ'
cd(Base_folder)
cd('Fig_data\ChC_fG6s')
Data = xlsread('ChC_Pyr_Corr.xlsx');
t1_move_data = Data(~isnan(Data(:,1)),1);
t1_move_cdf = gen_cdf(t1_move_data);   
t7_move_data = Data(~isnan(Data(:,2)),2);
t7_move_cdf = gen_cdf(t7_move_data);   
t1_rest_data = Data(~isnan(Data(:,6)),6);
t1_rest_cdf = gen_cdf(t1_rest_data);   
t7_rest_data = Data(~isnan(Data(:,7)),7);
t7_rest_cdf = gen_cdf(t7_rest_data);   

figure, 
set(gcf,'color','w','position',[100 100 400 310])
plot(1-t1_move_cdf.y,t1_move_cdf.x,'m'); hold on;
plot(1-t1_rest_cdf.y,t1_rest_cdf.x,'k'); hold on;
line([0 1],[0 0],'color','k','LineStyle','--'); hold on;
set(gca,'tickdir','out','box','off')
xlabel('Probability')
ylabel('Corr')
ylim([-0.8 1.00])
title('Early Learning')

figure, 
set(gcf,'color','w','position',[100 100 400 310])
plot(1-t7_move_cdf.y,t7_move_cdf.x,'m'); hold on;
plot(1-t7_rest_cdf.y,t7_rest_cdf.x,'k'); hold on;
line([0 1],[0 0],'color','k','LineStyle','--'); hold on;
set(gca,'tickdir','out','box','off')
ylim([-0.8 1.00])
xlabel('Probability')
ylabel('Corr')
title('Late Learning')

