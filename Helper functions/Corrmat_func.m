function [CorrMat, CorrMat_P, w_ij] = Corrmat_func(Data)
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023
nF = size(Data,2); % Number of factors
CorrMat = zeros(nF); 
CorrMat_P = [];
for(i=1:nF)
    for(j=i+1:nF)
        [R, P] = corrcoef(Data(:,i), Data(:,j));
        CorrMat(i,j) = R(1,2);
        CorrMat_P(i,j) = P(1,2);  
        CorrMat(j,i) = R(1,2);
        CorrMat_P(j,i) = P(1,2);                
    end
end

%% Coincidence Index
N = size(Data,1);
CI = [];
for(cell1 = 1:size(Data,2))                
    for(cell2 = 1:size(Data,2))
        CI(cell1,cell2) = (sum(Data(:,cell1).*Data(:,cell2)) - N*mean(Data(:,cell1))*mean(Data(:,cell2)))/(N*sqrt(mean(Data(:,cell1))*mean(Data(:,cell2))));
    end
end   
%% CI ROIs      
w_ij = CI;                
w_ij(logical(eye(size(w_ij))))=0; 

