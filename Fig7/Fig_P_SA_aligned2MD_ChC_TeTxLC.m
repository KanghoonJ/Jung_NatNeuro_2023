%% Normalized P(S|A) for ChC TeTxLC
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023
clear all
close all
Base_folder = pwd; % working directory which contains folders for codes and figure dataset
cd(Base_folder)
ROI_TDays = [1,7];
cd('Fig_data\ChC_TeTxLC')

bin_size = 5;
bin_vector = -180:bin_size:180; % start : bin_size : end
bin_centers_vector = bin_vector + bin_size/2;
bin_centers_vector(end) = [];
chance_level = 1/numel(bin_centers_vector);

Fig_db = [];
fig_title = 'ChC TeTxLC';
for(nTDay = 1:numel(ROI_TDays))
    TDay = ROI_TDays(nTDay);
    Field = ['TDay' num2str(TDay)];            
    load(['Fig_db_P_SA_aligned2PD_' Field '.mat'])
    switch Field
        case 'TDay1'
            col = [255 163 255]/255; % ChC-TeTxLC                    
        case 'TDay7'
            col = [179 9 179]/255; % ChC-TeTxLC                            
    end
    figure(1)    
    set(gcf,'color','w','position',[100 200 300 560])  
    x = Fig_db.x;
    Fig_db.Avg = nanmean(Fig_db.y,2);
    Fig_db.Avg_sem = nansem(Fig_db.y,0,2);
    shadedErrorBar(x, Fig_db.Avg/chance_level, Fig_db.Avg_sem/chance_level, 'lineprops',{'color',col,'linewidth',2}); hold on;
    xl = xlim;        
end
line([xl(1) xl(2)],[1,1],'color',[0.5 0.5 0.5]); hold on;
set(gca,'box','off','tickdir','out')
xlim([-90 270])
ylim([0.99 1.03])    
set(gca,'box','off','tickdir','out','XTick',[-90:90:270],'YTick',[0.99:0.01:1.04])
xlabel('Distance from MD')    
ylabel('%')
title(fig_title)
drawnow





