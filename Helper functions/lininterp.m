function iFluo = lininterp(Fluo,Scaled_Raw_Timestamp,Imaging_Timestamp)
% linear interpolation
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023
iFluo = zeros(numel(Scaled_Raw_Timestamp),size(Fluo,2));
for(i=1:size(Imaging_Timestamp,1))
    if(i<=size(Imaging_Timestamp,1)-1)
        start_frame = find(Imaging_Timestamp(i,1) <= Scaled_Raw_Timestamp,1);
        start_value = Fluo(i);
        end_frame = find(Imaging_Timestamp(i+1,1) > Scaled_Raw_Timestamp,1,'last');
        end_value = Fluo(i+1);
    else
        start_frame = find(Imaging_Timestamp(i,1) <= Scaled_Raw_Timestamp,1);
        start_value = Fluo(i);
        end_frame = numel(Scaled_Raw_Timestamp);
        end_value = Fluo(i);
    end
        ROI_frames = [start_frame:end_frame];
        ROI_values = linspace(start_value,end_value,numel(ROI_frames));
        iFluo(ROI_frames,1) = ROI_values;
end
