%% Precision data for ChC-hM4Di manipulation
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023

clear all
close all
% Base_folder 
cd(Base_folder)

ROI_TDays = [7,8,9];
cd('Fig_data\ChC_DREADD')
fig_title = 'ChC-hM4Di';
% Load data
load('Fig_precision_db.mat');
figure, 
set(gcf,'color','w','position',[100 100 520 340])
for(nTDay = 1:numel(ROI_TDays))
    TDay = ROI_TDays(nTDay);
    Field = ['TDay' num2str(TDay)];                    
    switch Field       
        case 'TDay7'
            col = 'k'; % Session 7
        case 'TDay8'
            col = 'r'; % CNO       
        case 'TDay9'    
            col = [90 90 90]/255; % Saline
    end
    %% Plot average precision curves    
    Precision_data = Fig_precision_db{TDay}.precision;        
    x = Fig_precision_db{TDay}.MD;
    y = nanmean(Precision_data,2);
    y_sem = nansem(Precision_data,1,2);
    shadedErrorBar(x, y, y_sem,'lineProps',{'color',col}); hold on;
    set(gca,'box','off','tickdir','out')
    xlim([-180 180])
    set(gca,'box','off','tickdir','out','XTick',[-180:45:180])
    xlabel('Movement direction')
    ylabel('Precision')
    ylim([0 inf])
    title(fig_title)
    drawnow    
end




