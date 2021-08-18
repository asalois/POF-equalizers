%% Proakis Synthetic Channel Equilization with Deep NNs

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc; clear; close all
tic
ber = zeros(1,39);
%%
for i = 5:35
    lname = sprintf('snr%02d/testDataSnr%02d.mat',i,i);
    load(lname)
    rname = sprintf('predictionsSNR%02d.mat',i);
    load(rname);
    testTarget = (testTarget - 0.5 ) * 6;
    pred = (pred - 0.5 ) * 6;
    x_b = pamdemod(testTarget,4);
    y_b = pamdemod(pred',4);
    [~, ber_dnn] = biterr(x_b,y_b)
    ber(i) = ber_dnn;
end
toc
%%
snr = 1:39;
figure()
semilogy(snr,ber,'-*')
saveas(gcf,'bernn.png')
save('berDNNTF','ber')
