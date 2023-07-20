%% Pairwise correlation of the activity of pairs of neurons as a function of difference in their preferred directions for ChC-DREADD manipulation
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023

clear all
close all
Base_folder = pwd; % working directory which contains folders for codes and figure dataset
cd(Base_folder)
load('Fig_data\ChC_DREADD\Fig_pairwise_corr_table_db.mat')
ROI_TDays = [7,8,9];
for(nTDay=1:numel(ROI_TDays))
    TDay = ROI_TDays(nTDay);
    Field = ['TDay' num2str(TDay)]; 
    switch Field
        case 'TDay7'
            col = 'k';
        case 'TDay8'
            col = 'r';        
        case 'TDay9'
            col = [0.5 0.5 0.5];
    end

    Conc_PairwiseCorr_table = Pairwise_Corr_table_db{TDay}.table;
    edges = Pairwise_Corr_table_db{TDay}.edges;

    x = abs(Conc_PairwiseCorr_table.Delta_PD); % Delta PD   
    y = Conc_PairwiseCorr_table.PairwiseCorr; % Pairwise Correlation
    Delta_PD_PairCorr = Y_averaging_wrt_X_edge(x,y, edges); 
    if(TDay==7)
        Baseline = Delta_PD_PairCorr.Y(1);
    end
    
    figure(1), 
    set(gcf,'color','w','position',[600 310 250 290])
    shadedErrorBar(Delta_PD_PairCorr.X, Delta_PD_PairCorr.Y/Baseline, Delta_PD_PairCorr.Y_sem./Baseline,'lineprops',{'color',col}); hold on;
    set(gca,'xlim',[-5 185],'ylim',[0 1.3],'box','off','xtick',[0:45:180],'tickdir','out')
    xlabel('\Delta PD')
    ylabel('Pairwise correlation (norm)')
    title(['Group']);
end
