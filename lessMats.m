% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
myCell = cell(20,2,1); % (fiberLen, [in out], runNum)
snr = 90;
for fl = 1:20
    for  rn = 1:20
        loadName = sprintf('pam_snr_%02d_len_%04d_%04d',snr,fl*10,rn);
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
        myCell{fl,1,rn} = inSig;
        myCell{fl,2,rn} = outSig;
        %         if snr == 97
        %             myCell{fiberLen,1,runNum} = inSig;
        %             myCell{fiberLen,2,runNum} = outSig;
        %         else
        %             myCell{fiberLen,1,runNum+1} = inSig;
        %             myCell{fiberLen,2,runNum+1} = outSig;
        %         end
    end
end

%%
[a, b, c] = size(myCell)
M = 4;
symbolPeriod = log2(M)*2^pointsPerBit; % in samples
trainData = cell(2,c);
for i = 1:c
    outSig = myCell{13,2,i};
    inSig = myCell{13,1,i};
    outSigSNR = outSig;
    startOut = 16;
    selectIn = inSig(4:symbolPeriod:end);
    selectOut = outSigSNR(startOut:symbolPeriod:end);
    
    samples = 4;
    m = makeInputMat(selectOut,samples);
    t = selectIn;
    t = t(samples+1:end-samples);
    trainData{2,i} = m;
    trainData{1,i} = t;
end
% size(m)
% size(t)
% m(:,1:10)
% t(1:10)

%%
rng(123)
idx = randperm(20);
test = idx(1:4);
train = idx(5:end);
z = reshape(train,4,4)
testMat = trainData(:,test);
testTarget = cell2mat(testMat(1,:));
testIn = cell2mat(testMat(2,:));
save('testData','testTarget','testIn');
cv={};
for i = 1:4
    cv = trainData(:,z(i,:));
    cvTestTarget = cell2mat(cv(1,:));
    cvTestIn = cell2mat(cv(2,:));
    cv = trainData(:,z(setdiff(1:4,i),:));
    cvTrainTarget = cell2mat(cv(1,:));
    cvTrainIn = cell2mat(cv(2,:));
    saveName = sprintf('cv%dData',i);
    save(saveName,'cvTestTarget','cvTestIn','cvTrainTarget','cvTrainIn');
end


