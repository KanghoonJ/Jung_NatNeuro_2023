%% Correlation Matrix of the activity between ChC neurons
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023
close all
clear all
Base_folder = pwd; % working directory which contains folders for codes and figure dataset
cd(Base_folder)
cd('Fig_data\ChC_fG6s')
load('Fig_corr_mat_db.mat')

cmap = colorcet('L19');
colormap(cmap)
Data_table = [];
for(TDay=1:6:7)
    Fieldname = ['TDay' num2str(TDay)];
    Data.Imaging_Data = db.Imaging_data.(Fieldname);
    DFoF = Data.Imaging_Data.DFoF;%       

    %% Pearson Corr
    F_Data = DFoF;
    [CorrMat, CorrMat_P] = Corrmat_func(F_Data);
    nF = size(F_Data,2); % Number of factors
    nS = size(F_Data,1); % Number of samples

    %% Plot clustergram
    cgo = clustergram(CorrMat,'Standardize','Row','Colormap',cmap);
    set(cgo,'Linkage','complete','Dendrogram',2,'DisplayRange',2)
    Cell_order = cell2mat([cellfun(@str2num,cgo.ColumnLabels,'un',0).']);
    addTitle(cgo,'Pearson');

    % Corr matrix
    CorrMat_NA = CorrMat;
    CorrMat_NA(find(eye(size(CorrMat_NA)))) = nan;
    figure, 
    set(gcf,'color','w','position',[100 100 350 300])
    imagesc(1:nF, 1:nF, CorrMat_NA(Cell_order,Cell_order)')
    set(gca,'tickdir','out','xtick',[1,nF],'ytick',[1,nF],'box','off')    
    title({['TDay:' num2str(TDay)],['Pearsons Corr Mat']})
    axis equal
    colormap(cmap)
    caxis([-0.7 0.7])
    colorbar
    drawnow
end


