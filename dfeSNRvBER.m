function [berR, x]=dfeSNRvBER(inM,fLen,iters)
% DFE EQ Graph
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% runToSNR = inM(1);
taps = inM(1);
fTaps = inM(2);
trainNum = inM(3);
refTap = ceil(taps/2);

% load file
loadName = sprintf('pam_snr_%02d_len_%04d_%04d',97,fLen*10,1);
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
berR = zeros(iters,runTo - start);
berRDfe = zeros(iters,runTo - start);
x =  start:runTo;
for i = 1:iters
    for snr = start:runTo
        
        selectOutSNR =  awgn(selectOut,snr,'measured');
        % define number of symbols to train EQ
        numTrainSymbols = trainNum;
        trainingSymbols = selectOutSNR(1:numTrainSymbols);
        
        % eq setup
        dfe = comm.DecisionFeedbackEqualizer('Algorithm','RLS','NumForwardTaps',taps, ...
           'NumFeedbackTaps', fTaps,'ReferenceTap',refTap,...
           'Constellation',real(pammod(0:3,4)));
        
        % Use LMS Equalizer
        [dfeOut] = dfe(selectOutSNR',trainingSymbols')';
        if any(isnan(dfeOut))
            berDfe = 2;
        else
            bitsIn = pamdemod(selectIn,M);
            bitsOut = pamdemod(selectOutSNR,M);
            bitsLmsOut = pamdemod(dfeOut,M);
            if length(bitsIn) < length(bitsOut)
                bitsOut = bitsOut(1:length(bitsIn));
                bitsLmsOut = bitsLmsOut(1:length(bitsIn));
            elseif length(bitsOut) < length(bitsIn)
                bitsIn = bitsIn(1:length(bitsOut));
            end
            delay = refTap - 1;
            cut1 = bitsIn(1:end-delay);
            cut2 = bitsLmsOut(delay+1:end);
            % get BER
            [~,berDfe] = biterr(cut1,cut2);
        end
        berRDfe(i,snr - (start-1)) = berDfe;
    end
end
berR = min(berRDfe,[],1);
end