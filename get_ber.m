%% Proakis Synthetic Channel Equilization with Deep NNs

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc; clear; close all 
tic
ber = zeros(10,31);
labels = cell(1,10);
%%
for samples = 1:10
    name = cellstr(sprintf('%d Samples',samples))
    labels(samples) = name;
    for i = 1:31
        snr = i + 4;
        lname = sprintf(...
            '/home/alexandersalois/DataDrive/Research-OneDrive/nnTrainData/fiberLen100/%02d_samples/snr%02d/testDataSnr%02d.mat'...
            ,samples,snr,snr);
        load(lname)
        rname = sprintf(...
            '%dpredictionsSNR%02d.mat'...
            ,samples,snr);
        load(rname);
        testTarget = (testTarget - 0.5 ) * 6;
        pred = (pred - 0.5 ) * 6;
        x_b = pamdemod(testTarget,4);
        y_b = pamdemod(pred',4);
        [~, ber_dnn] = biterr(x_b,y_b)
        ber(samples,i) = ber_dnn;
    end
end
toc
%%
snr = 5:35;
figure()
semilogy(snr,ber,'-*')
title('SNR vs BER for 20 m POF')
ylabel('BER')
xlabel('SNR (dB)')
legend(labels)
saveas(gcf,'bernn.png')
save('berDNNTF','ber')

