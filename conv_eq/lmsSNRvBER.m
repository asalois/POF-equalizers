% function [berR,x]=lmsSNRvBER(inM,fLen,iters,folder)
function [berR,x]=lmsSNRvBER(inM,fLen,iters)
% LMS EQ Graph
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% runToSNR = inM(1);
taps = inM(1);
trainNum = inM(2);
step = inM(3);
refTap = ceil(taps/2);

% load file
% loadName = sprintf('pamSnr%02d/pam_snr_%02d_len_%04d_%04d',folder,folder,fLen*10,1);
% loadName = sprintf('~/DataDrive/optSimData/pam_pow_%02d_len_%04d_%04d',20,fLen*10,1);
loadName = sprintf('pam_pow_%02d_len_%04d_%04d',20,fLen*10,1);
load(loadName)

load('filterB')
b=b;

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
% outSigSNR = outSig;
startOut = 16;
delay = 14;
selectIn = inSig(4:symbolPeriod:end);


start = 5;
runTo = 35;
berRLMS = zeros(iters,runTo - (start -1));
x =  start:runTo;
for i = 1:iters
    berz = zeros(1,runTo - (start -1));
    for snr = start:runTo
        outSigSNR = awgn(outSig, snr, 'measured');
        filtered = filter(b, 1, outSigSNR);
        filtered = 1.2*filtered;
        filtered = filtered(delay:end);
        selectOut = filtered(startOut:symbolPeriod:end);
        % define number of symbols to train EQ
        numTrainSymbols = trainNum;
        trainingSymbols = selectOut(1:numTrainSymbols);
        
        % eq setup
        lineq = comm.LinearEqualizer('Algorithm','LMS', 'NumTaps',taps,'ReferenceTap',refTap,...
            'InputSamplesPerSymbol',1,'Constellation',real(pammod(0:3,4)),'StepSize',step);
        
        % Use LMS Equalizer
        [lmsOut] = lineq(selectOut',trainingSymbols')';
        if any(isnan(lmsOut))
            berLMS = 2;
        else
            bitsIn = pamdemod(selectIn(1:end-1),M);
            bitsLmsOut = pamdemod(lmsOut,M);
            % get BER
            [~,berLMS] = biterr(bitsIn,bitsLmsOut);
        end
        berz(snr - (start-1)) = berLMS;
    end
    berRLMS(i,:) = berz;
end
berR = min(berRLMS,[],1);
end
