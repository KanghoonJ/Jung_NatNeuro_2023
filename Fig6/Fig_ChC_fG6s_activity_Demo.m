%% ChC activity during locomotion
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023
clear all
close all
Base_folder = 'C:\Users\jungk\Google Drive\[Kwon Lab @ MPFI]\Project #3 - ChC\Manuscript\Working manuscript\Nat Neurosci version\Editing\Code_KJ'
cd(Base_folder)
load('Fig_data\ChC_fG6s\db_2022.mat')

TDays = [1,7];
for(i=1:length(TDays))
    TDay = TDays(i);
    Field = ['TDay' num2str(TDay)];        
    Timestamp = db.Imaging_data.(Field).Imaging_Timestamp;
    Speed = db.Behavior_data.(Field).Downsampled_Speed;    
    Z_DFoF = db.Imaging_data.(Field).Z_DFoF;
    ncells = size(Z_DFoF,2);    

    %% Plot DFoF 
    x_range = [0 200];
    Patch_x = Timestamp;  
    Patch_y = Speed ;
    roi_x = x_range;
    Cell_oder = db.Analyzed_Data.TDay7.Cell_order;

    figure
    set(gcf,'color','w','Position',[100, 100, 700, 400])
    ax1 = subplot(9,1,1:3) 
    plot(Patch_x, Patch_y,'k'); hold on;
    yl = ylim;
    ylabel('Speed');
    set(gca,'tickdir','out','box','off','xtick',[],'xlim',x_range)
    hold off;
    drawnow
    xlim(roi_x)
    ax2 = subplot(9,1,4:9)
    imagesc(Patch_x,1:ncells,Z_DFoF(:,Cell_oder)'); hold on;
    caxis([-2 2])
    cmap = colorcet('L19');
    colormap(cmap)
    set(gca,'YDir','normal','YTick',[1 ncells],'box','off','tickdir','out','xlim',x_range);
    xlabel('Time (s)');    
    ylabel('Neuron');
    xlim(roi_x)        
    linkaxes([ax1, ax2],'x')
    sgtitle(Field)
end



