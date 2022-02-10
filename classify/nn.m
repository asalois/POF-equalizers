% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% a file to get started with classicfaction 
clear; clc; close all;
graph = zeros(7,2);
neurons = 100;
samples = 3;
name = 'softmax';
for snr = 5:5:35
	dirName = "/home/alexandersalois/DataDrive/optSimData/05_samples/";
	%matName = sprintf('cv%02dDataSnr%02d',1,snr); % cv
	matName = sprintf('testDataSnr%02d',snr); % test
	loadName = dirName + matName;
	load(loadName)

	%%
	net = patternnet(neurons,'trainscg')
	net.layers{1}.transferFcn = name;
	net.trainParam.showWindow = false;
	net.trainParam.showCommandLine = true;
	%net = train(net,testTrainIn,testTrainTarget,'useGPU','yes') % use GPU
	net = train(net,testTrainIn,testTrainTarget,'useParallel','yes')
	y = net(testIn);
	perf = perform(net,testTarget,y)

	%%
	pred = zeros(1,length(y));
	for i = 1:length(y)
	    if y(1,i) > 0.9
		pred(i)=3;
	    elseif y(2,i) > 0.9
		pred(i)=1;
	    elseif y(3,i) > 0.9
		pred(i)=-1;
	    elseif y(4,i) > 0.9
		pred(i)=-3;
	    end
	end
	%%
	testSeq = (testSeq - 0.5 ) * 6;
	seq = (testIn(1,:) - 0.5 ) * 6;
	x = pamdemod(testSeq',4);
	y_a = pamdemod(seq',4);
	y_b = pamdemod(pred',4);

	%num = 20;
	%
	%testSeq(1:num)
	%pred(1:num)
	%
	%testSeq(end-num:end)
	%pred(end-num:end)
	%
	%x_b(end-num:end)'
	%y_b(end-num:end)'

	%%
	snr
	[~, ber] = biterr(x,y_a)
	[~, ber_ann] = biterr(x,y_b)
	graph(snr/5,:) = [ber ber_ann];
end
graph'
saveName = "ber_" + name;
sizeName = sprintf('_%d_%d',neurons,samples); % test
saveName = saveName + sizeName
save(saveName,'graph')
