function Downsampled_TS = downsampling_Beh(DFoF,Exp_FP_Timestamp,Synced_Behavior_Timestamp)
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023

TS = DFoF;
Downsampled_TS = [];
Nframes = length(Synced_Behavior_Timestamp);
for(i=1:Nframes)
    if(i==1)
        Time_range = [0, mean([Synced_Behavior_Timestamp(1,1), Synced_Behavior_Timestamp(2,1)])];
    elseif(i==Nframes)
        Time_range = [mean([Synced_Behavior_Timestamp(i-1,1),Synced_Behavior_Timestamp(i,1)]), Synced_Behavior_Timestamp(end)];
    else        
        Time_range = [mean([Synced_Behavior_Timestamp(i-1,1), Synced_Behavior_Timestamp(i,1)]) mean([Synced_Behavior_Timestamp(i,1), Synced_Behavior_Timestamp(i+1,1)])];
    end
        ROI_frames = find(Exp_FP_Timestamp>=Time_range(1) & Exp_FP_Timestamp<Time_range(2));
        ROI_frames(find(ROI_frames>size(TS,1))) = [];
        Downsampled_TS(i,1) = nanmean(TS(ROI_frames),1);    
end
