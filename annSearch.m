function [berR]=annSearch(neurons,epochs,trainF,transF,fLen)
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
berR = zeros(1,runTo - start);
berRLMS = zeros(1,runTo - start);
x =  start:runTo;
samples = 15;
trainNum = 2^17 - 2*samples;
for snr = start:runTo

	selectOutSNR =  awgn(selectOut,snr,'measured');

	% Define network
	hLayers = neurons; % hidden layer size4
	Eqnet = fitnet(hLayers); % make a fitnet
	Eqnet.trainFcn = trainF; 
	Eqnet.layers{1}.transferFcn = transF;
	Eqnet.trainParam.epochs = epochs;
	Eqnet.trainParam.min_grad = 1E-8;
	Eqnet.trainParam.showWindow = false;
	Eqnet.trainParam.show = 500;
	Eqnet.trainParam.showCommandLine = true;

	% make data the right size
	data= makeInputMat(selectOutSNR,samples);
	data = data(:,1:trainNum);
	target = selectIn(samples+1:trainNum+samples);
	[Eqnet,TT] = train(Eqnet,data,target,'useParallel', 'yes'); % use when gpu
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
	    % get BER
	    [~,berann] = biterr(bitsIn,bitsannOut)
	    snr
	end
	berR(snr - (start-1)) = berann;
    if berann == 0
        break
    end
end
end
