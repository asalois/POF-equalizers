% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic
stp = 20;
taps = [2 5 10 15 stp:stp:240];
% step = 8E-2;
step = linspace(1E-4,1E-2,20);
% trainNum = 2.^(8:14);
% trainNum = 2.^(5:11);
trainNum = 2.^6;
indxM = combvec(taps,trainNum,step);
runLen = 20;
runTo = size(indxM,2)
fullRun = runTo*runLen
ww = ones(4,runTo,runLen);

parfor len = 1:runLen
    for indx = 1:runTo
        ber = lmsPick(indxM(:,indx),len,false);
        w = combvec(indxM(:,indx),ber);
        w = w';
        ww(:,indx,len) = w;
        if mod(indx,1000)== 0
            indx
        end
        
    end
    len
end
toc
% save('scanV3','ww','runLen');
%%
clear
load('scanV3.mat')
runLen = 20;
best = zeros(4,runLen);
worst = zeros(4,runLen);
mn = ones(runLen,2);
mx = ones(runLen,2);
for i = 1:runLen
    [mn(i,1),mn(i,2)] = min(abs(ww(4,:,i)));
    [mx(i,1),mx(i,2)] = max(ww(4,:,i));
    best(:,i) = ww(:,mn(i,2),i);
    worst(:,i) = ww(:,mx(i,2),i);
end
% save('scanV3','ww','runLen','mn','mx','best','worst');
% stp = 4;
% for f = 1:stp:runLen
%     labels{ceil(f/stp)} = sprintf('Fiber Length %2d m',f);
%     if f~=1
%         tapsx = [tapsx ww(2,:,f)'];
%         trainx = [trainx ww(3,:,f)'];
%         stepx = [stepx ww(4,:,f)'];
%         ber = [ber ww(5,:,f)'];
%     else
%         tapsx = ww(2,:,f)';
%         trainx = ww(3,:,f)';
%         stepx = ww(4,:,f)';
%         ber = ww(5,:,f)';
%     end
% end
% figure(1)
% semilogy(tapsx,ber,'-*')
% legend(labels,'Location','northeast')
% title('Taps')
% xlabel('BER')
% ylabel('Taps')
% 
% figure(2)
% semilogy(trainx,ber,'-*')
% legend(labels,'Location','northeast')
% title('Train Number')
% xlabel('BER')
% ylabel('Train Number')
% 
% figure(3)
% semilogy(stepx,ber,'-*')
% legend(labels,'Location','northeast')
% title('Step')
% xlabel('BER')
% ylabel('Step')


