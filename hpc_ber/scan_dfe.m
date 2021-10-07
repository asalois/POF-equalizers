function scan_dfe(indx)
tic
indx = (indx -1) * 10 + 1;
train_sc = 2.^(3:19);
tap_sc = 2:20;
step_sc = linspace(0.0001,0.001,20);
for i = tap_sc
	if i == 2
		scan = combvec(i,i-1,train_sc,step_sc);
	else
		scan = [scan combvec(i,1:(i-1),train_sc,step_sc)];
	end
end

load('data.mat','test','target','train')
for i = indx:indx+9
	taps = scan(1,i)
	ftaps = scan(2,i)
	trainNum = scan(3,i)
	step = scan(4,i)
	ber = zeros(1,31);
	for snr = 5:35
		start = 1000;
		trainSymbols = train(snr-4,start:start+trainNum);
		seq = test(snr-4,:);
		ref = target(snr-4,:);
		ber(snr-4) = dfeEq(seq,ref,taps,ftaps,step,trainSymbols);
    end
	ber
	saveName = sprintf('%05d_ber_eqs',i);
	save(saveName,'ber','trainNum','taps','ftaps','step')
end
toc
end

