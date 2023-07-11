load("Results_Detection.mat",'LM637');
RES=RESall;
id=(RES(:,8)>0).*(RES(:,8)<250);
RESall=[];
RESall=RES(logical(id),:);
sz=size(LM637);
AISmap=zeros(sz(1),sz(2));
for i=1:length(RESall)
    id=RESall(i,1);
    idM=(LM637==id);
    pj=max(idM,[],3);
    AISmap=AISmap+pj.*id;
end
save("Results_Analysis.mat","AISmap","ChCmap","GepComap","GepAISmap","RESall","idAIS");
saveastiff(AISmap,'DetectionMap_AnalyzedAIS.tif',options)