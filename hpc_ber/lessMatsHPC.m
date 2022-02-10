function lessMatsHPPC(input)
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
tic
pick = combvec(5:35,1:10)
matFilePath = "/mnt/lustrefs/scratch/v16b915/pof_data/fiberLen100/";
pow = 18;
numSims = 128;
snr = pick(1,input)
samples = pick(2,input)
fl = 100;
myCell = cell(2,numSims); % ([in out], runNum)
for  rn = 1:numSims
	loadName = matFilePath + sprintf('pam_pow_%02d_len_%04d_%04d',pow,fl*10,rn);
	try
		load(loadName)
	catch
		break
	end
	
	% rescale
	inSig = real(InNode{1,2}.Signal.samples);
	outSig = real(InNode{1,1}.Signal.samples);
	outSig = outSig - min(outSig);
	outSig = outSig/max(outSig);
	myCell{1,rn} = inSig;
	myCell{2,rn} = outSig;
end

clearvars -except myCell matFilePath numSims snr samples

toc
[a, b] = size(myCell)
M = 4;
symbolPeriod = 16;
trainData = cell(2,b);
saveFilePath = matFilePath + sprintf('%02d_samples/snr%0d/',samples,snr)
for i = 1:b
	%get data
	outSig = myCell{2,i};
	inSig = myCell{1,i};

	% add noise
	outSigSNR = awgn(outSig,snr,'measured');
	
	% pick best sample per symbol
	startOut = 16;
	selectIn = inSig(4:symbolPeriod:end);
	selectOut = outSigSNR(startOut:symbolPeriod:end);
	
	% make training and test sets
	m = makeInputMat(selectOut,samples);
	t = selectIn;
	t = t(samples+1:end-samples);
	trainData{2,i} = m;
	trainData{1,i} = t;
end

clearvars -except trainData saveFilePath numSims snr samples

toc

idx = randperm(numSims);
qtr = numSims/4;
test = idx(1:qtr)
train = idx(qtr+1:end);
z = reshape(train,8,3*qtr/8)
testMat = trainData(:,test);
testTarget = cell2mat(testMat(1,:));
testIn = cell2mat(testMat(2,:));
testMat = trainData(:,setdiff(1:32,test));
testTrainTarget = cell2mat(testMat(1,:));
testTrainIn = cell2mat(testMat(2,:));
saveName = saveFilePath + sprintf('testDataSnr%02d',snr)
save(saveName,'testTarget','testIn','testTrainTarget','testTrainIn');

cvFold = 8;
for i = 1:cvFold
	cv={};
	cv = trainData(:,z(i,:));
	cvTestTarget = cell2mat(cv(1,:));
	cvTestIn = cell2mat(cv(2,:));
	cv = trainData(:,z(setdiff(1:cvFold,i),:));
	cvTrainTarget = cell2mat(cv(1,:));
	cvTrainIn = cell2mat(cv(2,:));
	saveName = saveFilePath + sprintf('cv%02dDataSnr%02d',i,snr)
	save(saveName,'cvTestTarget','cvTestIn','cvTrainTarget','cvTrainIn');
end

toc

