function [R_Quad, c, R_HS] = drawballmaze(ROI_Quat)
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023
%% Ball maze surface color
Col_Q1 = [140 174 209]/255;
Col_Q2 = [206 204 205]/255;
Col_Q3 = [224 216 114]/255;
Col_Q4 = [215 100 133]/255;

HS_range = 30;
k = 10;
n = 2^k-1;
[x1,y1,z1] = sphere(n); 

c = [4*ones((n+1)/2) 3*ones((n+1)/2); 2*ones((n+1)/2) 1*ones((n+1)/2)];
k = 1;

Quad_3d_cmap = [Col_Q3; Col_Q4; Col_Q2; Col_Q1];

alpha = -135/180*pi;
phi = 90/180*pi;
Roty = [cos(alpha) 0 sin(alpha);0 1 0;-sin(alpha) 0 cos(alpha)];
Rotx = [1 0 0; 0 cos(alpha) -sin(alpha); 0 sin(alpha) cos(alpha)];
Rotz = [cos(phi) -sin(phi) 0; sin(phi) cos(phi) 0; 0 0 1];
v = [];
for(i=1:size(x1,1))
    for(j=1:size(x1,2))
        v = [x1(i,j);y1(i,j);z1(i,j)];
        Rv = Rotx*v;
        Rv = Rotz*Rv;
        Rx1(i,j) = Rv(1);
        Ry1(i,j) = Rv(2);
        Rz1(i,j) = Rv(3);         
    end
end
R_Quad.Rx1 = Rx1;
R_Quad.Ry1 = Ry1;
R_Quad.Rz1 = Rz1;

s = surf(Rx1,Ry1,Rz1,c,'EdgeColor','none','Facealpha',1); hold on;
Col = s.CData;
colormap(Quad_3d_cmap)
axis equal

%% Draw ROI spot
ROI_PRotated = qRotatePoint([0; 0; 1], ROI_Quat');
ROI_x = ROI_PRotated(1,1);
ROI_y = ROI_PRotated(2,1);
ROI_z = ROI_PRotated(3,1);

%% Draw Hidden spot
dx = 1*sin(0.5*HS_range/180*pi);      
w = sqrt(1 - dx^2);
Quat = [w dx 0 0];
i = 1;
temp_R_HS = [];
R_HS_x = [];
R_HS_y = [];
R_HS_z = [];
HS_PRotated = [];
for(beta=0:0.01:2*pi)
    Rotz = [cos(beta) -sin(beta) 0; sin(beta) cos(beta) 0; 0 0 1];        
    HS_PRotated = qRotatePoint([ROI_x; ROI_y; ROI_z], Quat');    
    temp_R_HS = Rotz*HS_PRotated;
    R_HS_x(i,1) = temp_R_HS(1);
    R_HS_y(i,1) = temp_R_HS(2);
    R_HS_z(i,1) = temp_R_HS(3);  
    i = i+1;
end
R_HS.R_HS_x = R_HS_x;
R_HS.R_HS_y = R_HS_y;
R_HS.R_HS_z = R_HS_z;
plot3(R_HS_x,R_HS_y,R_HS_z,'--', 'LineWidth', 2,'color',[0.5 0.5 0.5]); hold on; 
xlabel('x')
ylabel('y')
zlabel('z')

