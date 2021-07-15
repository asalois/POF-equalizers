% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic
taps = [3:10];
step = 0.075;
% step = linspace(1E-4,1E-1,25);
trainNum = 2.^4;
% trainNum = 2.^(3:9);
indxM = combvec(taps,trainNum,step);
runLen = 20;
runTo = size(indxM,2)
fullRun = runTo*runLen
ww = ones(4,runTo,runLen);
len = 13;
for indx = 1:runTo
    ber = lmsPick(indxM(:,indx),len,true);
    w = combvec(indxM(:,indx),ber);
    w = w';
    ww(:,indx,len) = w;
    %         if mod(indx,1000)== 0
    %             indx
    %         end
    
end
xx = ww(:,:,len);
toc
save('scan7v1','xx')
%%

[mn,mi] = min(xx(4,:));
xx(:,mi)
xx(4,mi)





