% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
function [trainIn, trainTarget, testIn, testTarget, testSeq] = getNNData(snr,numSigs)
myCell = cell(2,1);
loadFilePath = "/home/alexandersalois/DataDrive/optSimData/";
pow = 19;
fl = 100;
for  rn = 1:numSigs
    loadName = loadFilePath + sprintf('pam_pow_%02d_len_%04d_%04d',pow,fl*10,rn);
    load(loadName);

    % rescale
    inSig = real(InNode{1,2}.Signal.samples);
    outSig = real(InNode{1,1}.Signal.samples);
    outSig = outSig - min(outSig);
    outSig = outSig/max(outSig);
    myCell{1,rn} = inSig;
    myCell{2,rn} = outSig;
end
clearvars -except myCell numSigs savePath snr

[b, c] = size(myCell);
M = 4;
symbolPeriod = 16;
samples = 4
symbols = 1
trainData = cell(3,c);
for i = 1:c
    outSig = myCell{2,i};
    inSig = myCell{1,i};
    outSigSNR = awgn(outSig,snr,'measured');
    startOut = 16;
    selectIn = inSig(4:symbolPeriod:end);

    m = makeSymbolMat(outSigSNR,symbols,samples);
    t = makeClassMat(selectIn,symbols);
    trainData{3,i} = selectIn(1:end -(symbols-1));
    trainData{2,i} = m;
    trainData{1,i} = t;
end

%%
rng(snr)

% randomly select signals
idx = randperm(numSigs);
train = idx(1:numSigs*(7/8))
test = idx(numSigs*(7/8)+1:end)

% pick which signals go where
testMat = trainData(1:2,test);
testTarget = cell2mat(testMat(1,:));
testIn = cell2mat(testMat(2,:));
testSeq = cell2mat(trainData(3,test));

testMat = trainData(1:2,train);
trainTarget = cell2mat(testMat(1,:));
trainIn = cell2mat(testMat(2,:));
