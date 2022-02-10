function rxRLS = rlsEq(filtSig,taps,numSymbols)
% Adaptive Linear Equilizer using Least Mean Squares
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% define number of symbols to train EQ
numTrainSymbols = numSymbols;
trainingSymbols = filtSig(1:numTrainSymbols);

% eq setup
lineq = comm.LinearEqualizer('Algorithm','RLS', 'NumTaps',taps,'ReferenceTap',floor(taps/2),...
    'InputSamplesPerSymbol',1,'Constellation',real(pammod(0:3,4)));

% Use LMS Equalizer
[rxRLS] = lineq(filtSig,trainingSymbols);

end
