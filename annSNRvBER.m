function [berR,x]=annSNRvBER(neurons,trainNum,epochs,fLen,iters)
% LMS EQ Graph
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% load file
loadName = sprintf('pam_snr_%02d_len_%04d_%04d',97,fLen*10,1);
load(loadName)

M = 4;
symbolPeriod = log2(M)*2^pointsPerBit; % in samples

% rescale to work with pamdemod
inSig = real(InNode{1,2}.Signal.samples);
%inSig = inSig*6 -3;
outSig = real(InNode{1,1}.Signal.samples);
outSig = outSig - min(outSig);
outSig = outSig/max(outSig);
%outSig = outSig*6 -3;

% outSigSNR = awgn(outSig,SNR,'measured');
outSigSNR = outSig;
startOut = 16;
selectIn = inSig(4:symbolPeriod:end);
selectOut = outSigSNR(startOut:symbolPeriod:end);

start = 5;
runTo = 35;
berR = zeros(iters,runTo - start);
berRLMS = zeros(iters,runTo - start);
x =  start:runTo;
for i = 1:iters
    for snr = start:runTo
        
        selectOutSNR =  awgn(selectOut,snr,'measured');
        % define number of symbols to train EQ
        numTrainSymbols = trainNum;
        trainingSymbols = selectOutSNR(1:numTrainSymbols);
        
	% Define network
	hLayers = neurons; % hidden layer size4
	Eqnet = fitnet(hLayers,'traingd'); % make a fitnet
	Eqnet.trainParam.epochs = epochs;
	Eqnet.trainParam.min_grad = 1E-8;
	Eqnet.trainParam.showWindow = false;
	Eqnet.trainParam.show = 500;
	Eqnet.trainParam.showCommandLine = true;
        
	% make data the right size
	samples = 15;
	data= makeInputMat(selectOutSNR,samples);
	data = data(:,1:trainNum);
	target = selectIn(samples+1:trainNum+samples);
	[Eqnet,TT] = train(Eqnet,data,target,'useGPU', 'yes'); % use when gpu
	annOut = Eqnet(data);

        if any(isnan(annOut))
            berLMS = 2;
            ber = 2;
        else
            bitsIn = pamdemod(selectIn*6-3,M);
	    bitsIn = bitsIn(samples+1:end-samples);
            bitsOut = pamdemod(selectOutSNR*6-3,M);
            bitsannOut = pamdemod(annOut*6-3,M);
	    bitsannOut = bitsannOut;
	    size(bitsIn)
	    size(bitsannOut)
            % get BER
            [~,berann] = biterr(bitsIn,bitsannOut)
	    snr
	    i
        end
        berR(i,snr - (start-1)) = berann;
    end
end
% berR = [mean(berR,1); mean(berRLMS,1)];
berR = [min(berR,[],1)]
end
