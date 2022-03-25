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
name = 'logsig';
dirName = sprintf(...
'/home/alexandersalois/DataDrive/TF_data/%02d_samples/%02d_signals/',...
samples,signals)
%dirName = "D:/OneDrive - Montana State University/03_samples/08_signals/";
%dirName = "D:/OneDrive - Montana State University/TF_data/02_samples/64_signals/";
for snr = 5:35
	data = getNNData(snr,signals)
	% make and train NN
	net = patternnet(neurons,'trainscg');
	net.layers{1}.transferFcn = name;
	net.trainParam.showWindow = false;
	net.trainParam.showCommandLine = true;
	net = train(net,[cell2mat(data(2,2)) cell2mat(data(3,2))],[cell2mat(data(2,1)) cell2mat(data(3,1))],'useGPU','yes'); % use GPU
%	net = train(net,[trainIn valIn],[trainTarget valTarget],'useParallel','yes'); % use CPU Pool
%	net = train(net,[trainIn valIn],[trainTarget valTarget],...
%	'useParallel','yes','useGPU','only'); % use CPU Pool for each GPU
	y = net(cell2mat(data(1,2)));
	perf = perform(net,cell2mat(data(1,1)),y)

	%%
	[~,maxIndx] = max(y,[],1);
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
	testSeq = cell2mat(data(1,3));
	testseq = (testSeq - 0.5 ) * 6;
	testIn = cell2mat(data(1,2));
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
