% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic
stp = 25;

% multi Param Sweep
% taps = [2:(stp-1) stp:stp:1000];
% taps = 2:10;
step = linspace(1E-4,1E-1,25);
trainNum = 2.^(7:15);

% single Param Sweep
taps = 10;
% step = 0.073;
% trainNum = 2.^10;

indxM = combvec(taps,trainNum,step);
runLen = 20;
runTo = size(indxM,2)
fullRun = runTo*runLen
ww = ones(5,runTo,runLen);
len = 13;
parfor indx = 1:runTo
    [ber,delay] = lmsPick(indxM(:,indx),len,false);
    w = combvec(indxM(:,indx),delay,ber);
    w = w';
    ww(:,indx,len) = w;
    %         if mod(indx,1000)== 0
    %             indx
    %         end
    
end
xx = ww(:,:,len);

%%
% toc
% save('scanV1','xx')
xx = ww(:,:,13);

[mn,mi] = min(xx(5,:));
xx(:,mi)
xx(5,mi)
toc




