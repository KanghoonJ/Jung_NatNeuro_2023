function [decoded_probabilities, decoded_probabilities_active, decoded_probabilities_inactive, dm] = bayesian_decode1D_FB(binarized_trace, occupancy_vector, prob_being_active, tuning_curve_data, cell_used)
% cell_used: array containing cells used to decode behavior. If 0, include all cells

%% Using only cells specified in cell_used variable
tuning_curve_data = tuning_curve_data(:,find(cell_used));
prob_being_active = prob_being_active(find(cell_used));
binarized_data = binarized_trace(:,find(cell_used));

decoded_probabilities = zeros(size(tuning_curve_data,1),size(binarized_data,1))*nan;
decoded_probabilities_active = zeros(size(tuning_curve_data,1),size(binarized_data,1))*nan;
decoded_probabilities_inactive = zeros(size(tuning_curve_data,1),size(binarized_data,1))*nan;
dm = zeros(size(tuning_curve_data,1),size(binarized_data,1))*nan;

%% Estimate probabilities of being in a given state for each timestep
for step_i = 1:size(binarized_data,1)    
    bayesian_step_prob = nan(size(tuning_curve_data));
    bayesian_step_prob_active = nan(size(tuning_curve_data));
    bayesian_step_prob_inactive = nan(size(tuning_curve_data));
    for cell_i = 1:size(binarized_data,2)
        if binarized_data(step_i,cell_i) > 0
            active_tuning_curve = tuning_curve_data(:,cell_i);
            bayesian_step_prob(:,cell_i) = (active_tuning_curve.*occupancy_vector)./prob_being_active(cell_i);
            bayesian_step_prob_active(:,cell_i) = bayesian_step_prob(:,cell_i);
        elseif binarized_data(step_i,cell_i) == 0
            inactive_tuning_curve = 1-tuning_curve_data(:,cell_i);
            bayesian_step_prob(:,cell_i) = (inactive_tuning_curve.*occupancy_vector)./(1-prob_being_active(cell_i));
            bayesian_step_prob_inactive(:,cell_i) = bayesian_step_prob(:,cell_i);
        end
    end

    decoded_probabilities(:,step_i) = expm1(nansum(log1p(bayesian_step_prob),2)); % This should be used instead of simple product to avoid numerical underflow
    decoded_probabilities(:,step_i) = decoded_probabilities(:,step_i)./sum(decoded_probabilities(:,step_i),'omitnan'); % The method above is an approximation, to obtain a posterior distribution, we can normalize every datapoint
    dm(:,step_i) = sum(decoded_probabilities(:,step_i),'omitnan');
    decoded_probabilities_active(:,step_i) = expm1(nansum(log1p(bayesian_step_prob_active),2)); % This should be used instead of simple product to avoid numerical underflow
    decoded_probabilities_active(:,step_i) = decoded_probabilities_active(:,step_i)./sum(decoded_probabilities_active(:,step_i),'omitnan'); % The method above is an approximation, to obtain a posterior distribution, we can normalize every datapoint
       
    decoded_probabilities_inactive(:,step_i) = expm1(nansum(log1p(bayesian_step_prob_inactive),2)); % This should be used instead of simple product to avoid numerical underflow
    decoded_probabilities_inactive(:,step_i) = decoded_probabilities_inactive(:,step_i)./sum(decoded_probabilities_inactive(:,step_i),'omitnan'); % The method above is an approximation, to obtain a posterior distribution, we can normalize every datapoint   
end
