%% Plot and DSP

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic

% load file
loadName = sprintf('pam_snr_%02d_len_%04d_%04d',97,100,1)
load(loadName)

M = 4;
grabBit = log2(M)*2^pointsPerBit;

% rescale to work with pamdemod
inSig = real(InNode{1,2}.Signal.samples);
inSig = inSig*6 -3;
outSig = real(InNode{1,1}.Signal.samples);
outSig = outSig - min(outSig);
outSig = outSig/max(outSig);
outSig = outSig*6 -3;

rep = 1;
inSig = repmat(inSig,1,rep);
outSig = repmat(outSig,1,rep);

%%
runTo = 1;
x = 1:runTo;
berSNR = ones(2,runTo);
for SNR = 1:runTo
    
    outSigSNR = awgn(outSig,1000,'measured');
    startOut =16;
    
    % filter
%     fil = ones(1,grabBit)/grabBit;
%     outSigSNR = filter(fil,1,outSigSNR);
    
    % set delay
%     delay = floor(0.75*grabBit);
%     inSig = inSig(1:end-delay);
%     outSigSNR = outSigSNR(delay+1:end);
    
    % grab one bit per symbol
    selectIn = inSig(4:grabBit:end);
    selectOut = outSigSNR(startOut:grabBit:end);
%     figure()
%     histogram(selectOut,100)
    
    % use lms EQ
    taps = 10;
    trainNum = 2^10;
    lmsOut = lmsEq(selectOut',taps,trainNum);
    
    % use DFE EQ
%     taps = 2;
%     feedBackTaps = 5;
%     dfeOut = dfEq(selectOut',taps,feedBackTaps,trainNum);
%     dfeOut = 0;
    
    % use rls EQ
%     taps = 3;
%     rlsOut = rlsEq(selectOut',taps,trainNum);
    
    % demod
    bitsIn = pamdemod(selectIn,M);
    bitsOut = pamdemod(selectOut,M);
    bitsLmsOut = pamdemod(lmsOut,M);
%     bitsRlsOut = pamdemod(rlsOut,M);
%     bitsDfeOut = pamdemod(dfeOut,M);
    if length(bitsIn) < length(bitsOut)
        bitsOut = bitsOut(1:length(bitsIn));
        bitsLmsOut = bitsLmsOut(1:length(bitsIn));
%         bitsRlsOut = bitsRlsOut(1:length(bitsIn));
%         bitsDfeOut = bitsDfeOut(1:length(bitsIn));
    elseif length(bitsOut) < length(bitsIn)
        bitsIn = bitsIn(1:length(bitsOut));
    end
    shift = 5;
    cut1 = bitsIn(1:end-shift+1);
    cut2 = bitsLmsOut(shift:end)';
    % get BER
    [~,ber] = biterr(bitsIn,bitsOut);
    berSNR(1,SNR) = ber;
    [~,ber] = biterr(cut1,cut2);
    berSNR(2,SNR) = ber;
%     [~,ber] = biterr(bitsIn,bitsRlsOut');
%     berSNR(3,SNR) = ber;
%     [~,ber] = biterr(bitsIn,bitsDfeOut');
%     berSNR(4,SNR) = ber;
end
%     trainNum
%     ber

%%
figure()
% semilogy(x,berSNR(1,:),'-*',x,berSNR(2,:),'-*',x,berSNR(3,:),'-*',x,berSNR(4,:),'-*')
semilogy(x,berSNR(1,:),'-*',x,berSNR(2,:),'-*')
legend('No Eq','LMS','RLS','DFE','Location','southwest')
xlabel('OSNR [dB]')
ylabel('BER')
title('OSNR vs BER')
% end

%%

% sel = 1000:1000+2^7;
% for i  = 1:16
% select = outSig(i:grabBit:end);
% figure()
% histogram(select,100)
% end

%%
% sel = 1:2^15;
% % eyediagram(inSig(sel),2*2^pointsPerBit)
% eyediagram(outSigSNR(sel),4*2^pointsPerBit)

histogram(lmsOut(1000:2000),100)

toc
