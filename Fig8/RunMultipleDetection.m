% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023

% %% INITIALIZATION of Parameters
% RGBcode=[5 113 176;210 210 210;202 1 32]; % Color setting for low/mid/high groups
% options.overwrite=true;
% options.color=true;
% 
% pathlist_FW % list of paths for folders containing each slice image set: control group [cell]
% pathlist_WR % list of paths for folders containing each slice image set: experimental group [cell]
% L1line_FW % Lines for layer 1 boundary of each slice: control group [cell]
% L1line_WR % Lines for layer 1 boundary of each slice: experimental group [cell]
% 
% zi=1;zf=10; % initial and last frame to analyze - same for all the slice images
% pixelL = 0.159; % pixel size in length (um) - same for all the slice images
% img_Gephyrin = 'R 488.tif';% File Name for Gephyrin Channel - same for all the slice images
% img_ChC = 'R 561.tif';% File Name for ChC Channel - same for all the slice images
% img_AnkG = 'R 637.tif';% File Name for AnkG Channel - same for all the slice images

%% Run: Control groups (FW)
lp=length(pathlist_FW);
RESallFW=[];
fr_FW=[];
for pathl=1:lp
    folderpath=pathlist_FW{pathl};
    cd(folderpath)
    disp(['Processing: ' folderpath])    
    lin=L1line_FW{pathl};   
    AISDetection   
    selectAIS
    [preSSEmap,postSSEmap,lst]=SSEmap_group(RESall,AISmap,RGBcode);
    figure();
    imshow(preSSEmap)
    saveastiff(preSSEmap,'SSEMap_pre.tif',options)
    close all
    figure();
    imshow(postSSEmap)
    saveastiff(postSSEmap,'SSEMap_post.tif',options)
    close all
    RESallFW=[RESallFW; ones(length(RESall),1)*mouseidFW(pathl) ones(length(RESall),1)*pathl RESall];
    fr_FW=[fr_FW;sum(lst(:,1)==1)/length(lst) sum(lst(:,1)==2)/length(lst) sum(lst(:,1)==3)/length(lst) sum(lst(:,2)==1)/length(lst) sum(lst(:,2)==2)/length(lst) sum(lst(:,2)==3)/length(lst)];
    save('SSEMap_group.mat','preSSEmap','postSSEmap','lst');
end

%% Run: Experimental groups (WR)
lp=length(pathlist_WR);
RESallWR=[];
fr_WR=[];
for pathl=1:lp
    folderpath=pathlist_WR{pathl};
    cd(folderpath)
    disp(['Processing: ' folderpath])
    lin=L1line_WR{pathl};
    AISDetection    
    selectAIS
    [preSSEmap,postSSEmap,lst]=SSEmap_group(RESall,AISmap,RGBcode);
    figure();
    imshow(preSSEmap)
    saveastiff(preSSEmap,'SSEMap_pre.tif',options)
    close all
    figure();
    imshow(postSSEmap)
    saveastiff(postSSEmap,'SSEMap_post.tif',options)
    close all
    RESallWR=[RESallWR; ones(length(RESall),1)*mouseidWR(pathl) ones(length(RESall),1)*pathl RESall];
    fr_WR=[fr_WR;sum(lst(:,1)==1)/length(lst) sum(lst(:,1)==2)/length(lst) sum(lst(:,1)==3)/length(lst) sum(lst(:,2)==1)/length(lst) sum(lst(:,2)==2)/length(lst) sum(lst(:,2)==3)/length(lst)];
    save('SSEMap_group.mat','preSSEmap','postSSEmap','lst');
end

