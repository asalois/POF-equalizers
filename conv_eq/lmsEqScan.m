% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic
stp = 25;
taps = [2:(stp-1) stp:stp:1000];
step = linspace(1E-4,1E-1,50);
trainNum = 2.^(3:14);
indxM = combvec(taps,trainNum,step);
runLen = 20;
runTo = size(indxM,2)
fullRun = runTo*runLen
ww = ones(5,runTo,runLen);
parfor len = 1:runLen
    for indx = 1:runTo
    [ber,delay] = lmsPick(indxM(:,indx),len,false);
    w = combvec(indxM(:,indx),delay,ber);
    w = w';
    ww(:,indx,len) = w;     
    end
end
save('scanV1','ww');
toc


