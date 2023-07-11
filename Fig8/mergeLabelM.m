function [newLM]=mergeLabelM(MarkingSel)
% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023

LM=MarkingSel;
sz=size(LM);
newLM=zeros(sz(1),sz(2),sz(3));
newLM(:,:,1)=LM(:,:,1);
newidx=0;
for i=1:sz(3)-1
    A=newLM(:,:,i);
    B=LM(:,:,i+1);
    inter=logical(min(LM(:,:,i:i+1),[],3));
    A(A==0)=NaN;B(B==0)=NaN;
    listA=unique(A);listA=listA(~isnan(listA));
    listB=unique(B);listB=listB(~isnan(listB));
    
    %     if ~isempty(listA) && ~isempty(listB)
    newB=zeros(sz(1),sz(2));
    if newidx==0 %%initialization of idx for new roi
        newidx=max(listA)+1;
    end
    
    for j=1:length(listB)
        tmpmask=(B==listB(j));
        tmpv=tmpmask.*inter.*newLM(:,:,i);
        lst=unique(tmpv);
        lst=lst(~isnan(lst));
        connid=lst(end);
        
        if connid==0
            newB=newB+newidx.*double(tmpmask);
            newidx=newidx+1;
        else
            newB=newB+connid.*double(tmpmask);
            if length(lst)>2 % if there are more than one intersected rois, exchange preivous indexing of them as same
                for k=2:length(lst)
                    for kk=1:i
                        sec=newLM(:,:,kk);
                        [rr,cc]=find(sec==lst(k));
                        for kkk=1:length(rr)
                            sec(rr(kkk),cc(kkk))=connid;
                        end
                        newLM(:,:,kk)=sec;
                    end
                    
                    sec=newB;
                    [rr,cc]=find(sec==lst(k));
                    for kkk=1:length(rr)
                        sec(rr(kkk),cc(kkk))=connid;
                    end
                    newB=sec;
                end
            end
        end
    end
    newLM(:,:,i+1)=newB;
    
    %     end
end