function [berR, x]=dfeSNRvBER(inM,fLen,iters,folder)
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
loadName = sprintf('pamSnr%02d/pam_snr_%02d_len_%04d_%04d',folder,folder,fLen*10,1);
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
berRDfe = zeros(iters,runTo - (start-1));
x =  start:runTo;
parfor i = 1:iters
    berz = zeros(1,runTo - (start-1));
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
            bitsLmsOut = pamdemod(dfeOut,M);
            delay = refTap - 1;
            cut1 = bitsIn(1:end-delay);
            cut2 = bitsLmsOut(delay+1:end);
            % get BER
            [~,berDfe] = biterr(cut1,cut2);
        end
        berz(snr - (start-1)) = berDfe;
    end
    berRDfe(i,:) = berz;
end
berR = min(berRDfe,[],1);
end
