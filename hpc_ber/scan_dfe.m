function scan_dfe(indx)
tic
train_sc = 2.^(9:19);
tap_sc = 2:7;
for i = tap_sc
	for j = 1:i-1
		if i == 2
			scan = combvec(1:i,1:j,train_sc);
		else
			scan = [scan combvec(1:i,1:j,train_sc)];
		end
	end
end

trainNum = scan(3,indx)
taps = scan(1,indx)
ftaps = scan(2,indx)
%trainNum = 2^14
%taps = 2
%ftaps = 1
ber = zeros(1,31);
for snr = [10,20,30,35]
	%dir = sprintf('/mnt/lustrefs/scratch/v16b915/pof_data/fiberLen100/01_samples/snr%02d/testDataSnr%02d.mat',snr,snr)
	%dir = sprintf('/home/alexandersalois/DataDrive/Research-OneDrive/nnTrainData/fiberLen100/01_samples/snr%02d/testDataSnr%02d.mat',snr,snr)
    dir = sprintf('/home/alexandersalois/Documents/pof_data01/fiberLen100/01_samples/snr%02d/testDataSnr%02d.mat',snr,snr)
	load(dir)
	start = 1000;
	trainSymbols = testTrainIn(2,start:start+trainNum);
	seq = testIn(2,:);
	ref = testTarget;
	trainSymbols = (trainSymbols- 0.5) *6;
	seq = (seq- 0.5) *6;
	ref = (ref- 0.5) *6;
	ber(snr-4) = dfeEq(seq,ref,taps,ftaps,trainSymbols);
end
ber
saveName = sprintf('%04d_ber_eqs',indx);
save(saveName,'ber','trainNum','taps','ftaps')
toc
end

