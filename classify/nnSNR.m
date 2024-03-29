
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

function nnSNR(snr)
% a file to get started with classicfaction 
tic
neurons = 100;
samples = 2;
signals = 8;
M = 4;
name = 'logsig';

[trainIn, trainTarget, testIn, testTarget, testSeq] = getNNData(snr,signals,true);
% make and train NN
net = patternnet(neurons,'trainscg');
net.layers{1}.transferFcn = name;
net.trainParam.showWindow = false;
net.trainParam.showCommandLine = true;
%net = train(net,trainIn, trainTarget,'useGPU','yes'); % use GPU
net = train(net,trainIn, trainTarget,'useParallel','yes'); % use CPU Pool
%	net = train(net,[trainIn valIn],[trainTarget valTarget],...
%	'useParallel','yes','useGPU','only'); % use CPU Pool for each GPU
y = net(testIn);
perf = perform(net,testTarget,y)

[~,maxIndx] = max(y,[],1);
predSeq = -1 * pammod(maxIndx -1, M);

testSeq = (testSeq - 0.5 ) * 6;
seq = (testIn(end,:) - 0.5 ) * 6;
x_a = pamdemod(testSeq', M);
y_a = pamdemod(seq', M);
x_b = pamdemod(testSeq', M);
y_b = pamdemod(predSeq', M);

snr
[~, ber] = biterr(x_a,y_a)
[~, ber_ann] = biterr(x_b,y_b)
saveName = sprintf('snr%02d',snr)
save(saveName,'ber_ann')
toc
