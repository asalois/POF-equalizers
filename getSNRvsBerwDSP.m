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
for len = 10:step:runLen
    for i = 1:runTo
        % load file
        loadName = sprintf('pam_snr_%02d_len_%04d_%04d',97,len,runNum);
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
        
        % filter 
        fil = ones(1,grabBit)/grabBit;
        outSigSNR = filter(fil,1,outSigSNR);
        
        % set delay
        if len == 10
            delay = floor(0.5*grabBit);
        elseif len == 20
            delay = floor(0.55*grabBit);
        elseif len == 30
            delay = floor(0.6*grabBit);
        elseif len == 40
            delay = floor(0.65*grabBit);
        elseif len == 50
            delay = floor(0.7*grabBit);
        elseif len == 60
            delay = floor(0.75*grabBit);
        elseif len == 70
            delay = floor(0.8*grabBit);
        elseif len == 80
            delay = floor(0.85*grabBit);
        elseif len == 90
            delay = floor(0.9*grabBit);
        elseif len == 100
            delay = floor(0.9*grabBit);
        elseif len == 110
            delay = floor(0.9*grabBit);
        else
            delay = floor(1*grabBit);
        end
        
        inSig = inSig(1:end-delay);
        outSigSNR = outSigSNR(delay+1:end);
        
        % grab one bit per symbol
        selectIn = inSig(4:grabBit:end);
        selectOut = outSigSNR(startOut:grabBit:end);
        
        % demod
        bitsIn = pamdemod(selectIn,M);
        bitsOut = pamdemod(selectOut,M);
        
        % make same size
        if length(bitsIn) < length(bitsOut)
            bitsOut = bitsOut(1:length(bitsIn));
        elseif length(bitsOut) < length(bitsIn)
            bitsIn = bitsIn(1:length(bitsOut));
        end
        
        % get BER
        [numWrong,ber] = biterr(bitsIn,bitsOut);
        berA(ceil(len/step),i) = ber;
        names{ceil(len/step)} = sprintf('%4d m',len/10);
    end
    
%     sel = 1:2^7;
%     figure()
%     hold on
%     plot(selectIn(sel))
%     plot(selectOut(sel))
%     hold off
    
%     sel = 1:2^9;
%     figure()
%     hold on
%     plot(inSig(sel))
%     plot(outSigSNR(sel))
%     hold off
end
nnz(~berA)

%%
figure()
semilogy(berA','-*')
legend(names,'Location','southwest')
xlabel('OSNR [dB]')
ylabel('BER')
title('OSNR vs BER with Electronic Filtering')
saveas(gcf,'OSNRvsBERwFiltering.png')
toc