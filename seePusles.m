%% Plot and DSP
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
tic
%% load files
load('impulse.mat')
outSig1 = real(InNode{1,1}.Signal.samples);
load('pam_pow_19_len_1000_0033.mat')
rx = real(InNode{1,1}.Signal.samples);
inSig = real(InNode{1,2}.Signal.samples);

%% rescale [0,1]
rx = rx - min(rx);
rx = rx/max(rx);
outSig1 = outSig1 -min(outSig1);
scale = 1/max(outSig1);
imp = outSig1*scale;
imp = imp/sum(imp);

%% rescale [-3,3]
rx = 1.2*(rx -0.5) *6;
inSig = (inSig -0.5) *6;

%% make filter
filt = imp;
filt(filt<0.005) = 0; % zero out small values

% get inv in freq
H = fft(filt);
Hinv = 1./H;
filt = ifft(Hinv);

filt(abs(filt)<0.0005) = 0; % zeros out small values
filt = filt/sum(filt); % scale

%% plot filter
x = filter(filt,1,imp);
y = filter(imp,1,filt);
figure()
subplot(3,1,1)
plot(x)
title('Impluse -> Inv Filt')

subplot(3,1,2)
plot(imp)
title('Impluse')

subplot(3,1,3)
plot(filt)
title('Inv Filt')
saveas(gcf,'noSq.png')

%% make square filter
n = 8;
sq = ones(1,n);
sq = sq/n; 

%% filter
snr = 20;
delayImp = 68;
delaySq = n -1;
% noise
rx_noise = awgn(rx,snr,'measured');
filtSig = filter(imp,1,rx_noise);
filtSig2 = filter(sq,1,rx_noise);

% no noise
filtSig_no = filter(imp,1,rx);
filtSig_no2 = filter(sq,1,rx);

% manage delay
filtSig = filtSig(delayImp:end);
filtSig2 = filtSig2(delaySq:end);
filtSig_no = filtSig_no(delayImp:end);
filtSig_no2 = filtSig_no2(delaySq:end);

%% plots
start = 100;
cut = 2^8;
cut = start + cut;

% impulse filter
figure()
subplot(2,2,1)
plot(imp)
title('Filter Coef.')

subplot(2,2,2)
hold on
plot(rx(start:cut))
plot(rx_noise(start:cut))
title('With Noise')
hold off

subplot(2,2,3)
hold on
plot(rx(start:cut))
plot(filtSig(start:cut))
title('Filtered')
hold off

subplot(2,2,4)
hold on
plot(inSig(start:cut))
plot(filtSig(start:cut))
title('Filtered and Tx')
hold off

saveas(gcf,'impFilter.png')

% square filter
figure()
subplot(2,2,1)
plot(sq)
title('Filter Coef.')

subplot(2,2,2)
hold on
plot(rx(start:cut))
plot(rx_noise(start:cut))
title('With Noise')
hold off

subplot(2,2,3)
hold on
plot(rx(start:cut))
plot(filtSig2(start:cut))
title('Filtered')
hold off

subplot(2,2,4)
hold on
plot(inSig(start:cut))
plot(filtSig2(start:cut))
title('Filtered and Tx')
hold off

saveas(gcf,'sqFilter.png')
toc

%% eyes
% symPer = 32;
% offset = 12;
% cut = 2^13;
% eyediagram(rx(1:cut),symPer,symPer,offset)
% saveas(gcf,'eye_noF_noN.png')
% eyediagram(rx_noise(1:cut),symPer,symPer,offset)
% saveas(gcf,'eye_noF_noN.png')
% eyediagram(filtSig(1:cut),symPer,symPer,offset)
% saveas(gcf,'eye_F_N.png')
% eyediagram(filtSig_no(1:cut),symPer,symPer,offset)
% saveas(gcf,'eye_F_noN.png')
% toc