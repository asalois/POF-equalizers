function ber = lmsPick(inM,fLen,plotFlag)
% LMS EQ param scan
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% runToSNR = inM(1);
taps = inM(1);
trainNum = inM(2);
step = inM(3);
refTap = floor(taps/2);

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

% define number of symbols to train EQ
numTrainSymbols = trainNum;
trainingSymbols = selectOut(1:numTrainSymbols);

% eq setup
lineq = comm.LinearEqualizer('Algorithm','LMS', 'NumTaps',taps,'ReferenceTap',refTap,...
    'InputSamplesPerSymbol',1,'Constellation',real(pammod(0:3,4)),'StepSize',step);

% Use LMS Equalizer
[lmsOut] = lineq(selectOut',trainingSymbols')';
if any(isnan(lmsOut))
    ber = 2;
else
    if plotFlag == true
        titleN = sprintf('Taps = %04d',taps);
        figure()
        
        subplot(3,1,1)
        histogram(selectIn)
        xlim([-5 5])
        
        subplot(3,1,2)
        histogram(selectOut)
        xlim([-5 5])
        
        subplot(3,1,3)
        histogram(lmsOut)
        xlim([-5 5])
        
        sgtitle(titleN)
    end
    
    bitsIn = pamdemod(selectIn,M);
    bitsOut = pamdemod(selectOut,M);
    bitsLmsOut = pamdemod(lmsOut,M);
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
    [~,ber] = biterr(cut1,cut2);
end

end