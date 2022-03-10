% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
% get FFE and DFE results

clear; clc; close all;
tic

ffe = zeros(31,4);
dfe = zeros(31,1);
fiberLength = 100;
iters = 1;
step = 0.00015;
%% run sim
for tap = 2:5
    ffe(:,tap-1) = lmsSNRvBER([tap 2^12 step],fiberLength,iters);
end
% dfe = dfeSNRvBER([2 1 2^12],fiberLength,iters)

%% plot
ber = [ffe];
semilogy(5:35,ber')
% legend("2","4","5")
% save('conv_100_ber', 'ber')
toc