function vonmises_double = vonmises_estimation_test_double(CircAvg)
%% fitting to a von Mises distribution 
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023

% Use lscurvefit
X = CircAvg.X;
Y = CircAvg.Y;
% initial values
a0 = 0;
a1 = max(Y); % the max value of the data 
a2 = 0.8*a1;
k1 = 10;
k2 = 10; 
theta_1 = X(find(Y==max(Y),1)); 

p0 = [a0, a1, a2, k1, k2, theta_1];
Mresp = abs(max(Y));
lb = [-Mresp, 0, 0, 0, 0, min(X)];
ub = [Mresp, 3*Mresp, 3*Mresp, k1, k2, max(X)];

xdata = X;    
ydata = Y;
xdata(isnan(ydata)) = [];
ydata(isnan(ydata)) = [];

fun = @(p0, xdata) p0(1) + p0(2)*exp(p0(4)*cos((xdata-mod(p0(6)+180,360)-180)/180*pi)-1) + p0(3)*exp(p0(5)*cos((xdata-mod(p0(6)+360,360)-180)/180*pi)-1);    
[p, resnorm, residual, exitflag, output, lambda, jacobian] = lsqcurvefit(fun, p0, xdata, ydata, lb, ub);    

M.x = [min(X)-mean(diff(X))/2:1:max(X)+mean(diff(X))/2];
M.y = p(1) + p(2)*exp(p(4)*cos((M.x-mod(p(6)+180,360)-180)/180*pi)-1) + p(3)*exp(p(5)*cos((M.x-mod(p(6)+360,360)-180)/180*pi)-1);

DSI = abs((p(2)-p(3))/(p(2)+p(3)));

[pks,locs,widths,proms] = findpeaks(M.y,M.x,'WidthReference','halfheight');
PD_max_emp = X(find(Y==max(Y)));
if(isempty(pks))
    Max_pks = M.y(find(M.y==max(M.y),1));    
    PD_max_model = M.x(find(M.y==Max_pks,1));
    TW = min(abs(PD_max_model-M.x(find(mat2gray(M.y)<=0.5))));    
else 
    Max_pks = M.y(find(M.y==max(M.y),1));    
    PD_max_model = M.x(find(M.y==Max_pks,1));
    TW = min(abs(PD_max_model-M.x(find(mat2gray(M.y)<=0.5))));    
end

PD = PD_max_model;
Normalized_M.y = M.y;
R_pref = max(Normalized_M.y);
R_null = Normalized_M.y(find((mod(PD_max_model+360,360)-180)<=M.x,1));
ND = M.x(find((mod(PD_max_model+360,360)-180)<=M.x,1));
DSI = (R_pref-R_null)/(R_pref);
[r pvalue] = corrcoef(Y(~isnan(Y)), M.y(~isnan(Y)));
C_r = r(1,2);    
C_pvalue = pvalue(1,2);    
RSQ1 = C_r^2;
RSQ2 = 1 - resnorm / sum((Y(~isnan(Y)) - mean(Y(~isnan(Y)))).^2);

%% Circular variance 
Cir_var = 1-abs(sum(M.y.*exp(1i*M.x/180*pi))./sum(M.y));
vonmises_double.M = M;
vonmises_double.p = p;
vonmises_double.PD = PD;
vonmises_double.ND = ND;
vonmises_double.DSI = DSI;
vonmises_double.TW = TW;
vonmises_double.Cir_var = Cir_var;
vonmises_double.RSQ1 = RSQ1;  
vonmises_double.RSQ2 = RSQ2;
vonmises_double.C_r = C_r;
vonmises_double.C_pvalue = C_pvalue;





