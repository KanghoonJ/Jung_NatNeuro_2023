% Minhyeok Chang, Kwon Lab, Neuroscience, Johns Hopkins Univeristy, 2023

RES1=RESallFW;
[RES1]=filtData(RES1,10,0,250);
RES2=RESallWR;
[RES2]=filtData(RES2,10,0,250);
mousenumFW=max(RES1(:,1));
mousenumWR=max(RES2(:,1));

binwidth=10:1:40;
bin=1;
colnum=7;
[L_FW_bin]=RunRES(binwidth,RES1,colnum,mousenumFW);
colnum=7;
[L_WR_bin]=RunRES(binwidth,RES2,colnum,mousenumWR);
% figure();
% b1=bar(binwidth(2:end)-bin/2,mean(L_FW_bin,1),1)
% b1.FaceColor='red';
% b1.FaceAlpha=0.5;
% hold on
% e1=errorbar(binwidth(2:end)-bin/2,mean(L_FW_bin,1),std(L_FW_bin,1)/mousenumFW)
% e1.Color='red';
% b2=bar(binwidth(2:end)-bin/2,mean(L_WR_bin,1),1)
% b2.FaceColor='yellow';
% b2.FaceAlpha=0.5;
% e2=errorbar(binwidth(2:end)-bin/2,mean(L_WR_bin,1),std(L_WR_bin,1)/mousenumWR)
% e2.Color='yellow';
% xticks(binwidth)
% xlabel('L')
% xlim([0 max(binwidth)])


Binwidth1=0:0.5:4;
Binwidth2=0:0.1:1;
Bin1=Binwidth1(2)-Binwidth1(1);
Bin2=Binwidth2(2)-Binwidth2(1);

colnum=8;
[PRE_FW_bin]=RunRES(Binwidth1,RES1,colnum,mousenumFW);

colnum=8;
[PRE_WR_bin]=RunRES(Binwidth1,RES2,colnum,mousenumWR);

colnum=9;
[POST_FW_bin]=RunRES(Binwidth2,RES1,colnum,mousenumFW);

colnum=9;
[POST_WR_bin]=RunRES(Binwidth2,RES2,colnum,mousenumWR);


% figure();bar([mean(PREnotcutFW_bin,1)' mean(PREnotcutWR_bin,1)'],'hist')
% figure();bar([mean(POSTnotcutFW_bin,1)' mean(POSTnotcutWR_bin,1)'],'hist')

% figure();
% b1=bar(Binwidth1(2:end)-Bin1/2,mean(PRE_FW_bin,1),1)
% b1.FaceColor='red';
% b1.FaceAlpha=0.5;
% hold on
% e1=errorbar(Binwidth1(2:end)-Bin1/2,mean(PRE_FW_bin,1),std(PRE_FW_bin,1)/mousenumFW)
% e1.Color='red';
% b2=bar(Binwidth1(2:end)-Bin1/2,mean(PRE_WR_bin,1),1)
% b2.FaceColor='yellow';
% b2.FaceAlpha=0.5;
% e2=errorbar(Binwidth1(2:end)-Bin1/2,mean(PRE_WR_bin,1),std(PRE_WR_bin,1)/mousenumWR)
% e2.Color='yellow';
% xticks(Binwidth1)
% xlabel('PreSSE')
% xlim([0 max(Binwidth1)])
% 
% figure();
% b3=bar(Binwidth2(2:end)-Bin2/2,mean(POST_FW_bin,1),1)
% b3.FaceColor='red';
% b3.FaceAlpha=0.5;
% hold on
% e3=errorbar(Binwidth2(2:end)-Bin2/2,mean(POST_FW_bin,1),std(POST_FW_bin,1)/mousenumFW)
% e3.Color='red';
% b4=bar(Binwidth2(2:end)-Bin2/2,mean(POST_WR_bin,1),1)
% b4.FaceColor='yellow';
% b4.FaceAlpha=0.5;
% e4=errorbar(Binwidth2(2:end)-Bin2/2,mean(POST_WR_bin,1),std(POST_WR_bin,1)/mousenumWR)
% e4.Color='yellow';
% xticks(Binwidth2)
% xlabel('PostSSE')
% xlim([0 1])

% figure();
% b5=bar(Binwidth1(2:end)-Bin1/2,mean(PRE_WR_bin,1)-mean(PRE_FW_bin,1),1)
% b5.FaceColor='green';
% b5.FaceAlpha=0.5;
% xlabel('PreSSE')
% ylabel('WR-FW')
% xlim([0 max(Binwidth1)])
% 
% figure();
% b6=bar(Binwidth2(2:end)-Bin2/2,mean(POST_WR_bin,1)-mean(POST_FW_bin,1),1)
% b6.FaceColor='green';
% b6.FaceAlpha=0.5;
% xlabel('PostSSE')
% ylabel('WR-FW')
% xlim([0 1])
% 
% figure();
% b7=bar(Binwidth1(2:end)-Bin1/2,(mean(PRE_WR_bin,1)-mean(PRE_FW_bin,1))./mean(PRE_FW_bin,1)*100,1)
% b7.FaceColor='green';
% b7.FaceAlpha=0.5;
% hold on
% plot(Binwidth1(2:end)-Bin1/2,(mean(PRE_WR_bin,1)-mean(PRE_FW_bin,1))./mean(PRE_FW_bin,1)*100)
% xlabel('PreSSE')
% ylabel('Fold Change (%)')
% xlim([0 max(Binwidth1)])
% 
% figure();
% b8=bar(Binwidth2(2:end)-Bin2/2,(mean(POST_WR_bin,1)-mean(POST_FW_bin,1))./mean(POST_FW_bin,1)*100,1)
% b8.FaceColor='green';
% b8.FaceAlpha=0.5;
% hold on
% plot(Binwidth2(2:end)-Bin2/2,(mean(POST_WR_bin,1)-mean(POST_FW_bin,1))./mean(POST_FW_bin,1)*100)
% xlabel('PostSSE')
% ylabel('Fold Change (%)')
% xlim([0 1])

