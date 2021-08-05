% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic
fiberLength = 13;
iters = 100;
[berA, x] = lmsSNRvBER([2 2^10 0.01],fiberLength,iters);
toc
[berC, ~] = dfeSNRvBER([2 1 2^7],fiberLength,iters);
toc
berB = [berA; berC];


%%
figure()
semilogy(x,berB','-*')
xlabel('SNR [dB]')
ylabel('BER')
legend('NO EQ','LMS','DFE','Location','southwest')
title('EQs for 13 m POF')
% saveName = sprintf('SNRvBER_taps_%03d.png', i+1);
% saveas(gcf,saveName)
toc
