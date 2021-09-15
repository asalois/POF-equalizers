 %% Get data from Optsim mat files
clear; clc; close all;
tic
rng(123)
runNum = 1;
runTo = 32;
runLen = 60;
step = 10;
[~,mStep] = size(10:step:runLen);
berA = ones(mStep,runTo);
rep = 8;
M = 4;
for j = 10:step:runLen
    for i = 1:runTo
        % load file
        loadName = sprintf('pam_snr_%02d_len_%04d_%04d',97,j,runNum);
        load(loadName)
        grabBit = log2(M)*2^pointsPerBit;
        startOut = 8*floor(grabBit/16);
        % rescale to work with pamdemod
        inSig = real(InNode{1,2}.Signal.samples);
        inSig = inSig*6 -3;
        outSig = real(InNode{1,1}.Signal.samples);
        outSig = outSig - min(outSig);
        outSig = outSig/max(outSig);
        outSig = outSig*6 -3;
        
        % repliacte for better BER
        inSig = repmat(inSig,1,rep);
        outSig = repmat(outSig,1,rep);
        
        % add niose
        outSigSNR = awgn(outSig,i,'measured');
        
        % set delay
        delay = 0;
        inSig = inSig(1:end-delay);
        outSigSNR = outSigSNR(delay+1:end);
        
        % grab one bit per symbol
        selectIn = inSig(4:grabBit:end);
        selectOut = outSigSNR(startOut:grabBit:end);
        
        % demod
        bitsIn = pamdemod(selectIn,M);
        bitsOut = pamdemod(selectOut,M);
        
        % get BER
        [numWrong,ber] = biterr(bitsIn,bitsOut);
        berA(ceil(j/step),i) = ber;
        names{ceil(j/step)} = sprintf('%4d m',j/10);
    end
end
nnz(~berA)

%%
figure()
semilogy(berA','-*')
legend(names,'Location','southwest')
xlabel('OSNR [dB]')
ylabel('BER')
title('OSNR vs BER for no DSP')
saveas(gcf,'OSNRvsBER.png')
toc
