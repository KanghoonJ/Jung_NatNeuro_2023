%% Decoding Movement Direcion based on Bayesian Approaches
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023

clear all 
close all
% Load data
Base_folder = pwd; % working directory which contains folders for codes and figure dataset
cd(Base_folder)
load 'Fig_data\ChC_TeTxLC\db_2022.mat'

ID = db.DAQ.ID;
for(TDay=1:6:7)
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
DFoF = Img_Data.DFoF;  
all_cells = 1:size(DFoF,2);

%% Downsampling
Downsampled_MD = downsampling_MD(MD, Scaled_Raw_Timestamp, Timestamp);
Downsampled_Speed = downsampling_Beh(Speed, Scaled_Raw_Timestamp, Timestamp);
Downsampled_move_frames = unique(ceil(move_frames/(mean(diff(Timestamp))/mean(diff(Scaled_Raw_Timestamp)))));
Downsampled_running_ts = zeros(length(Downsampled_MD ),1);
Downsampled_running_ts(Downsampled_move_frames) = 1;

%% Binarization_trace estimation
[binarized_trace, DFoF_Deconv, GoF, SNR] = extract_binary_trace_FB(DFoF,'Deconv');

coactivity = sum(binarized_trace,2)/numel(all_cells);
cells_excluded = find(GoF<0.2|(sum(DFoF_Deconv.DFoF_Raster(Downsampled_move_frames,:))<3));
cell_analyzed = 1:size(DFoF_Deconv.DFoF_Raster,2);
cell_analyzed = setdiff(cell_analyzed, cells_excluded);
Cell_table.cell_analyzed(cell_analyzed) = 1;
ncells = numel(cell_analyzed);
Cell_table.cell_analyzed(cell_analyzed) = 1;

%% Estimation
bin_size = 5;
bin_vector = -180:bin_size:180; % start : bin_size : end
bin_centers_vector = bin_vector + bin_size/2;
bin_centers_vector(end) = [];
% 
% %% Select the frames that are going to be used to train the decoder
training_set_creation_method = 'random'; % 'odd', odd timestamps; 'first_portion', first portion of the recording; 3, 'random' random frames
training_set_portion = 0.9; % Portion of the recording used to train the decoder for method 2 and 3
% 
ca_time = Timestamp;
ca_data = DFoF_Deconv.s(:,cell_analyzed);
training_ts = create_training_set(ca_time, training_set_creation_method, training_set_portion);
training_ts(Downsampled_running_ts == 0) = 0; % Exclude periods of immobility from the traing set
% 
%% Create tuning curves for every cell
behav_vec = Downsampled_MD;
MI = [];
PDF = [];
prob_being_active = [];
tuning_curve_data = [];
for cell_i = 1:size(binarized_trace,2)
    [MI(cell_i), PDF(:,cell_i), occupancy_vector, prob_being_active(cell_i), tuning_curve_data(:,cell_i) ] = extract_1D_information(binarized_trace(:,cell_i), behav_vec, bin_vector, training_ts);
end

zscore_Y_emp = db.Analysis.(Field).Tuning_curve_data.zscore_Y_emp(:,cell_analyzed);

%% Figure P(active|state)
[~,max_index] = max(zscore_Y_emp,[],1);
[~,sorted_index] = sort(max_index);
sorted_tuning_curve_data = zscore_Y_emp(:,sorted_index);
figure, 
set(gcf,'color','w','position',[100 300 500 260])
imagesc(1:size(zscore_Y_emp,2),bin_centers_vector,sorted_tuning_curve_data)
set(gca,'ydir','normal')    
colorbar('southoutside')
colormap('redblue'); 
caxis([-20 50]);
ca_tuning = caxis;
ylim([-180 180])
ylabel('MD')
xlabel('Cell ID')
title(Field)
drawnow

%% Decode position
% First, let us establish the timestamps used for decoding.
decoding_ts = ~training_ts; % Training timestamps are excluded
decoding_ts(Downsampled_running_ts == 0) = 0; % Periods of immobility are excluded

% Minimal a priori (use to remove experimental a priori)
occupancy_vector = occupancy_vector./occupancy_vector*(1/length(occupancy_vector));

% Establish which cells are going to be used in the decoding process
cell_used = (ones(size(ca_data,2),1)); % Let us use every cell for now
zscore_tuning_curve_data = db.Analysis.(Field).Tuning_curve_data.zscore_Y_emp;

tuning_curve_data_p = [];
for(nc=1:size(zscore_tuning_curve_data,2))    
    tuning_curve_data_p(:,nc) = 2*normcdf(zscore_tuning_curve_data(:,nc)).*prob_being_active(nc);
end
[decoded_probabilities, decoded_probabilities_active, decoded_probabilities_inactive, dm] = bayesian_decode1D_FB(binarized_trace, occupancy_vector, prob_being_active, tuning_curve_data_p, cell_used);

