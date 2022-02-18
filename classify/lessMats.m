% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
tic
myCell = cell(1,2,1); % (fiberLen, [in out], runNum)
%matFilePath = "/home/alexandersalois/DataDrive/optSimData/";
loadFilePath = "D:/OneDrive - Montana State University/optSimData/100Mbps/100m/19/";
savePath = "D:/OneDrive - Montana State University/TF_data/";
pow = 19;
% numSigs = 8;
for numSigs = [8,16,32,64]
    for fl = 100
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
            myCell{fl/100,1,rn} = inSig;
            myCell{fl/100,2,rn} = outSig;
        end
    end
    toc
    %%
    tic
    [a, b, c] = size(myCell)
    M = 4;
    % symbolPeriod = log2(M)*2^pointsPerBit; % in samples
    symbolPeriod = 16;
    startSNR = 5;
    endSNR = 40;
    fl = 1;
    samples = 7
    trainData = cell(3,c,endSNR - (startSNR - 1));
    saveFilePath = savePath + sprintf("%02d_samples/%02d_signals/",samples,numSigs)
    for snr = startSNR:endSNR
        for i = 1:c
            outSig = myCell{fl,2,i};
            inSig = myCell{fl,1,i};
            outSigSNR = awgn(outSig,snr,'measured');
            startOut = 16;
            selectIn = inSig(4:symbolPeriod:end);
            selectOut = outSigSNR(startOut:symbolPeriod:end);

            m = makeInputMat(selectOut,samples);
            t = makeClassMat(selectIn,samples);
            trainData{3,i,snr-(startSNR -1)} = selectIn(1:end -(samples-1));
            trainData{2,i,snr-(startSNR -1)} = m;
            trainData{1,i,snr-(startSNR -1)} = t;
        end
    end
    toc

    %%
    rng(123)

    for snr = startSNR:endSNR
        % randomly select signals
        idx = randperm(numSigs);
        train = idx(1:numSigs*(6/8))
        test = idx(numSigs*(6/8)+1:numSigs*(7/8))
        val = idx(numSigs*(7/8)+1:end)

        % pick which signals go where
        testMat = trainData(1:2,test,snr-(startSNR -1));
        testTarget = cell2mat(testMat(1,:));
        testIn = cell2mat(testMat(2,:));
        testSeq = cell2mat(trainData(3,test,snr-(startSNR -1)));

        testMat = trainData(1:2,train,snr-(startSNR -1));
        trainTarget = cell2mat(testMat(1,:));
        trainIn = cell2mat(testMat(2,:));

        testMat = trainData(1:2,val,snr-(startSNR -1));
        valTarget = cell2mat(testMat(1,:));
        valIn = cell2mat(testMat(2,:));

        % save the data
        saveName = saveFilePath + sprintf('testDataSnr%02d',snr)
        save(saveName,'testTarget','testIn','trainTarget','trainIn','testSeq','valTarget','valIn');

        %     cv={};
        %     cvFold = 4;
        %     for i = 1:cvFold
        %         cv = trainData(1:2,z(i,:),snr-(startSNR -1));
        %         cvTestTarget = cell2mat(cv(1,:));
        %         cvTestIn = cell2mat(cv(2,:));
        %         cv = trainData(:,z(setdiff(1:cvFold,i),:),snr-(startSNR -1));
        %         cvTrainTarget = cell2mat(cv(1,:));
        %         cvTrainIn = cell2mat(cv(2,:));
        %         saveName = saveFilePath + sprintf('cv%02dDataSnr%02d',i,snr)
        %         save(saveName,'cvTestTarget','cvTestIn','cvTrainTarget','cvTrainIn');
        %     end
    end
end
toc
