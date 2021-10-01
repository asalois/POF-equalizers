
tic
rows = 31;
train_size = 12582720
test_size= 4194240
train = zeros(rows,train_size);
test = zeros(rows,test_size);
target = zeros(rows,test_size);
for snr = 5:35
    dir = sprintf('/home/alexandersalois/Documents/pof_data01/fiberLen100/01_samples/snr%02d/testDataSnr%02d.mat',snr,snr)
	load(dir)
	start = 1000;
	%trainSymbols = testTrainIn(2,start:start+trainNum);
    trainSymbols = testTrainIn(2,:);
	seq = testIn(2,:);
	ref = testTarget;
	trainSymbols = (trainSymbols- 0.5) *6;
	seq = (seq- 0.5) *6;
	ref = (ref- 0.5) *6;
    train(snr - 4,:) = trainSymbols;
    test(snr -  4,:) = seq;
    target(snr - 4,:) = ref;
    
end
save('data','train','test','target','-v7.3')
toc


