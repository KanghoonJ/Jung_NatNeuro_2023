function data_filtered = circ_filtered(data, bin_number, type)
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023
temp = smoothdata(repmat(data,3,1),type,bin_number,'omitnan');
data_filtered = temp(numel(data)+1:2*numel(data));