%% Plot Normalized P(S|A) aligned to movement direction
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023
clear all
close all
Base_folder = pwd; % working directory which contains folders for codes and figure dataset
cd(Base_folder)
ROI_TDays = [1,7];

bin_size = 5;
bin_vector = -180:bin_size:180; % start : bin_size : end
bin_centers_vector = bin_vector + bin_size/2;
bin_centers_vector(end) = [];
chance_level = 1/numel(bin_centers_vector);

Fig_db = [];
for(group=1:2)
    cd(Base_folder)    
    if(group==1)
        cd('Fig_data\WT_Exp')
        fig_title = 'Exp';
    elseif(group==2)
        cd('Fig_data\WT_Control')
        fig_title = 'Control';
    end
    for(nTDay = 1:numel(ROI_TDays))
        TDay = ROI_TDays(nTDay);
        Field = ['TDay' num2str(TDay)];            
        load(['Fig_db_P_SA_aligned2PD_' Field '.mat'])
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
                    col = [65 64 66]/255; % Control
                end    
        end
        figure(group)    
        set(gcf,'color','w','position',[2256 226 297 560])
        for(nSubj = 1:size(Fig_db.y,2))        
            x = Fig_db.x;
            y = Fig_db.y(:,nSubj);
            plot(x, y/chance_level, 'color',[col]); hold on;
            set(gca,'box','off','tickdir','out')
            xlim([-90 270])
            set(gca,'box','off','tickdir','out','XTick',[-180:45:360])
            drawnow            
        end        
        Fig_db.Avg = nanmean(Fig_db.y,2);
        Fig_db.Avg_sem = nansem(Fig_db.y,0,2);
        shadedErrorBar(x, Fig_db.Avg/chance_level, Fig_db.Avg_sem/chance_level, 'lineprops',{'color',col,'linewidth',2}); hold on;
        xl = xlim;        
    end
    line([xl(1) xl(2)],[chance_level,chance_level]/chance_level,'color',[0.5 0.5 0.5]); hold on;
    set(gca,'box','off','tickdir','out')
    xlim([-90 270])
    ylim([0.99 1.04])    
    set(gca,'box','off','tickdir','out','XTick',[-90:90:270],'YTick',[0.99:0.01:1.04])
    xlabel('Distance from MD')    
    ylabel('%')
    title(fig_title)
    drawnow
end


