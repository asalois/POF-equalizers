% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% a file to get started with classicfaction 
clear; clc; close all;
tic
graph = zeros(31,2);
neurons = 100;
samples = 2;
name = 'logsig';
for snr = 5:35
	%dirName = "/home/alexandersalois/DataDrive/optSimData/05_samples/";
    %dirName = "D:/OneDrive - Montana State University/03_samples/08_signals/";
    dirName = "D:/OneDrive - Montana State University/TF_data/02_samples/64_signals/";
	matName = sprintf('testDataSnr%02d',snr) % test
	loadName = dirName + matName;
	load(loadName)

	%%
	net = patternnet(neurons,'trainscg');
	net.layers{1}.transferFcn = name;
	net.trainParam.showWindow = true;
	net.trainParam.showCommandLine = false;
%     net.trainParam.min_grad = 10^(-7);
%     net.trainParam.max_fail = 10;
%	net = train(net,trainIn,trainTarget,'useGPU','yes'); % use GPU
	net = train(net,testTrainIn,testTrainTarget,'useParallel','yes');
	y = net(testIn);
	perf = perform(net,testTarget,y)

	%%
	[~.maxIndx] = max(y,[],2);
	predSeq = zeros(1,length(y));
        for z = 1:length(maxIndx)
              if maxIndx(z) == 1
                  predSeq(z)=3;
              elseif maxIndx(z) == 2
                  predSeq(z)=1;
              elseif maxIndx(z) == 3
                  predSeq(z)=-1;
             elseif maxIndx(z) == 4
                  predSeq(z)=-3;
              end
        end

	%%
	testSeq = (testSeq - 0.5 ) * 6;
	seq = (testIn(1,:) - 0.5 ) * 6;
	x = pamdemod(testSeq',4);
	y_a = pamdemod(seq',4);
	y_b = pamdemod(predSeq',4);


	%%
	snr
	[~, ber] = biterr(x,y_a)
	[~, ber_ann] = biterr(x,y_b)
	graph(snr-4,:) = [ber ber_ann];
end
graph'
saveName = "ber_" + name;
sizeName = sprintf('_%d_%d',neurons,samples); % test
saveName = saveName + sizeName
save(saveName,'graph')
toc
