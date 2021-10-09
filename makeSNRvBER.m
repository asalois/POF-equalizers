% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic
lines = 6
snrData = cell(1,lines);
labels = {};
fiberLength = 100
iters = 100;

for i = 1:lines
    tps =  [0  2  2  2  3  3];
    ftps = [0  0  0  1  1  2];
    trn =  [1  6  7  6  6  6];
    trn = 2.^trn;
    taps = tps(i);
    fTaps = ftps(i);
    train = trn(i);
    if i == 1
        snrData(1) = {noEqSNRvBER(fiberLength,1)};
        labels(1) = cellstr('No Eq');
        
    elseif i < 4 && i > 1
        snrData(i) = {lmsSNRvBER([taps train 0.01],fiberLength,iters)};
        labels(i) = cellstr(sprintf('LMS taps=%d train=%d',taps,train));
        
    else
        snrData(i) = {dfeSNRvBER([taps fTaps train],fiberLength,iters)};
        labels(i) = cellstr(...
            sprintf('DFE taps=%d,%d train=%d',taps,fTaps,train));
    end
    toc

    
    %
    %     x = 5:35;
    % 	figure()
    % 	semilogy(x,snrData,'-*')
    % 	xlabel('SNR [dB]')
    % 	ylabel('BER')
    % 	legend('NO EQ','LMS','DFE Train 128','DFE Train 256','Linear ANN','Location','southwest')
    % 	titleName = sprintf('EQs for %d m of POF',fiberLength);
    % 	title(titleName)
    % 	saveFigureName = sprintf('Eqsfor%02dmPOF.png',fiberLength);
    % 	saveas(gcf,saveFigureName)
    % 	saveName = sprintf('Eqsfor%02dmPOF',fiberLength);
    % 	save(saveName)
    % 	toc
end
%%
y = reshape(cell2mat(snrData),31,lines)
su = sum(y(15:end,:),1)
x = 5:35;
figure()
semilogy(x,y,'-*')
xlabel('SNR [dB]')
ylabel('BER')
legend(labels,'Location','northeast')
titleName = sprintf('EQs for %d m of POF',fiberLength);
title(titleName)
saveFigureName = sprintf('EqsSpanfor%02dmPOF.png',fiberLength);
saveas(gcf,saveFigureName)
saveName = sprintf('EqsSpanfor%02dmPOF',fiberLength);
save(saveName)
toc
