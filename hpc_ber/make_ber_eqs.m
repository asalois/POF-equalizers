% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
%function make_ber_eqs(snr)
snr = 35;
tic
dir = sprintf(...
	'/home/alexandersalois/DataDrive/Research-OneDrive/nnTrainData/fiberLen100/01_samples/snr%02d/testDataSnr%02d.mat'...
	,snr,snr)
load(dir)
start = 1000;
for i = 3:20
	trainNum = 2^i
	trainSymbols = testTrainIn(2,start:start+trainNum);
	seq = testIn(2,:);
	ref = testTarget;
	%seq = (seq -min(seq) ) / max(seq) ;
	trainSymbols = (trainSymbols- 0.5) *6;
	seq = (seq- 0.5) *6;
	ref = (ref- 0.5) *6;
	%tps =  [0  3  7  2  3  7];
	%ftps = [0  0  0  1  2  4];
	%trn =  [1  12 12 12 12 12];
	step = 0.05;
	taps = 2;
	berNoEq = noEq(seq,ref);
	berLmsEq = lmsEq(seq,ref,taps,trainSymbols,step)
	%berDfeEq = dfeEq(seq,ref,3,2,train)
	%berDfeEq = 2
	%ber = [berNoEq, berLmsEq, berDfeEq]';
	%saveName = sprintf('ber_%02d_snr_eqs',snr);
	%save(saveName)
end
toc