%% Plot low-mid-high range
figure();
PRE_FW_bin_rng=[];
PRE_WR_bin_rng=[];
POST_FW_bin_rng=[];
POST_WR_bin_rng=[];
preth(1)=0.5;preth(2)=1.5;
postth(1)=0.1;postth(2)=0.6;
preid(1)=find(Binwidth1==preth(1));preid(2)=find(Binwidth1==preth(2));
postid(1)=find(Binwidth2==postth(1));postid(2)=find(Binwidth2==postth(2));

PRE_FW_bin_rng(:,1)=PRE_FW_bin(:,1);
PRE_FW_bin_rng(:,2)=sum(PRE_FW_bin(:,preid(1):preid(2)-1),2);
PRE_FW_bin_rng(:,3)=sum(PRE_FW_bin(:,preid(2):end),2);

PRE_WR_bin_rng(:,1)=PRE_WR_bin(:,1);
PRE_WR_bin_rng(:,2)=sum(PRE_WR_bin(:,preid(1):preid(2)-1),2);
PRE_WR_bin_rng(:,3)=sum(PRE_WR_bin(:,preid(2):end),2);

POST_FW_bin_rng(:,1)=POST_FW_bin(:,1);
POST_FW_bin_rng(:,2)=sum(POST_FW_bin(:,postid(1):postid(2)-1),2);
POST_FW_bin_rng(:,3)=sum(POST_FW_bin(:,postid(2):end),2);

POST_WR_bin_rng(:,1)=POST_WR_bin(:,1);
POST_WR_bin_rng(:,2)=sum(POST_WR_bin(:,postid(1):postid(2)-1),2);
POST_WR_bin_rng(:,3)=sum(POST_WR_bin(:,postid(2):end),2);

figure();
b1=bar(1:3,mean(PRE_FW_bin_rng,1))
b1.FaceColor='black';
b1.FaceAlpha=0.5;
hold on
e1=errorbar(1:3,mean(PRE_FW_bin_rng,1),std(PRE_FW_bin_rng,1)/mousenumFW)
e1.Color='black';
plot(PRE_FW_bin_rng','k')
b2=bar(1:3,mean(PRE_WR_bin_rng,1))
b2.FaceColor='red';
b2.FaceAlpha=0.5;
e2=errorbar(1:3,mean(PRE_WR_bin_rng,1),std(PRE_WR_bin_rng,1)/mousenumWR)
e2.Color='red';
plot(PRE_WR_bin_rng','r')
xlabel('PreSSE')

figure();
b1=bar(1:3,mean(POST_FW_bin_rng,1))
b1.FaceColor='black';
b1.FaceAlpha=0.5;
hold on
e1=errorbar(1:3,mean(POST_FW_bin_rng,1),std(POST_FW_bin_rng,1)/mousenumFW)
e1.Color='black';
plot(POST_FW_bin_rng','k')
b2=bar(1:3,mean(POST_WR_bin_rng,1))
b2.FaceColor='red';
b2.FaceAlpha=0.5;
e2=errorbar(1:3,mean(POST_WR_bin_rng,1),std(POST_WR_bin_rng,1)/mousenumWR)
e2.Color='red';
plot(POST_WR_bin_rng','r')
xlabel('PostSSE')

% figure();
% b1=bar(1:3,(mean(PRE_WR_bin_rng,1)-mean(PRE_FW_bin_rng,1))./mean(PRE_FW_bin_rng,1)*100)
% b1.FaceColor='yellow';
% b1.FaceAlpha=0.5;
% xlabel('PreSSE')
% 
% figure();
% b2=bar(1:3,(mean(POST_WR_bin_rng,1)-mean(POST_FW_bin_rng,1))./mean(POST_FW_bin_rng,1)*100)
% b2.FaceColor='yellow';
% b2.FaceAlpha=0.5;
% xlabel('PostSSE')


% Binwidth=0:0.1:1.5;
% Bin=Binwidth(2)-Binwidth(1);
% [databymouse1]=RunRES(Binwidth,RES1,16,6);
% [databymouse01]=RunRES(Binwidth,RES01,13,6);
% figure();
% b1=bar(mean(databymouse1,1)','hist')
% b1.FaceAlpha=0.5;
% hold on
% b01=bar(mean(databymouse01,1)','hist');
% b01.FaceAlpha=0.5;b01.FaceColor='green';
% 
% [databymouse2]=RunRES(Binwidth,RES2,16,5);
% [databymouse02]=RunRES(Binwidth,RES02,13,5);
% figure();
% b1=bar(mean(databymouse2,1)','hist')
% b1.FaceAlpha=0.5;
% hold on
% b01=bar(mean(databymouse02,1)','hist');
% b01.FaceAlpha=0.5;b01.FaceColor='green';

function [databymouse]=RunRES(Binwidth,data,colnum,mousenum)
databymouse=[];
for id=1:mousenum
    idx=(data(:,1)==id);
    figure();
    h=histogram(data(idx,colnum),'Normalization','Probability','BinEdges',Binwidth);
    databymouse=[databymouse; h.Values];
    close
end
end

function [fdat]=filtData(dat,col,min,max)
    id=(dat(:,col)>=min).*(dat(:,col)<max);
    fdat=dat(logical(id),:);
end