% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic
fiberLength = 13;
iters = 10000;
[berA, x] = lmsSNRvBER([2 2^10 0.01],fiberLength,iters);
toc
[berB, ~] = dfeSNRvBER([2 1 2^7],fiberLength,iters);
toc
[berC, ~] = dfeSNRvBER([2 1 2^8],fiberLength,iters);
toc
berD = [berA; berB; berC;];


%%
figure()
semilogy(x,berD','-*')
xlabel('SNR [dB]')
ylabel('BER')
legend('NO EQ','LMS','DFE 128','DFE 256','Location','southwest')
title('EQs for 13 m POF')
saveas(gcf,'Eqsfor13mPOF.png')
save('Eqsfor13mPOF')
toc
