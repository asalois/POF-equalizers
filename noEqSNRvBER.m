% function [berR,x]=noEqSNRvBER(fLen,iters,folder)
function [berR,x]=noEqSNRvBER(fLen,iters)
% LMS EQ Graph
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% load file
% loadName = sprintf('pamSnr%02d/pam_snr_%02d_len_%04d_%04d',folder,folder,fLen*10,1);
loadName = sprintf('pam_pow_%02d_len_%04d_%04d',18,fLen*10,1);
load(loadName)

M = 4;
symbolPeriod = log2(M)*2^pointsPerBit; % in samples

% rescale to work with pamdemod
inSig = real(InNode{1,2}.Signal.samples);
inSig = inSig*6 -3;
outSig = real(InNode{1,1}.Signal.samples);
outSig = outSig - min(outSig);
outSig = outSig/max(outSig);
outSig = outSig*6 -3;

% outSigSNR = awgn(outSig,SNR,'measured');
outSigSNR = outSig;
startOut = 16;
selectIn = inSig(4:symbolPeriod:end);
selectOut = outSigSNR(startOut:symbolPeriod:end);

start = 5;
runTo = 35;
berR = zeros(iters,runTo - (start-1));
x =  start:runTo;
parfor i = 1:iters
    berz = zeros(1,runTo - (start -1));
    for snr = start:runTo    
        selectOutSNR =  awgn(selectOut,snr,'measured');
        
        bitsIn = pamdemod(selectIn,M);
        bitsOut = pamdemod(selectOutSNR,M);
        [~,ber] = biterr(bitsIn,bitsOut);  % get BER
        berz(snr-(start-1)) = ber;
    end
    berR(i,:) = berz;
end
berR = min(berR,[],1);
end
