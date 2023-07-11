function Downsampled_Direction = downsampling_MD(Direction, Scaled_Raw_Timestamp, Imaging_Timestamp)
% Downsampling of direction data (-180 degree to 180 degree)
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023
[CatAngle] = Angle_convert2catesian(Direction);
Nframes = length(Imaging_Timestamp);
Downsampled_CatAngle_rad =[];
for(framen=1:Nframes)
    if(framen==1)
        Time_range = [0, mean([Imaging_Timestamp(framen,1),Imaging_Timestamp(framen+1,1)])];
    elseif(framen==Nframes)
        Time_range = [mean([Imaging_Timestamp(framen-1,1),Imaging_Timestamp(framen,1)]), Imaging_Timestamp(end)];
    else        
        Time_range = [mean([Imaging_Timestamp(framen-1,1),Imaging_Timestamp(framen,1)]) mean([Imaging_Timestamp(framen,1),Imaging_Timestamp(framen+1,1)])];
    end
    A = find(Scaled_Raw_Timestamp>=Time_range(1) & Scaled_Raw_Timestamp<Time_range(2));
    A(find(A>numel(CatAngle))) = [];
    ROI_CatAngle = CatAngle(A);
    ROI_CatAngle(isnan(ROI_CatAngle)) = [];    
    Downsampled_CatAngle_rad(framen,1) = circ_mean(ROI_CatAngle/180*pi);    
end
Downsampled_Direction = Cat2Angle_convert2Angle(Downsampled_CatAngle_rad/pi*180);

