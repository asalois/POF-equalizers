% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
tic
myCell = cell(2,1); % (fiberLen, [in out], runNum)
%loadFilePath = "D:/OneDrive - Montana State University/optSimData/100Mbps/100m/19/";
%savePath = "D:/OneDrive - Montana State University/TF_data/";
%loadFilePath = "H:/OneDrive - Montana State University/optSimData/100Mbps/100m/19/";
%savePath = "C:/TF_data/";
loadFilePath = "/home/alexandersalois/DataDrive/optSimData/";
savePath = "/home/alexandersalois/DataDrive/TF_data/";
pow = 19;
fl = 100
numSigs = 32
for  rn = 1:numSigs
    loadName = loadFilePath + sprintf('pam_pow_%02d_len_%04d_%04d',pow,fl*10,rn);
    try
	load(loadName)
    catch
	break
    end

    % rescale
    inSig = real(InNode{1,2}.Signal.samples);
    outSig = real(InNode{1,1}.Signal.samples);
    outSig = outSig - min(outSig);
    outSig = outSig/max(outSig);
    myCell{1,rn} = inSig;
    myCell{2,rn} = outSig;
end
clearvars -except myCell numSigs savePath loadFilePath
toc
%%
[b, c] = size(myCell)
M = 4;
symbolPeriod = 16;
startSNR = 5;
endSNR = 35;
samples = 1
trainData = cell(3,c);
saveFilePath = savePath + sprintf("%02d_symbols/%02d_signals/",1,numSigs)
for snr = startSNR:endSNR

    for i = 1:c
	outSig = myCell{2,i};
	inSig = myCell{1,i};
	outSigSNR = awgn(outSig,snr,'measured');
	selectIn = inSig(4:symbolPeriod:end);

	m = makeSymbolMat(outSigSNR,1);
	t = makeClassMat(selectIn,samples);
	trainData{3,i} = selectIn(1:end -(samples-1));
	trainData{2,i} = m;
	trainData{1,i} = t;
    end
    toc

    rng(snr)
    % randomly select signals
    idx = randperm(numSigs);
    train = idx(1:numSigs*(6/8))
    test = idx(numSigs*(6/8)+1:numSigs*(7/8))
    val = idx(numSigs*(7/8)+1:end)

    % pick which signals go where
    testMat = trainData(1:2,test);
    testTarget = cell2mat(testMat(1,:));
    testIn = cell2mat(testMat(2,:));
    testSeq = cell2mat(trainData(3,test));

    testMat = trainData(1:2,train);
    trainTarget = cell2mat(testMat(1,:));
    trainIn = cell2mat(testMat(2,:));

    testMat = trainData(1:2,val);
    valTarget = cell2mat(testMat(1,:));
    valIn = cell2mat(testMat(2,:));

    % save the data
    saveName = saveFilePath + sprintf('testDataSnr%02d',snr)
    save(saveName,'testTarget','testIn','trainTarget','trainIn','testSeq','valTarget','valIn');
end
toc
