function [ber]=lmsEq(seq,ref,taps,train,step)
% LMS EQ Graph
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

refTap = ceil(taps/2);
M = 4;
show = 10;       
% eq setup
lineq = comm.LinearEqualizer('Algorithm','LMS', 'NumTaps',taps,'ReferenceTap',refTap,...
    'InputSamplesPerSymbol',1,'Constellation',real(pammod(0:3,4)),'StepSize',step);

%lineq.AdaptAfterTraining = true
% Use LMS Equalizer
[lmsOut,err,w] = lineq(seq',train');
lmsOut = lmsOut';
st = 10000;
%seq(st:st+show)
%lmsOut(st:st+show)
%ref(st:st+show)
if any(isnan(lmsOut))
    ber = 2;
else
    delay = 0;
    cut1 = ref(1:end-delay);
    cut2 = lmsOut(delay+1:end);
    %cut1 = lmsOut(1:end-delay);
    %cut2 = ref(delay+1:end);
    bitsIn = pamdemod(cut1,M);
    bitsLmsOut = pamdemod(cut2,M);
    %bitsIn(st:st+show)
    %bitsLmsOut(st:st+show)
    % get BER
    [errs,ber] = biterr(bitsIn,bitsLmsOut);
    %[~,ber] = biterr(cut1,cut2);
end
end
