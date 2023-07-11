%% Pairwise correlation of the activity of pairs of neurons as a function of difference in their preferred directions for ChC-DREADD manipulation
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023

% Group_folder = ['E:\jungk network drive\Project #3 FB\Data\2p data\WT\WT hG6s WR'];
% Group_folder = ['E:\jungk network drive\Project #3 FB\Data\2p data\ChC\NkxFlexFlp hG6s+hMi4D x4'];
clear all
close all
% % Group_folder = ['F:\Project #3 FB\FB_Experiments\WT hG6s WR\'];
% % Group_folder = ['F:\Project #3 FB\FB_Experiments\NkxFlexFlp hG6s+TeTx'];
% Group_folder = ['F:\Project #3 FB\FB_Experiments\NkxFlexFlp hG6s+hM4Di_Conc_Data'];
% % Group_folder = ['F:\Project #3 FB\FB_Experiments\NkxFlexFlp hG6s+hMi4D'];
% 
% % Group_folder = ['F:\Project #3 FB\FB_Experiments\WT hG6s control'];
% % ROI_TDays = [1,7];
% 
% ROI_TDays = [7,8,9];
% % switch Field
% % t7_col = 'm';
% %% Conc tuning curves P(A|S)
% % Conc actual bin and decoded bin 
% cd(Group_folder) 
% %% Load existing dataset 
% gp_db_File = dir('gp_db.mat');
% if(~isempty(gp_db_File))
%     load(gp_db_File.name)
% end
%    
% Subj_Folders = dir('*');
% isub = [Subj_Folders(:).isdir];
% Subj_Folders = Subj_Folders(isub);
% Subj_Folders(ismember({Subj_Folders.name}',{'.','..'})) = [];
% % Remove unwanted folder processing
% % Subj_Folders(5) = [];
% 
% gp_db.Group_folder = Group_folder;
% gp_db.Num_Subj = size(Subj_Folders,1);
% Num_Subj = gp_db.Num_Subj;
% % 
% % for(nTDay = 1:numel(ROI_TDays))
% %     TDay = ROI_TDays(nTDay);
% %     Field = ['TDay' num2str(TDay)];            
% %     Conc_PairwiseCorr_table = [];    
% %     for(nSubj = 1:Num_Subj)        
% %         cd(Group_folder) 
% %         Subject.ID = Subj_Folders(nSubj).name; 
% %         Output_folder = [Group_folder '\' Subj_Folders(nSubj).name];
% %         Subject.Output_folder = Output_folder;
% %         cd(Output_folder)
% %         disp([Output_folder ' T:' num2str(TDay)]);        
% %         db_File = dir('db_2*.mat');
% %         if(~isempty(db_File))
% %             load(db_File(end).name)
% %         end
% %         PairwiseCorr_table = db.Analysis.(Field).PairwiseCorrData;          
% %         Conc_PairwiseCorr_table = [Conc_PairwiseCorr_table; PairwiseCorr_table]; 
% %     end    
% %     gp_db.Analysis.(Field).PairwiseCorr.Conc_PairwiseCorr_table = Conc_PairwiseCorr_table;    
% % end
% % 
% % %% Save data
% % cd(Group_folder) 
% % disp('Saving gp_db Data')    
% % save(gp_db_File.name, 'gp_db', '-append')    
% 
% %% Test
% close all
% DeltaPD_PairCorr_Data = [];
% Norm_DeltaPD_PairCorr_Data = [];
% Pairwise_Corr_table_db = [];
% for(TDay=7:9)
%     Field = ['TDay' num2str(TDay)]; 
%     switch Field
%         case 'TDay1'
%             col = 'k';
%         case 'TDay7'
%             col = 'k';
%     %         col = [64 117 255]/255;
%         case 'TDay8'
%             col = 'r';        
%         case 'TDay9'
%     %         col = 'c';                
%     %         col = [64 117 255]/255;
%             col = [0.5 0.5 0.5];
%     end
%     % emp
%     xrange = [0 180]; 
%     bin_size = 10;
%     
%     Conc_PairwiseCorr_table = gp_db.Analysis.(Field).PairwiseCorr.Conc_PairwiseCorr_table;
%     x = abs(Conc_PairwiseCorr_table.Delta_PD);   
%     y = Conc_PairwiseCorr_table.PairwiseCorr;
%     edges = xrange(1):bin_size:xrange(2);
%     Delta_PD_PairCorr = Y_averaging_wrt_X_edge(x,y, edges); 
%     if(TDay==7)
%         Baseline = Delta_PD_PairCorr.Y(1);
%     end
%     Pairwise_Corr_table_db{TDay}.table = Conc_PairwiseCorr_table;
%     Pairwise_Corr_table_db{TDay}.edges = edges;
%     
% %     Norm_DeltaPD_PairCorr_Data{TDay}.x = Delta_PD_PairCorr.X;
% %     Norm_DeltaPD_PairCorr_Data{TDay}.y = Delta_PD_PairCorr.Y/Baseline;
% %     Norm_DeltaPD_PairCorr_Data{TDay}.y_sem = Delta_PD_PairCorr.Y_sem./Baseline;
% %     
% %     %% Plot average pairwise correlation curves with respect to Delta PD
% % %     figure(1), 
% % %     set(gcf,'color','w','position',[600 310 255 290])
% % %     shadedErrorBar(Delta_PD_PairCorr.X, Delta_PD_PairCorr.Y, Delta_PD_PairCorr.Y_sem,'lineprops',{'color',col}); hold on;
% % %     % errorbar(Delta_PD_PairCorr.X, Delta_PD_PairCorr.Y, Delta_PD_PairCorr.Y_sem,'color',col); hold on;
% % %     set(gca,'xlim',[-5 185],'box','off','xtick',[0:45:180],'tickdir','out')
% % %     xlabel('Diff in PD')
% % %     ylabel('Pairwise correlation')
% % %     title(['Group']);
% % %     
% % % 
% % %     
% % %     DeltaPD_PairCorr_Data{TDay}.x = Delta_PD_PairCorr.X;
% % %     DeltaPD_PairCorr_Data{TDay}.y = Delta_PD_PairCorr.Y;
% % %     DeltaPD_PairCorr_Data{TDay}.y_sem = Delta_PD_PairCorr.Y_sem;
% % %     
% % %     
% %     
%     
%     figure(1), 
%     set(gcf,'color','w','position',[600 310 250 290])
%     shadedErrorBar(Delta_PD_PairCorr.X, Delta_PD_PairCorr.Y/Baseline, Delta_PD_PairCorr.Y_sem./Baseline,'lineprops',{'color',col}); hold on;
%     % errorbar(Delta_PD_PairCorr.X, Delta_PD_PairCorr.Y, Delta_PD_PairCorr.Y_sem,'color',col); hold on;
%     set(gca,'xlim',[-5 185],'ylim',[0 1.3],'box','off','xtick',[0:45:180],'tickdir','out')
%     xlabel('Diff in PD')
%     ylabel('Normalized Pairwise correlation')
%     title(['Group']);
%     
% end

clear all
close all
Base_folder = 'C:\Users\jungk\Google Drive\[Kwon Lab @ MPFI]\Project #3 - ChC\Manuscript\Working manuscript\Nat Neurosci version\Editing\Code_KJ';
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
