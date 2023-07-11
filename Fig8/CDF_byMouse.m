% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023

mousenumFW=max(RES1(:,1));
mousenumWR=max(RES2(:,1));
Binwidth1=0:0.5:4;
Binwidth2=0:0.1:1;
Bin1=Binwidth1(2)-Binwidth1(1);
Bin2=Binwidth2(2)-Binwidth2(1);

id1=find(RES1(:,8)==0);id11=find(RES1(:,8)~=0);
id2=find(RES2(:,8)==0);id22=find(RES2(:,8)~=0);

ho=figure(); 
colnum=8;
id1=find(RES1(:,colnum)==0);id11=find(RES1(:,colnum)~=0);
id2=find(RES2(:,colnum)==0);id22=find(RES2(:,colnum)~=0);
[PREcdfFW]=RunCDF(Binwidth1,RES1,colnum,mousenumFW,ho,'k');

colnum=8;
[PREcdfWR]=RunCDF(Binwidth1,RES2,colnum,mousenumWR,ho,'red');
xlabel('PreSSE')
ylabel('CDF')

h1=figure();
colnum=9;
id1=find(RES1(:,colnum)==0);id11=find(RES1(:,colnum)~=0);
id2=find(RES2(:,colnum)==0);id22=find(RES2(:,colnum)~=0);
[POSTcdfFW]=RunCDF(Binwidth2,RES1,colnum,mousenumFW,h1,'k');

colnum=9;
[POSTcdfWR]=RunCDF(Binwidth2,RES2,colnum,mousenumWR,h1,'red');
xlabel('PostSSE')
ylabel('CDF')

function [databymouse]=RunCDF(Binwidth,data,colnum,mousenum,ho,clr)
databymouse=[];
% ho=figure();
hold on
for id=1:mousenum
    idx=(data(:,1)==id);
    tmpdat=[];
    tmpdat=data(idx,colnum);
    znum=sum(tmpdat==0);
    [f,x] = ecdf(tmpdat);

    h1=figure();    
    h=histogram(tmpdat,'BinEdges',Binwidth);
%     c=[sum(idx2) h.Values];
    c=h.Values;
    c(1)=c(1)-znum; c=[znum c];
    c=c/sum(c);

    for i=1:length(c)
        d(i)=sum(c(1:i));
    end
    databymouse=[databymouse; d];
    close(h1)

    figure(ho)   
    plot(x,f,'Color',clr,'LineWidth',0.5)   
end
% Bin=Binwidth(2)-Binwidth(1);
errorbar(Binwidth(1:end),[mean(databymouse,1)],[std(databymouse)/mousenum],'Color',clr,'LineWidth',2)
end