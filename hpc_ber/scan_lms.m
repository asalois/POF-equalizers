% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
function make_ber_eqs(indx)
tic
train_sc = 2.^(4:13);
tap_sc = 2:10;
step_sc =logspace(-3,-1,11);
scan = combvec(train_sc,tap_sc,step_sc);
trainNum = scan(1,indx) 
taps = scan(2,indx) 
step = scan(3,indx) 
ber = zeros(1,31);
for snr = 5:35
	dir = sprintf('/mnt/lustrefs/scratch/v16b915/pof_data/fiberLen100/01_samples/snr%02d/testDataSnr%02d.mat',snr,snr)
	load(dir)
	start = 1000;
	trainSymbols = testTrainIn(2,start:start+trainNum);
	seq = testIn(2,:);
	ref = testTarget;
	trainSymbols = (trainSymbols- 0.5) *6;
	seq = (seq- 0.5) *6;
	ref = (ref- 0.5) *6;
	ber(snr-4) = lmsEq(seq,ref,taps,trainSymbols,step)
end
saveName = sprintf('%03d_ber_eqs',indx);
save(saveName,'ber','trainNum','step','taps')
toc
end
