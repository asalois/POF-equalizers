% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
function makeTFData(snr,numSigs)
tic
myCell = cell(2,1);
% 	loadFilePath = "/home/v16b915/optSimData/";
%   savePath = "/mnt/lustrefs/scratch/v16b915/nnData/";
loadFilePath = "H:/OneDrive - Montana State University/optSimData/100Mbps/100m/19/"
savePath = "C:/POF-equalizers/data/";
pow = 19;
fl = 100
for  rn = 1:numSigs
    loadName = loadFilePath + sprintf('pam_pow_%02d_len_%04d_%04d',pow,fl*10,rn);
    load(loadName)

    % rescale
    inSig = real(InNode{1,2}.Signal.samples);
    outSig = real(InNode{1,1}.Signal.samples);
    outSig = outSig - min(outSig);
    outSig = outSig/max(outSig);
    myCell{1,rn} = inSig;
    myCell{2,rn} = outSig;
end
clearvars -except myCell numSigs savePath snr

[~, c] = size(myCell)
M = 4;
symbolPeriod = 16;
symbols = 1;
trainData = cell(3,c);
n = 8;
b = ones(1,n);
b = b/n;
delay = n/2;
if numSigs <65
    samples=[1,2,4,8,16];
else
    samples=[1,2,4,8];
end

for samplesPerSym = samples
    saveFilePath = savePath + sprintf('%02d_symbols/%02d_signals/%02d_samples/',1,numSigs,samplesPerSym)

    for i = 1:c
        outSig = myCell{2,i};
        inSig = myCell{1,i};
        outSigSNR = awgn(outSig,snr,'measured');
        selectIn = inSig(4:symbolPeriod:end);
        selectIn = selectIn(1:end -1);
        filtered = filter(b,1,outSigSNR);
        filtered = filtered(delay+1:end-(symbolPeriod - delay));
        m = makeSymbolMat(filtered,symbols,samplesPerSym);
        t = makeClassMat(selectIn,symbols);

        if length(m) ~= length(t)
            disp('No GO')
            length(m)
            length(t)
        end
        trainData{3,i} = selectIn(1:end -(symbols-1));
        trainData{2,i} = m;
        trainData{1,i} = t;
    end

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
    toc
end
end
