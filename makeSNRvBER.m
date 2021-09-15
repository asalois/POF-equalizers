% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic
lines = 6
snrData = cell(1,lines);
labels = {};
snr = 90
for k = 20
    fiberLength = k
    iters = 200;
    
    for i = 1:lines
        tps =  [0  3  7  2  3  7];
        ftps = [0  0  0  1  2  4];
        trn =  [1  12 12 12 12 12];
        trn = 2.^trn;
            if i == 1
            snrData(1) = {noEqSNRvBER(fiberLength,1,snr)};
            labels(1) = cellstr('No Eq');
            
            elseif i < 4 && i > 1
                taps = tps(i);
                train = trn(i);
                snrData(i) = {lmsSNRvBER([taps train 0.01],fiberLength,iters,snr)};
                labels(i) = cellstr(sprintf('LMS taps=%d train=%d',taps,train));
           
            else
                taps = tps(i);
                fTaps = ftps(i);
                train = trn(i);
                snrData(i) = {dfeSNRvBER([taps fTaps train],fiberLength,iters,snr)};
                labels(i) = cellstr(...
                    sprintf('DFE taps=%d,%d train=%d',taps,fTaps,train));
            end
            toc
    end
    
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
x = 5:35;
figure()
y = reshape(cell2mat(snrData),31,lines);
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
