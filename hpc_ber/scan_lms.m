function scan_lms(indx)
tic
train_sc = 2.^(3:19);
tap_sc = 2:10;
step_sc = linspace(0.1,0.0001,20)
scan = combvec(tap_sc,step_sc,train_sc);


load('data.mat','test','target','train')
scaleFactor = 1.2;
train = train * scaleFactor;
test = test * scaleFactor;
trainNum = 2^7
taps = 2
step = 0.001
ber = zeros(1,31);
for snr = 5:35
	start = 1000;
	trainSymbols = train(snr-4,start:start+trainNum);
    	seq = test(snr-4,:);
    	ref = target(snr-4,:);
	ber(snr-4) = lmsEq(seq,ref,taps,step,trainSymbols);
end
ber
saveName = sprintf('%04d_ber_eqs',indx);
save(saveName,'ber','trainNum','taps','step')
toc
end

