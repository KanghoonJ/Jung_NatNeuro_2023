%% Direction Selectivity Estimation 
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023

clear all
close all
Base_folder = pwd; % working directory which contains folders for codes and figure dataset
cd(Base_folder)

cd('Fig_data\WT_Exp')
% Load data
load('db_2022.mat');
TDay = 7;
Field = ['TDay' num2str(TDay)];

Beh_Data = db.Behavior_data.(Field);
Scaled_Raw_Timestamp = Beh_Data.Scaled_Raw_Timestamp;
MD = Beh_Data.MD;
Speed = Beh_Data.Speed;
move_frames = Beh_Data.move_frames;
rest_frames = Beh_Data.rest_frames;

% Imaging data
Img_Data = db.Imaging_data.(Field);
Timestamp = Img_Data.Imaging_Timestamp;
% Load Cell ROIs
sROI = Img_Data.sROI;
INs_sROI = Img_Data.INs_sROI;
EXs_sROI = Img_Data.EXs_sROI;
DFoF = Img_Data.DFoF;   
all_cells = 1:size(DFoF,2);

% Data Table 
Cell_table = [];
Cell_table.TDay = repmat(TDay,size(DFoF,2),1);
Cell_table.sROI_num = all_cells';
Cell_table.cell_analyzed = zeros(size(DFoF,2),1);
db.Analysis.(Field).Cell_data = cell(1, numel(all_cells));

%% Decoding
Downsampled_MD = downsampling_MD(MD, Scaled_Raw_Timestamp, Timestamp);
Downsampled_Speed = downsampling_Beh(Speed, Scaled_Raw_Timestamp, Timestamp);
Downsampled_move_frames = unique(ceil(move_frames/(mean(diff(Timestamp))/mean(diff(Scaled_Raw_Timestamp)))));

%% Data set
[binarized_trace, DFoF_Deconv, GoF, SNR] = extract_binary_trace_FB(DFoF,'Deconv');
cells_excluded = find(GoF<0.2 | (sum(DFoF_Deconv.DFoF_Raster(Downsampled_move_frames,:))<3));
cell_analyzed = 1:size(DFoF_Deconv.DFoF_Raster,2);
cell_analyzed = setdiff(cell_analyzed, cells_excluded);
Cell_table.cell_analyzed(cell_analyzed) = 1;
ncells = numel(cell_analyzed);
Cell_table.cell_analyzed(cell_analyzed) = 1;
F_Data = lininterp(DFoF_Deconv.s,Scaled_Raw_Timestamp, Timestamp);

%% Estimation
Sparsity =nan(numel(all_cells),1);
CircR = nan(numel(all_cells),1);
CircVar = nan(numel(all_cells),1);
PD = nan(numel(all_cells),1);
DSI = nan(numel(all_cells),1);

edges= [-180:5:180];
for(nc=1:numel(all_cells))    
    db.Analysis.(Field).Cell_data{nc} = [];
    disp(['c:' num2str(nc)])
    if(ismember(nc,cell_analyzed))            
        ROI_F_Data = F_Data(:,nc);
        Base = nanmean(ROI_F_Data);
        Angle = MD(move_frames);
        Weight = ROI_F_Data(move_frames);   
    
        % Circular Average Estimation
        CircAvg = Y_ciraveraging_wrt_X_edge(Angle,Weight,edges);
        CircAvg.Y = CircAvg.Y;
        Y = CircAvg.Y;
        
        % vonmises_estimation_test
        vonmises_double = vonmises_estimation_test_double(CircAvg);      

        CircR(nc,1) = abs(sum(Y.*exp(1i*deg2rad(CircAvg.X))))/sum(Y);
        CircVar(nc,1) = circ_var(deg2rad(CircAvg.X), Y);
        Sparsity(nc,1) = 1- sum(CircAvg.Y)^2/(numel(CircAvg.Y)*sum(CircAvg.Y.^2));    
        PD(nc,1) = vonmises_double.PD;
        DSI(nc,1) = vonmises_double.DSI;      
    end
end

Cell_table.Sparsity = Sparsity;
Cell_table.CircR = CircR;
Cell_table.CircVar = CircVar;
Cell_table.PD = PD;
Cell_table.DSI = DSI;
Cell_table = struct2table(Cell_table);
