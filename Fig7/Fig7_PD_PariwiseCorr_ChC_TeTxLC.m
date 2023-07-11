%% Pairwise correlation of the activity of pairs of neurons as a function of difference in their preferred directions for ChC-TeTxLC manipulation
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023

clear all
close all
% Base_folder 
cd(Base_folder)
% Load data
load('Fig_data\ChC_TeTxLC\Fig_pairwise_corr_table_db.mat')
ROI_TDays = [1,7];
for(group = 1:2)
    if(group==1)
        fig_title = 'ChC-TeTxLC';                
    elseif(group==2)        
        fig_title = 'ChC Control';                
    end    
    for(nTDay=1:numel(ROI_TDays))
        TDay = ROI_TDays(nTDay);
        Field = ['TDay' num2str(TDay)]; 
        switch Field
            case 'TDay1'            
                if(group==1)
                    col = [255 163 255]/255; % ChC-TeTxLC                    
                elseif(group==2)
                    col = [188 190 192]/255; % ChC Control
                end                
            case 'TDay7'
                if(group==1)
                    col = [179 9 179]/255; % ChC-TeTxLC   
                elseif(group==2)
                    col = [65 65 66]/255; % ChC Control
                end    
        end        
        Conc_PairwiseCorr_table = Pairwise_Corr_table_db{group,TDay}.table;
        edges = Pairwise_Corr_table_db{group,TDay}.edges;
        x = abs(Conc_PairwiseCorr_table.Delta_PD); % Delta PD   
        y = Conc_PairwiseCorr_table.PairwiseCorr; % Pairwise Correlation
        Delta_PD_PairCorr = Y_averaging_wrt_X_edge(x,y, edges); 
        if(TDay==1)
            Baseline = Delta_PD_PairCorr.Y(1);
        end

        figure(group), 
        set(gcf,'color','w','position',[600 310 250 290])
        shadedErrorBar(Delta_PD_PairCorr.X, Delta_PD_PairCorr.Y/Baseline, Delta_PD_PairCorr.Y_sem./Baseline,'lineprops',{'color',col}); hold on;
        set(gca,'xlim',[-5 185],'ylim',[0, 1.3],'box','off','xtick',[0:45:180],'tickdir','out')
        xlabel('\Delta PD')
        ylabel('Pairwise correlation (norm)')
        title(fig_title);
    end
end
