%% Proakis Synthetic Channel Equilization with Deep NNs

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc; clear; close all 
tic
ber = zeros(5,31);
M = 4;
%% 
samples = [1,2,4,8,16]
for j = 1:length(samples)
    for i = 1:31
        snr = i + 4;
        rname = sprintf('predictionsSNR%02d_%02d.mat',snr,samples(j));
        try
            load(rname);
        catch
            break
        end
        [~,maxIndx] = max(pred',[],1);
        predSeq = -1 * pammod(maxIndx -1,M);  
        [~,maxIndx] = max(testTarget',[],1);
        testSeq = -1 * pammod(maxIndx -1,M);  
        x_b = pamdemod(testSeq,4);
        y_b = pamdemod(predSeq,4);
        [~, ber_dnn] = biterr(x_b,y_b);
        ber(j,i) = ber_dnn;
    end
%%
end
ber'
saveName = 'berFilt';
save(saveName,'ber')
toc
