% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic
taps = [2:15];
% step = 1E-2;
step = linspace(1E-3,1E-1,25);
% trainNum = 2.^(8:14);
% trainNum = 2.^(5:11);
trainNum = 2.^(3:9);
indxM = combvec(taps,trainNum,step);
runLen = 20;
runTo = size(indxM,2)
fullRun = runTo*runLen
ww = ones(4,runTo,runLen);
len = 7;
parfor indx = 1:runTo
    ber = lmsPick(indxM(:,indx),len,false);
    w = combvec(indxM(:,indx),ber);
    w = w';
    ww(:,indx,len) = w;
    %         if mod(indx,1000)== 0
    %             indx
    %         end
    
end
xx = ww(:,:,len);
toc

%%

[mn,mi] = min(xx(4,:));
xx(:,mi)





