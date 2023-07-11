%% Trace heat map
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023
clear all
close all
% Base_folder 
cd(Base_folder)

for(group=1:2)
    % Load data
    ROI_Times = [0 800];
    ROI_TDays = [1,7];    
    cd(Base_folder)    
    if(group==1)
        cd('Fig_data\WT_Exp')
        fig_title = 'Exp';
    elseif(group==2)
        cd('Fig_data\WT_Control')
        fig_title = 'Control';
    end    
    load('db_beh.mat')
    for(nTDay = 1:numel(ROI_TDays))        
        TDay = ROI_TDays(nTDay);
        l_Col = 'k';        
        Field = ['TDay' num2str(TDay)];        
        Title = [fig_title ' ' Field];

        %% Behavioral data        
        Beh_data = db.Behavior_data.(Field);
        Scaled_Raw_Timestamp = Beh_data.Scaled_Raw_Timestamp;
        ROI_Quat = Beh_data.ROI_Quat;
        Coords = Beh_data.Coords;
        Coords_2D = Beh_data.Coords_2D;

        %% ROI
        ROI_Frames = Find_Frames_in_TS(ROI_Times, Scaled_Raw_Timestamp);
        ROI_Timestamp = Scaled_Raw_Timestamp(ROI_Frames);

        %% 3D Trace
        for(i=4:4)
            figure, 
            set(gcf,'color','w', 'position',[1000 400 500 500])
            [R_Quad, c, R_HS] = drawballmaze(ROI_Quat);
            title([ Field ' S:' num2str(ROI_Times(1)) ' E:' num2str(ROI_Times(2))])
            ROI_Times_3D = [(i-1)*100 i*100];
            ROI_Frames_3D = Find_Frames_in_TS(ROI_Times_3D, Scaled_Raw_Timestamp);
            x = Coords(ROI_Frames_3D,1);
            y = Coords(ROI_Frames_3D,2);
            z = Coords(ROI_Frames_3D,3);        
            plot3(x,y,z,'color',l_Col); hold on; % 3D Trace for 100 s
            set(gca,'xtick',[],'ytick',[],'ztick',[],'XColor', 'none','YColor','none')
            title([Title ' T:' num2str(ROI_Times_3D(1)) '-' num2str(ROI_Times_3D(2))])
            az = 125;
            el = 45;
            view(az,el)
            grid off    
            drawnow
        end

        %% 2D Trace Heat Map using histcount2 
        [R_Quad, c, R_HS] = drawballmaze(ROI_Quat);
        x = Coords_2D(:,1);
        y = Coords_2D(:,2);
        Xedges = 0:0.01:1+0.01;
        Yedges = 0:0.01:1+0.01;
        [N,Xedges,Yedges] = histcounts2(x,y,Xedges,Yedges,'Normalization','probability');
        heatmap = imgaussfilt(N*100,4);
        [X,Y] = meshgrid(Xedges(1:end-1),Yedges(1:end-1));

        figure,
        set(gcf,'color','w','position',[2280 220 1240 580])
        [u_HS, v_HS] = draw_2d_maze(R_Quad, c, R_HS); hold on;
        h = surfc(X,Y,heatmap','edgecolor','none'); hold on;
        h(2).LineWidth = 1.5;
        alpha 0.3    
        scatter(x,y,2,'k','filled','MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5); hold on; % 2D Trace 
        plot(u_HS,v_HS,'--','color','k','linewidth',3); hold on; % Goal spot  
        view(2)
        caxis([0, 0.11])    
        set(gca,'xlim',[0 1],'ylim',[0 1],'xtick',[],'ytick',[]);
        title([Title])
        grid off
        drawnow
    end
end



