function [newLM]=RenumberLM(oldLM)
% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023

sz=size(oldLM);
newstack=zeros(sz(1),sz(2),sz(3));
lst=unique(oldLM);
for i=2:length(lst)
   id=lst(i);
   for z=1:10
       timg=oldLM(:,:,z);
       tmpmsk=logical(timg==id);
       newstack(:,:,z)=newstack(:,:,z)+double(tmpmsk).*i;
   end
end
newLM=newstack;