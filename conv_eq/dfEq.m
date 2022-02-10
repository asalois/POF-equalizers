function rxDFE = dfEq(filtSig,taps,fTaps,numSymbols)
% Adaptive Linear Equilizer using Least Mean Squares
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% define number of symbols to train EQ
numTrainSymbols = numSymbols;
trainingSymbols = filtSig(1:numTrainSymbols);

dfe = comm.DecisionFeedbackEqualizer('Algorithm','RLS','NumForwardTaps',taps, ...
    'NumFeedbackTaps', fTaps,'ReferenceTap',floor(taps/2),...
     'Constellation',real(pammod(0:3,4)));

% USE DFE
[rxDFE] =  dfe(filtSig,trainingSymbols);
end
