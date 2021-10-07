% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
%% 100 m POF
% load('pam_pow_18_len_1000_0001.mat')
% 
% inSig = real(InNode{1,2}.Signal.samples);
% outSig = real(InNode{1,1}.Signal.samples);
% outSig = outSig - min(outSig);
% outSig = outSig/max(outSig);
% 
% 
% eyediagram(outSig(1:5000),16,1,4)

% start = 1600;
% cut = start:start+320;
% figure()
% subplot(2,1,2)
% plot(outSig(cut))
% title('RX 100 m')
% 
% subplot(2,1,1)
% plot(inSig(cut))
% title('TX 100 m')

%% 50 m POF
load('pam_pow_18_len_1000_0001.mat')

inSig = real(InNode{1,2}.Signal.samples);
outSig = real(InNode{1,1}.Signal.samples);
outSig = outSig - min(outSig);
outSig = outSig/max(outSig);

startOut = 16;
symbolPeriod = 16;
selectOut = outSig(startOut:symbolPeriod:end);
selectOutSamples = outSig;
selectOutSamples(setdiff(1:end,startOut:symbolPeriod:end)) = 0;

% eyediagram(outSig(1:5000),16,1,15)

start = 1600;
cut = start:start+320;
figure()
hold on
plot(outSig(cut))
plot(inSig(cut))
stem(selectOutSamples(cut))
hold off
title('50 m')

figure()
histogram(outSig)

figure()
histogram(selectOut)