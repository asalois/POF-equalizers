% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% a file to get started with classicfaction
clear; clc; close all;
tic
graph = zeros(31,1);
fl = 100
pow = 19
rn = 33
M = 4
symbolPeriod = log2(M)*2^3
loadName = sprintf('pam_pow_%02d_len_%04d_%04d',pow,fl*10,rn);
load(loadName)
outSig = real(InNode{1,1}.Signal.samples);
outSig = outSig - min(outSig);
outSig = outSig/max(outSig);
% outSig = (outSig - 0.5 ) * 6;
inSig = real(InNode{1,2}.Signal.samples);
selectIn = inSig(4:symbolPeriod:end);
selectIn = (selectIn - 0.5 ) * 6;
startOut = 16;
n = 8;
b = ones(1,n);
b = b/n;
delay = n/2;
for i = 1:31
    snr = i + 4;
    outSigSNR = awgn(outSig,snr,'measured');
    filtered = filter(b,1,outSigSNR);
    filtered = filtered(delay:end);
    selectOut = filtered(startOut:startOut:end);
    selectOut = (selectOut - 0.5 ) * 6;
    x_b = pamdemod(selectIn(1:end-1),4);
    y_b = pamdemod(selectOut,4);
    [~, ber_dnn] = biterr(x_b,y_b)
    graph(i) = ber_dnn;
end
toc