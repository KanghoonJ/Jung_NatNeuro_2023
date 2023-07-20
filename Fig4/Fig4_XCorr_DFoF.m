%% Heatmap of DFoF for PV-INs and PV-TeTxLC M2 popultation
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023
close all
clear all
Base_folder = pwd; % working directory which contains folders for codes and figure dataset
cd(Base_folder)
load('Fig_data\ChC_TeTxLC\Fig_XCorr_DFoF_db.mat')

for(group = 1:2)
     if(group==1)
        fig_title = 'ChCs';        
    elseif(group==2)        
        fig_title = 'ChC-TeTxLC';        
    end        
    t_lag = Fig_XCorr_DFoF_db{group}.x; % Time from movement onset
    Conc_X_Corr_DFoF.Sorted_Y = Fig_XCorr_DFoF_db{group}.y;
    
    %% XCorr_DFoF 
    figure
    set(gcf,'color','w','position',[100 100 300 500])
    imagesc(t_lag,1:size(Conc_X_Corr_DFoF.Sorted_Y,2),Conc_X_Corr_DFoF.Sorted_Y'); hold on;
    colormap(viridis);
    set(gca,'YDir','normal','YTick',[1 size(Conc_X_Corr_DFoF.Sorted_Y,2)],'box','off', 'fontsize',8,'tickdir','out');
    set(gca,'xlim',[t_lag(1),t_lag(end)])
    xlabel('Time (s)');
    ylabel('Neuron');      
    title(fig_title);
end
