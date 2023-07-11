function Avg = Estimation_tuning_curve(F_Data, move_frames, MD, edges)
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023
active_frames = move_frames;
Raw_Avg = Y_averaging_wrt_X_edge(MD(active_frames), F_Data(active_frames,:),edges);
% Raw_Filtered_Avg_SG.Y = circ_filtered(Raw_Avg.Y, 10,'sgolay');
Raw_Filtered_Avg_GA.Y = circ_filtered(Raw_Avg.Y, 10,'gaussian');
Avg.X = Raw_Avg.X;
% Avg.Y_SG = Raw_Filtered_Avg_SG.Y;
% Avg.Y_GA = Raw_Filtered_Avg_GA.Y;
Avg.Y = Raw_Filtered_Avg_GA.Y;




