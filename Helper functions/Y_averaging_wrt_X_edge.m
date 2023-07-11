function Avg = Y_averaging_wrt_X_edge(x,y,edges)
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023

x_group = discretize(x,edges,'IncludedEdge','left');
Avg = [];
Avg.X = [edges(1:end-1) + (edges(2)-edges(1))/2]';
for(i=1:numel(edges)-1)    
    Avg.Y(i,1) = nanmean(y(find(x_group==i)));
    Avg.Y_sem(i,1) = nanstd(y(find(x_group==i)),0,1)/sqrt(numel(y(find(x_group==i))));    
end
