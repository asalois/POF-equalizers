% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
% clear; clc; close all;
% myCell = cell(20,2,1); % (fiberLen, [in out], runNum)
% snr = 91;
% for fl = 1:20
%     for  rn = 1:32
%         loadName = sprintf('pam_snr_%02d_len_%04d_%04d',snr,fl*10,rn);
%         try
%             load(loadName)
%         catch
%             break
%         end
%         
%         % rescale
%         inSig = real(InNode{1,2}.Signal.samples);
%         outSig = real(InNode{1,1}.Signal.samples);
%         outSig = outSig - min(outSig);
%         outSig = outSig/max(outSig);
%         myCell{fl,1,rn} = inSig;
%         myCell{fl,2,rn} = outSig;
%         %         if snr == 97
%         %             myCell{fiberLen,1,runNum} = inSig;
%         %             myCell{fiberLen,2,runNum} = outSig;
%         %         else
%         %             myCell{fiberLen,1,runNum+1} = inSig;
%         %             myCell{fiberLen,2,runNum+1} = outSig;
%         %         end
%     end
% end
% %%
% saveName = sprintf('myCell%02d',snr)
% save(saveName,'myCell','-v7.3')
%%
tic
[a, b, c] = size(myCell)
M = 4;
% symbolPeriod = log2(M)*2^pointsPerBit; % in samples
symbolPeriod = 16;
startSNR = 5;
endSNR = 35;
trainData = cell(2,c,endSNR - (startSNR - 1));
fl = 13;
samples = 3;

for snr = startSNR:endSNR
    for i = 1:c
        outSig = myCell{fl,2,i};
        inSig = myCell{fl,1,i};
        outSigSNR = awgn(outSig,snr,'measured');
        startOut = 16;
        selectIn = inSig(4:symbolPeriod:end);
        selectOut = outSigSNR(startOut:symbolPeriod:end);
        
        m = makeInputMat(selectOut,samples);
        t = selectIn;
        t = t(samples+1:end-samples);
        trainData{2,i,snr-(startSNR -1)} = m;
        trainData{1,i,snr-(startSNR -1)} = t;
    end
end

%%
toc
rng(123)
for snr = startSNR:endSNR
    idx = randperm(32);
    test = idx(1:8)
    train = idx(9:end);
    z = reshape(train,8,3)
    testMat = trainData(:,test,snr-(startSNR -1));
    testTarget = cell2mat(testMat(1,:));
    testIn = cell2mat(testMat(2,:));
    testMat = trainData(:,setdiff(1:32,test),snr-(startSNR -1));
    testTrainTarget = cell2mat(testMat(1,:));
    testTrainIn = cell2mat(testMat(2,:));
    saveName = sprintf('testDataSnr%02d',snr)
    save(saveName,'testTarget','testIn','testTrainTarget','testTrainIn');
    
    cv={};
    cvFold = 8;
    for i = 1:cvFold
        cv = trainData(:,z(i,:),snr-(startSNR -1));
        cvTestTarget = cell2mat(cv(1,:));
        cvTestIn = cell2mat(cv(2,:));
        cv = trainData(:,z(setdiff(1:cvFold,i),:),snr-(startSNR -1));
        cvTrainTarget = cell2mat(cv(1,:));
        cvTrainIn = cell2mat(cv(2,:));
        saveName = sprintf('cv%02dDataSnr%02d',i,snr)
        save(saveName,'cvTestTarget','cvTestIn','cvTrainTarget','cvTrainIn');
    end
end
toc