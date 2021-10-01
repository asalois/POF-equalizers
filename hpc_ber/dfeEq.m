function [ber]=dfeEq(seq,ref,taps,fTaps,trainingSymbols)
% DFE EQ Graph
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
refTap = ceil(taps/2);

M = 4;

% eq setup
dfe = comm.DecisionFeedbackEqualizer('Algorithm','RLS','NumForwardTaps',taps, ...
    'NumFeedbackTaps', fTaps,'ReferenceTap',refTap,...
    'Constellation',real(pammod(0:3,4)));

% Use LMS Equalizer
[dfeOut] = dfe(seq',trainingSymbols')';
if any(isnan(dfeOut))
    ber = 2;
else
    %show = 10;
    %ref(100:100+show)
    %seq(100:100+show)
    %dfeOut(100:100+show)
    bitsIn = pamdemod(ref,M);
    bitsOut = pamdemod(dfeOut,M);
    %delay = 4;
    %cut1 = bitsIn(1:end-delay);
    %cut2 = bitsOut(delay+1:end);
    %cut3 = bitsOut(1:end-delay);
    %cut4 = bitsIn(delay+1:end);
    % get BER
    [~,ber] = biterr(bitsIn,bitsOut);
    %[~,ber] = biterr(cut1,cut2)
    %[~,ber] = biterr(cut4,cut3)
end
end
