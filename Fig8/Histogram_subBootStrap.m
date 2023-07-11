function [bootstat,bootraw]=Histogram_subBootStrap(raw1,raw2,bootnum)
sz1=size(raw1); % sz(1) = number of bins // sz(2) = number of mice(sample)
sz2=size(raw2);
bootraw=[];
for i=1:bootnum
    if isequal(raw1,raw2)
        [id]=randsample(sz1(2),2);
        id1 = id(1); id2=id(2);
    else
        id1=randsample(sz1(2),1);
        id2=randsample(sz2(2),1);
    end
    bootraw(:,i) = raw2(:,id2)-raw1(:,id1);
end
bootstat(:,1)=mean(bootraw,2);
bootstat(:,2)=std(bootraw,0,2); % STD of bootraw = SE
end

