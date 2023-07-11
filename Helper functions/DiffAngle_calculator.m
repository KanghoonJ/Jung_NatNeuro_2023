function Angle_diff = DiffAngle_calculator(angle1, angle2)
% Calulate difference in two angles
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023

mod_angle1 = mod(angle1,360);
mod_angle2 = mod(angle2,360);
Angle_diff = 180- abs(180-abs(mod_angle1 - mod_angle2));  
Angle_diff(find((angle2-angle1)<0)) = - Angle_diff(find((angle2-angle1)<0));


