function [CatAngle] = Angle_convert2catesian(Angle)
% Kanghoon Jung, Kwon Lab, Neuroscience, Johns Hopkins University, 2023
CatAngle = mod(90-Angle+360,360);
