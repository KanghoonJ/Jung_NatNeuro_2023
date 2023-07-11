function [u_HS, v_HS] = draw_2d_maze(R_Quad, c, R_HS)
%% Draw 2D maze
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023

%% Ball maze surface color
Col_Q1 = [140 174 209]/255;
Col_Q2 = [206 204 205]/255;
Col_Q3 = [224 216 114]/255;
Col_Q4 = [214 98 132]/255;
MD_Col = [0 0 0];
F_Col = [145 255 0]/255;
R_Col = [255 0 0]/255;

Quad_cmap = [Col_Q1; Col_Q2; Col_Q3; Col_Q4];

%% Plot on 2d
Rx1 = R_Quad.Rx1;
Ry1 = R_Quad.Ry1;
Rz1 = R_Quad.Rz1;

R_HS_Coords = [R_HS.R_HS_x,R_HS.R_HS_y,R_HS.R_HS_z];
% Goal spot
Goal_Coords = [0 0 1];
Opposite_Goal_Coords = [0 0 -1];
u_Goal = 0.5 + atan2(Goal_Coords(:,3), Goal_Coords(:,1))/(2*pi);
v_Goal = 0.5 - asin(Goal_Coords(:,2))/(pi);

u_Opposite_Goal = 0.5 + atan2(Opposite_Goal_Coords(:,3), Opposite_Goal_Coords(:,1))/(2*pi);
v_Opposite_Goal = 0.5 - asin(Opposite_Goal_Coords(:,2))/(pi);

% Hidden Spot (HS)
u_HS = 0.5 + atan2(R_HS_Coords(:,3),R_HS_Coords(:,1))/(2*pi);
v_HS = 0.5 - asin(R_HS_Coords(:,2))/(pi);

% Quad    
Q1_elements = find(c==4);    
u_Q1 = 0.5 + atan2(Rz1(Q1_elements),Rx1(Q1_elements))/(2*pi);
v_Q1 = 0.5 - asin(Ry1(Q1_elements))/(pi);
Q2_elements = find(c==3);
u_Q2 = 0.5 + atan2(Rz1(Q2_elements),Rx1(Q2_elements))/(2*pi);
v_Q2 = 0.5 - asin(Ry1(Q2_elements))/(pi);
Q3_elements = find(c==2);
u_Q3 = 0.5 + atan2(Rz1(Q3_elements),Rx1(Q3_elements))/(2*pi);
v_Q3 = 0.5 - asin(Ry1(Q3_elements))/(pi);
Q4_elements = find(c==1);
u_Q4 = 0.5 + atan2(Rz1(Q4_elements),Rx1(Q4_elements))/(2*pi);
v_Q4 = 0.5 - asin(Ry1(Q4_elements))/(pi);

surf(reshape(u_Q3, [size(c,1)/2,size(c,2)/2]),reshape(v_Q3, [size(c,1)/2,size(c,2)/2]),zeros(size(c,1)/2),'FaceColor',Col_Q4,'EdgeColor','none'); hold on; %Q4
surf(reshape(u_Q2, [size(c,1)/2,size(c,2)/2]),reshape(v_Q2, [size(c,1)/2,size(c,2)/2]),zeros(size(c,1)/2),'FaceColor',Col_Q2,'EdgeColor','none'); hold on;  %Q2
surf(reshape(u_Q4, [size(c,1)/2,size(c,2)/2]),reshape(v_Q4, [size(c,1)/2,size(c,2)/2]),zeros(size(c,1)/2),'FaceColor',Col_Q3,'EdgeColor','none'); hold on; %Q3
surf(reshape(u_Q1, [size(c,1)/2,size(c,2)/2]),reshape(v_Q1, [size(c,1)/2,size(c,2)/2]),zeros(size(c,1)/2),'FaceColor',Col_Q1,'EdgeColor','none'); hold on; %Q1 
plot(u_Goal,v_Goal,'b+'); hold on;
plot(u_HS,v_HS,'--','color','k','linewidth',3); hold on;
set(gca, 'ytick',[])
xlim([0 1])
ylim([0 1])     
view([0 90])
