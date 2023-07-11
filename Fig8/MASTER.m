% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023
%% INITIALIZATION of Parameters
pathlist_FW % list of paths for folders containing each slice image set: control group [cell]
pathlist_WR % list of paths for folders containing each slice image set: experimental group [cell]
L1line_FW % Lines for layer 1 boundary of each slice: control group [cell]
L1line_WR % Lines for layer 1 boundary of each slice: experimental group [cell]
mouseidFW % a vector containing the ID of mouse for each slice image set : control group
mouseidWR % a vector containing the ID of mouse for each slice image set : experimental group

zi=1;zf=10; % initial and last frame to analyze - same for all the slice images
pixelL = 0.159; % pixel size in length (um) - same for all the slice images
img_Gephyrin = 'R 488.tif';% File Name for Gephyrin Channel - same for all the slice images
img_ChC = 'R 561.tif';% File Name for ChC Channel - same for all the slice images
img_AnkG = 'R 637.tif';% File Name for AnkG Channel - same for all the slice images

RGBcode=[5 113 176;210 210 210;202 1 32]; % Color setting for low/mid/high groups
options.overwrite=true;
options.color=true;

%% Detection and Measurement
RunMultipleDetection

%% Analysis
GetRES_byMouse % Sort results by mouse and plot basic histograms / by high-mid-low
Prob_byMouse % Plot all histograms of pre/post SSE of each mouse
Bootstr_BinDifference % Bootstrapping to cal hist diff
Bootstr_FoldChange % Booststrapping to cal hist fold change
CDF_byMouse % Plot CDF
DfromL1vsSSE % D vs SSE