function scan_dfe_local(indx)
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


load('data.mat','test','target','train')
scaleFactor = 1.2;
train = train * scaleFactor;
test = test * scaleFactor;
% trainNum = scan(3,indx)
% taps = scan(1,indx)
% ftaps = scan(2,indx)
trainNum = 2^7
taps = 2
ftaps = 1
step = 0.001
ber = zeros(1,31);
for snr = 5:35
	start = 1000;
	trainSymbols = train(snr-4,start:start+trainNum);
    seq = test(snr-4,:);
    ref = target(snr-4,:);
	ber(snr-4) = dfeEq(seq,ref,taps,ftaps,step,trainSymbols);
end
ber
saveName = sprintf('%04d_ber_eqs',indx);
save(saveName,'ber','trainNum','taps','ftaps')
toc
end

