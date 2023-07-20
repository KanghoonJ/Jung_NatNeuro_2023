%% Turning Angle
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023
close all
clear all
Base_folder = pwd; % working directory which contains folders for codes and figure dataset
cd(Base_folder)
ROI_TDays = [1,7];
for(group=1:2)
    % Load data
    cd(Base_folder)    
    if(group==1)
        cd('Fig_data\WT_Exp')
        fig_title = 'Exp';
        Session_colormap(1,:) = [140 198 255]/255;
        Session_colormap(7,:) = [0 128 255]/255;
        
    elseif(group==2)
        cd('Fig_data\WT_Control')
        fig_title = 'Control';
        Session_colormap(1,:) = [190 190 190]/255;
        Session_colormap(7,:) = [65 65 65]/255;            
    end    
    
    load('Fig_turning_angle_db.mat');
    Num_Subj = length(Turning_angle_db.ID);

    figure, 
    set(gcf,'color','w','position',[2100 100 400 400])
    for(nSubj = 1:Num_Subj)    
        for(nTDay = 1:numel(ROI_TDays))
            TDay = ROI_TDays(nTDay);
            CW_TA.t = Turning_angle_db.CW{nSubj,TDay}(:,1);
            CW_TA.x = Turning_angle_db.CW{nSubj,TDay}(:,2);
            CCW_TA.t = Turning_angle_db.CCW{nSubj,TDay}(:,1);
            CCW_TA.x = Turning_angle_db.CCW{nSubj,TDay}(:,2);
            plot(CW_TA.x, CW_TA.t,'.','color',Session_colormap(TDay,:)); hold on; % Clock-Wise Turning       
            plot(CCW_TA.x, CCW_TA.t,'.','color',Session_colormap(TDay,:)); hold on;% Conter Clock-Wise Turning       
        end
    end
    set(gca,'tickdir','out','box','off')
    xlim([-100000 100000])
    ylabel('Time (s)')
    xlabel('Cumulative Turning angle (degree)')
    title(fig_title)
end


