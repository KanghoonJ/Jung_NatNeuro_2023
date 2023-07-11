function [Angle] = Cat2Angle_convert2Angle(CatAngle)
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023

CatAngle2 = mod(CatAngle+180,360) -180;
Angle = mod(mod(-CatAngle2 + 90 + 360,360)+180,360)-180;
