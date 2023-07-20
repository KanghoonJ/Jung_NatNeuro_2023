%% Precision data for Exp and Control groups
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023

clear all
close all
Base_folder = pwd; % working directory which contains folders for codes and figure dataset
cd(Base_folder)

ROI_TDays = [1,7];
for(group=1:2)
    cd(Base_folder)    
    if(group==1)
        cd('Fig_data\WT_Exp')
        fig_title = 'Exp';
    elseif(group==2)
        cd('Fig_data\WT_Control')
        fig_title = 'Control';
    end
    % Load data
    load('Fig_precision_db.mat');
    figure, 
    set(gcf,'color','w','position',[100 100 520 340])
    for(nTDay = 1:numel(ROI_TDays))
        TDay = ROI_TDays(nTDay);
        Field = ['TDay' num2str(TDay)];                    
        switch Field
            case 'TDay1'
                if(group==1)
                    col = [102 170 215]/255; % Exp
                elseif(group==2)
                    col = [188 190 192]/255; % Control
                end                
            case 'TDay7'
                if(group==1)
                    col = [0 86 142]/255; % Exp
                elseif(group==2)
                    col = [65 65 66]/255; % Control
                end    
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
end




