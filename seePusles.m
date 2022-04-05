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
filt = outSig1*scale;

%% rescale [-3,3]
rx = 1.2*(rx -0.5) *6;
inSig = (inSig -0.5) *6;

%% cut
start = 100;
done = 16*10000*2;
% done = 16*10*2;
rx = rx(start:start+done);
inSig = inSig(start:start+done);

%% make filter
filt(filt<0.005) = 0;
H = fft(filt);
Hinv = 1./H;
filt = ifft(Hinv);
% filt = filt(60:80);
filt(abs(filt)<0.0005) = 0;
filt = filt/sum(filt);
n = 16;
sq = ones(1,n);
sq = sq /n; 

%% filter
snr = 20;
delay = 66;
% noise
rx_noise = awgn(rx,snr,'measured');
filtSig = filter(filt,1,rx_noise);
filtSig2 = filter(sq,1,filtSig);

% no noise
filtSig_no = filter(filt,1,rx);
filtSig_no2 = filter(sq,1,filtSig_no);

% manage delay
filtSig = filtSig(delay:end);
filtSig2 = filtSig2(delay:end);
filtSig_no = filtSig_no(delay:end);
filtSig_no2 = filtSig_no2(delay:end);

%% plots
start = 100;
cut = 2^8;
cut = start + cut;

%single filter
figure()
subplot(2,2,1)
plot(filt)
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

saveas(gcf,'singleFilter.png')
toc

% douebl filter
figure()
subplot(2,2,1)
plot(filt)
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

saveas(gcf,'doubleFilter.png')
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