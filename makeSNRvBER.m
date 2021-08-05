% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic

taps = 2:10;
% trainNum = [16 16 32 16 64 128 32 128 128];
% stepSize = [0.075 0.0584 0.0584 0.0542 0.0209 0.0334 0.0459 0.0126 0.0251];

trainNum = ones(size(taps))*2^12;
stepSize = ones(size(taps))*0.01;

inM = [taps; trainNum; stepSize]';
fiberLength = 13;
% iters = 400;
% % [berL, x] = lmsSNRvBER([2 2^10 0.01],fiberLength,iters);
% for t = 5:12
%     if t == 5
%         [berD1, x] = dfeSNRvBER([2 1 2^t],fiberLength,iters);
%         berD = berD1;
%     else
%         [berD1, x] = dfeSNRvBER([2 1 2^t],fiberLength,iters);
%         berD = [berD; berD1];
%     end
%     names{t - 4} = sprintf('%04d Train',2^t);
% end
%%
% figure()
% % semilogy(x,berL','-*',x,berD','-*')
% semilogy(x,berD','-*')
% xlabel('SNR [dB]')
% ylabel('BER')
% % legend('NO EQ','LMS',names,'Location','southwest')
% legend(names,'Location','southwest')
% plotTitle = sprintf('SNR vs BER with %03d taps', taps);
% title(plotTitle)


%%
iters = 50;
% for i = 1:5
[berA, x] = lmsSNRvBER([2 2^10 0.01],fiberLength,iters);
tic
[berC, ~] = dfeSNRvBER([2 2^10 2^7],fiberLength,iters);
tic
berA = [berA; berC]
%     if i == 1
%         berB = berA;
%     else
%         berB = [berB; berA];
%     end
% end

%%
figure()
semilogy(x,berB','-*')
xlabel('SNR [dB]')
ylabel('BER')
% plotTitle = sprintf('SNR vs BER with %03d taps', i+1);
title(plotTitle)
% saveName = sprintf('SNRvBER_taps_%03d.png', i+1);
% saveas(gcf,saveName)

% toc
