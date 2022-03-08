% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
% get FFE and DFE results

clear; clc; close all;
tic

ffe = zeros(31,1);
dfe = zeros(31,1);
fiberLength = 100;
iters = 10;
%% run sim
lms = lmsSNRvBER([2 2^12 0.001],fiberLength,iters)
% dfe = dfeSNRvBER([2 1 2^12],fiberLength,iters)

%% plot
ber = [lms];
semilogy(5:35,ber')
save('conv_100_ber', 'ber')
toc