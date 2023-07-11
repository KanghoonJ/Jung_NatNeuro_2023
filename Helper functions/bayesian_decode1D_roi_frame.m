function [decoded_probabilities, bayesian_step_prob_roi_frame, bayesian_step_prob_roi_frame_active, bayesian_step_prob_roi_frame_inactive] = bayesian_decode1D_roi_frame(binarized_data, occupancy_vector, prob_being_active, tuning_curve_data, cell_used, roi_frame)
%   cell_used: array containing cells used to decode behavior. If 0, include all cells

%% Using only cells specified in cell_used variable
tuning_curve_data = tuning_curve_data(:,cell_used);
prob_being_active = prob_being_active(cell_used);
binarized_data = binarized_data(:,cell_used);

decoded_probabilities = zeros(size(tuning_curve_data,1),1)*nan;
bayesian_step_prob = nan(size(tuning_curve_data));
bayesian_step_prob_roi_frame = nan(size(tuning_curve_data));
bayesian_step_prob_roi_frame_active = nan(size(tuning_curve_data));
bayesian_step_prob_roi_frame_inactive = nan(size(tuning_curve_data));
% active_tuning_curve = nan(size(tuning_curve_data));
% inactive_tuning_curve = nan(size(tuning_curve_data));
%% Estimate probabilities of being in a given state for each timestep
for step_i = roi_frame:roi_frame
    for cell_i = 1:size(binarized_data,2)
        if binarized_data(step_i,cell_i) == 1
            active_tuning_curve = tuning_curve_data(:,cell_i);
            bayesian_step_prob(:,cell_i) = (active_tuning_curve.*occupancy_vector)./prob_being_active(cell_i);
            bayesian_step_prob_roi_frame_active(:,cell_i) = (active_tuning_curve.*occupancy_vector)./(prob_being_active(cell_i));

        elseif binarized_data(step_i,cell_i) == 0
            inactive_tuning_curve = 1-tuning_curve_data(:,cell_i);
            bayesian_step_prob(:,cell_i) = (inactive_tuning_curve.*occupancy_vector)./(1-prob_being_active(cell_i));
            bayesian_step_prob_roi_frame_inactive(:,cell_i) = (inactive_tuning_curve.*occupancy_vector)./(1-prob_being_active(cell_i));
        end
    end    
    if(step_i==roi_frame)
        bayesian_step_prob_roi_frame = bayesian_step_prob;
    end
    decoded_probabilities(:,1) = expm1(nansum(log1p(bayesian_step_prob),2)); % This should be used instead of simple product to avoid numerical underflow
    decoded_probabilities(:,1) = decoded_probabilities(:,1)./sum(decoded_probabilities(:,1),'omitnan'); % The method above is an approximation, to obtain a posterior distribution, we can normalize every datapoint
    
end

