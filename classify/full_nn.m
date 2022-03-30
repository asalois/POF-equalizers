% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% a file to get started with classicfaction 
clear; clc; close all;
tic
graph = zeros(31,2);
neurons = 100;
samples = 7;
signals = 8;
M = 4;
name = 'logsig';
dirName = sprintf(...
'/home/alexandersalois/DataDrive/TF_data/%02d_samples/%02d_signals/',...
samples,signals)

for snr = 5:5:35
	[trainIn, trainTarget, testIn, testTarget, testSeq] = getNNData(snr,signals);
	% make and train NN
	net = patternnet(neurons,'trainscg');
	net.layers{1}.transferFcn = name;
	net.trainParam.showWindow = false;
	net.trainParam.showCommandLine = true;
	net = train(net,trainIn, trainTarget,'useGPU','yes'); % use GPU
%	net = train(net,[trainIn valIn],[trainTarget valTarget],'useParallel','yes'); % use CPU Pool
%	net = train(net,[trainIn valIn],[trainTarget valTarget],...
%	'useParallel','yes','useGPU','only'); % use CPU Pool for each GPU
	y = net(testIn);
	perf = perform(net,testTarget,y)

	[~,maxIndx] = max(y,[],1);
	predSeq = -1*pammod(maxIndx -1, M);
	
	testSeq = (testSeq - 0.5 ) * 6;
	seq = (testIn(1,:) - 0.5 ) * 6;
	x = pamdemod(testSeq', M);
	y_a = pamdemod(seq', M);
	y_b = pamdemod(predSeq', M);

	snr
	[~, ber] = biterr(x,y_a)
	[~, ber_ann] = biterr(x,y_b)
	graph(snr-4,:) = [ber ber_ann];
end
%graph'
%saveName = "ber_" + name;
%sizeName = sprintf('_%d_%d',neurons,samples); % test
%saveName = saveName + sizeName
%save(saveName,'graph')
toc
