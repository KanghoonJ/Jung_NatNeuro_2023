function [preSSEmap,postSSEmap,lst]=SSEmap_group(RES,AISmap,RGBcode)
% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023

%RES=RESnotcut; %Choose RESall or RESnotcut
idlist=RES(:,1); %Choose idAIS or idWhAIS
l=length(RES);
sz=size(AISmap);
preSSEmap=zeros(sz(1),sz(2),3); postSSEmap=preSSEmap;
RGBcode=RGBcode./255;
lst=[];
for i=1:l
    id=idlist(i);
    tmpmap=(AISmap==id);
    % sort pre/post group
    if RES(i,6)<0.5
        gval1=1;
    elseif RES(i,6)>=0.5 && RES(i,6)<1.5
        gval1=2;
    else
        gval1=3;
    end
    if RES(i,7)<0.1
        gval2=1;
    elseif RES(i,7)>=0.1 && RES(i,7)<0.6
        gval2=2;
    else
        gval2=3;
    end
    preSSEmap(:,:,1)=preSSEmap(:,:,1)+tmpmap.*RGBcode(gval1,1);
    preSSEmap(:,:,2)=preSSEmap(:,:,2)+tmpmap.*RGBcode(gval1,2);
    preSSEmap(:,:,3)=preSSEmap(:,:,3)+tmpmap.*RGBcode(gval1,3);
    postSSEmap(:,:,1)=postSSEmap(:,:,1)+tmpmap.*RGBcode(gval2,1);
    postSSEmap(:,:,2)=postSSEmap(:,:,2)+tmpmap.*RGBcode(gval2,2);
    postSSEmap(:,:,3)=postSSEmap(:,:,3)+tmpmap.*RGBcode(gval2,3);
    lst=[lst; gval1 gval2];
end

% preSSEmap(preSSEmap==0)=1;
% postSSEmap(postSSEmap==0)=1;
%Plotting
% tiledlayout(2,1)
% CM=CM./0.156;

% nexttile
% figure();
% title('PreSSE')
% imshow(preSSEmap)
% colormap("autumn")
% colorbar
% caxis([0 3])
% hold on
% scatter(CM(:,1),CM(:,2),30,"magenta",'filled')
%
% % nexttile
% figure();
% title('PostSSE')
% imshow(postSSEmap)
% colormap(cool)
% colorbar
% hold on
% scatter(CM(:,1),CM(:,2),30,"magenta",'filled')
