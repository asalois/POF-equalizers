function [ber, x]=dfeSNRvBER(seq,ref,taps,fTaps,trainNum)
% DFE EQ Graph
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
refTap = ceil(taps/2);

M = 4;

% define number of symbols to train EQ
trainingSymbols = seq(1:trainNum)';
seq = seq(trainNum+1:end)';
ref = ref(trainNum+1:end);

% eq setup
dfe = comm.DecisionFeedbackEqualizer('Algorithm','RLS','NumForwardTaps',taps, ...
    'NumFeedbackTaps', fTaps,'ReferenceTap',refTap,...
    'Constellation',real(pammod(0:3,4)));

% Use LMS Equalizer
[dfeOut] = dfe(seq,trainingSymbols)';
if any(isnan(dfeOut))
    ber = 2;
else
    bitsIn = pamdemod(ref,M);
    bitsLmsOut = pamdemod(dfeOut,M);
    delay = refTap - 1;
    cut1 = bitsIn(1:end-delay);
    cut2 = bitsLmsOut(delay+1:end);
    show = 20;
    cut1(1:show)
    cut2(1:show)
    % get BER
    [~,ber] = biterr(cut1,cut2);
end
end