%% Figure P(state)
edges = [-180:3:180];
MD_hist = histcounts(MD(move_frames),edges,'Normalization','probability');
P_state_observed = [edges(1:end-1)', MD_hist'];
P_state_uniform = [edges(1:end-1)', ones(length(edges)-1,1)/(length(edges)-1)];
figure, 
set(gcf,'color','w','position',[600 300 520 100])
col = 'k';
plot(P_state_observed(:,1),P_state_observed(:,2),'k'); hold on;
plot(P_state_uniform(:,1),P_state_uniform(:,2),'r'); hold on;
set(gca,'ydir','normal','tickdir','out','box','off')    
xlim([-180 180])
ylim([0 inf])
ylabel('P(state)')
xlabel('movement direction')
title(Field)

%% Figure P(active)
P_active = prob_being_active;
figure, 
set(gcf,'color','w','position',[600 500 520 100])
plot(1:length(P_active),P_active,'color',col);
set(gca,'ydir','normal','tickdir','out','box','off')    
xlim([1 length(P_active)])
ylim([0 inf])
ylabel('P(active)')
xlabel('Cell ID')
title(Field)

%% Let us now estimate the mouse location using the maximum a posteriori (MAP) value
decoded_probabilities = real(decoded_probabilities);
type = 'gaussian';
bin_number = 6;
decoded_probabilities_filtered = [];
for(frame_i=1:size(decoded_probabilities,2))
    decoded_probabilities_filtered(:,frame_i) = circ_filtered(decoded_probabilities(:,frame_i), bin_number, type);    
end

[max_decoded_prob, decoded_bin] = max(decoded_probabilities_filtered,[],1);
decoded_var_MAP = bin_centers_vector(decoded_bin);
decoded_var_circ_mean = [];
for(frame_i=1:size(decoded_probabilities,2))
    decoded_var_circ_mean(frame_i) = rad2deg(circ_mean(deg2rad(bin_vector(1:end-1)'),decoded_probabilities(:,frame_i)));
end
active_frames = intersect(Downsampled_move_frames,find(sum(binarized_trace,2)>0));

for(frame_i=1:size(decoded_probabilities,2))
    decoded_var_Prob(frame_i) =  bin_centers_vector(find(rand<cumsum(decoded_probabilities(:,frame_i)),1));
end
decoded_var = decoded_var_circ_mean(active_frames);
actual_var = Downsampled_MD(active_frames);

%% Plot one frame Posterior  
test_frames = find(sum(binarized_trace,2)>=5);
for(i=1:1)
    ROI_frame = test_frames(i);
    active_neurons = find(binarized_trace(ROI_frame,:)>0);
    inactive_neurons = setdiff(all_cells,active_neurons);
    [decoded_probabilities_roi_frame, bayesian_step_prob_roi_frame, bayesian_step_prob_roi_frame_active, bayesian_step_prob_roi_frame_inactive] = bayesian_decode1D_roi_frame(binarized_trace, occupancy_vector, prob_being_active, tuning_curve_data_p, find(all_cells), ROI_frame);
    
    figure 
    set(gcf,'color','w','position',[300 100 300 800])
    subplot(7,1,1:5)
    z = bayesian_step_prob_roi_frame;
    imagesc(bin_centers_vector, all_cells,z(:,sorted_index)')
    set(gca,'ydir','normal')    
    colorbar('northoutside')
    caxis([0 0.08]);
    colormap('viridis'); 
    xlim([-180 180])
    ylabel 'Cell ID'
    title (['P(A|S)' ' f: ' num2str(test_frames(i))])
    subplot(7,1,6:7)    
    plot(bin_centers_vector, decoded_probabilities_roi_frame(:,1),'k'); hold on;
    xline(decoded_var_MAP(test_frames(i)),'m',{'MAP'}); hold on;
    xline(behav_vec(test_frames(i)), 'k',{'MD'}); hold on;
    xlim([-180 180])
    ylabel('P(state|active)')
    xlabel('Movement Direction (\circ)')
    title(Field)
    drawnow    
end

%% Plot all Posterior 
xrange = [691 750];

figure
set(gcf,'color','w','position',[2250 150 613 823])
ax1 = subplot(9,1,1);
plot(Scaled_Raw_Timestamp,Speed,'k'); hold on;
ax1 = gca;
ax1.XLim = xrange;
ylabel 'Speed'
set(gca,'YDir','normal','box','off','tickdir','out')      

ax2 = subplot(9,1,2);
sorted_binarized_trace = binarized_trace(:,sorted_index);
ylabel('Cell ID')
imagesc(Timestamp,1:ncells,sorted_binarized_trace');
colormap(ax2,flipud(gray))
xlim(xrange)
ylim([-1 ncells+1])
yl = ylim;
ylabel('Cell ID')
set(gca,'YTick',[1 ncells],'YDir','normal','box','off','XTick',[],'tickdir','out')    

ax3 = subplot(9,1,3:6);
P_state_active = decoded_probabilities_filtered;
P_state_active(:,~Downsampled_running_ts) = nan;
imagesc(Timestamp,bin_centers_vector,normalize(P_state_active,1,'range')); hold on;
title('Posterior probabilities')
set(gca,'YTick',[-180:90:180],'YDir','normal','box','off','XTick',[],'tickdir','out')            
colorbar('southoutside')
colormap(ax3, 'viridis')
ylabel 'Direction (\circ)'
ax3 = gca;
ax3.CLim = [0.5 1];
ax3.XLim = xrange;
ax3.YDir = 'normal';
ylim([-180 180])

ax4 = subplot(9,1,7:9);
plot(Scaled_Raw_Timestamp(move_frames),MD(move_frames),'k.'); hold on;
plot(ca_time(active_frames), decoded_var,'.','color',[0 174 239]/255); hold on;
set(gca,'YTick',[-180:90:180],'YDir','normal','box','off','tickdir','out')            
title 'Actual versus decoded direction'
xlabel 'Time (s)'
ylabel 'Direction (\circ)'
ax4 = gca;
ax4.XLim = xrange;
ylim([-180 180])
linkaxes([ax1 ax2 ax3 ax4], 'x')
drawnow

%% Polor plot for Decoding Error
decoding_error = DiffAngle_calculator(actual_var, decoded_var');
edges = [-180:15:180];
ROI_AE = decoding_error;
ROI_AE(isnan(ROI_AE)) = [];
[Circ_hist_ROI_AE edges] = histcounts(deg2rad(ROI_AE),deg2rad(edges),'normalization','probability');
x = [edges(1:end-1)];
x = [x,x(1)];
y = [Circ_hist_ROI_AE,Circ_hist_ROI_AE(1);];
Polar_plot_AE_data.x = x;
Polar_plot_AE_data.y = y;

figure, 
set(gcf,'color','w','position',[1100 300 300 300])
polarplot(x, y, 'color',col, 'linewidth',2); hold on;
pax = gca;
pax.ThetaZeroLocation = 'top';
pax.ThetaDir = 'clockwise';
pax.ThetaLim = [-180 180];
ThetaLim = pax.ThetaLim;
pax.FontSize = 12;
pax.GridColor = [0.5 0.5 0.5];
rticklabels({})
Rlim = pax.RLim;
thetaticks(ThetaLim(1):15:ThetaLim(end));
title('Decoding Error')
sgtitle(Field)
drawnow;


%% Plot Average Posterior alinged to MD
% Line color
switch Field
    case 'TDay1'
        col = 'k';
    case 'TDay7'
        col = [64 117 255]/255;
end
figure
set(gcf,'color','w','position',[2000 100 600 200])
for(i=1:3)
    if(i==1)
        roi_decoded_probabilities = decoded_probabilities;      
    elseif(i==2)
        roi_decoded_probabilities = decoded_probabilities_active;
    elseif(i==3)
        roi_decoded_probabilities = decoded_probabilities_inactive;
    end
    MD_bin_index = discretize(MD,bin_vector);
    MD_centered_roi_decoded_probabilities = [];
    nframes = size(roi_decoded_probabilities,2);
    for frame_i = 1:nframes
        if(~isnan(MD_bin_index(frame_i)))
            MD_centered_roi_decoded_probabilities(:,frame_i) = circshift(roi_decoded_probabilities(:,frame_i),find(bin_vector>=0,1)-MD_bin_index(frame_i));
        end
    end
    subplot(1,3,i)    
    x = bin_centers_vector;
    y = nanmean(MD_centered_roi_decoded_probabilities(:,active_frames),2);
    y_sem = nansem(MD_centered_roi_decoded_probabilities(:,active_frames),0,2);
    shadedErrorBar(x, y, y_sem,'lineProps',{'color',col}); hold on;
    set(gca,'box','off','tickdir','out')
    xlim([-180 180])
    set(gca,'box','off','tickdir','out','XTick',[-180:45:180])
    xlabel('MD')
    ylabel('P(S|A)')
        if(i==1)
        MD_centered_decoded_probabilities = MD_centered_roi_decoded_probabilities;      
        MD_centered_P_SA = y;
        title({['Posterior probabilities:'],['All neurons']})
    elseif(i==2)
        MD_centered_decoded_probabilities_active = MD_centered_roi_decoded_probabilities;      
        MD_centered_P_SA_active = y;
        title({['Posterior probabilities:'],['Active neurons']})
    elseif(i==3)
        MD_centered_decoded_probabilities_inactive = MD_centered_roi_decoded_probabilities;      
        MD_centered_P_SA_inactive = y;
        title({['Posterior probabilities:'],['Inactive neurons']})
    end  
    drawnow
end

end

