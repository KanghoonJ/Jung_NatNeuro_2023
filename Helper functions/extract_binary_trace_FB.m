function [binarized_trace, DFoF_Deconv, GoF, SNR] = extract_binary_trace_FB(DFoF,method)
%extract_binary trace Converts raw calcium traces into binary traces
% calcium_trace: double/float vector representing activity of a single neuron 
% sampling frequency: frequency at which calcium imaging has been done (in Hz or fps)

% z_threshold: standard deviation threshold above which calcium activity is
% considered higher than noise
% method = 'Pos_dz';
% method = 'Deconv';
switch method
    case 'Pos_dz'
        sampling_frequency = 10;
        [bFilt,aFilt] = butter(2,  2/(sampling_frequency/2), 'low');
        filtered_trace = [];
        for(nc=1:size(DFoF,2))
            filtered_trace(:,nc) = filtfilt(bFilt,aFilt,DFoF(:,nc));
        end
        
        Pos_dz_DFoF = [zeros(1,size(DFoF,2)); diff(zscore(DFoF))];
        Pos_dz_DFoF(Pos_dz_DFoF<=0) = 0;
        binarized_trace = zeros(size(DFoF));
        for(nc=1:size(DFoF,2))
            binarized_trace(find(Pos_dz_DFoF(:,nc)>3),nc) = 1;        
        end
        Estimated_trace = filtered_trace;
        Activity_trace = Pos_dz_DFoF;
    case 'Deconv'
        DFoF = DFoF-prctile(DFoF,10);
        [DFoF_Deconv] = DFoF_Deconvolution(DFoF);
        binarized_trace = DFoF_Deconv.DFoF_Raster;
        Estimated_trace = DFoF_Deconv.c;
        Activity_trace = DFoF_Deconv.s;
        GoF = nansum(Estimated_trace,1)./nansum(DFoF,1);
        Noise = nanstd(DFoF-Estimated_trace,1);
        for(nc=1:size(DFoF,2))
            active_frames = find(binarized_trace(:,nc));
            Signal(nc) = nanmean(Estimated_trace(active_frames,nc),1);
        end
        SNR = Signal./Noise;
end
