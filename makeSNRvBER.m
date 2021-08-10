% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic
fiberLength = 13;
iters = 100;
[berA, x] = lmsSNRvBER([2 2^10 0.01],fiberLength,50);
toc
[berB, ~] = dfeSNRvBER([2 1 2^7],fiberLength,iters);
toc
[berC, ~] = dfeSNRvBER([2 1 2^8],fiberLength,iters);
toc

%%
tic
[berE, ~] = annSNRvBER(40,(2^17 - 30),5000,fiberLength,1);
toc
[berF, ~] = annlSNRvBER(40,(2^17 - 30),5000,fiberLength,1);
toc
berD = [berA; berB; berC; berE; berF];


%%
figure()
semilogy(x,berD','-*')
xlabel('SNR [dB]')
ylabel('BER')
legend('NO EQ','LMS','DFE 128','DFE 256','ANN','Linear ANN','Location','southwest')
title('EQs for 13 m POF')
saveas(gcf,'Eqsfor13mPOF_2.png')
save('Eqsfor13mPOF_2')
% toc
