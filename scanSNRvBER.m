% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic
fiberLength = 100
iters = 100;

BER = noEqSNRvBER(fiberLength,1);
save('noEqBER','BER')

train_sc = 2.^(2:17);
tap_sc = 2:20;
step_sc = linspace(0.0001,0.01,20);
scanlms = combvec(tap_sc,train_sc,step_sc);
for i = tap_sc
        if i == 2
                scandfe = combvec(i,1:(i-1),train_sc);
        else
                scandfe = [scandfe combvec(i,1:(i-1),train_sc)];
        end
end

parfor i = 1:6080
	taps = scanlms(1,i);
	train = scanlms(2,i);
	step = scanlms(3,i);
	BER = lmsSNRvBER([taps train step],fiberLength,iters);
	saveName = sprintf('lmsBER_%05d_%02dm',i,fiberLength);
	save(saveName,'BER','taps','train','step','iters')
end

parfor i = 1:1000
	taps = scandfe(1,i);
	fTaps = scandfe(2,i);
	train = scandef(3,i);
	BER = dfeSNRvBER([taps fTaps train],fiberLength,iters);
	saveName = sprintf('dfeBER_%05d_%03dm',i,fiberLength);
	save(saveName,'BER','taps','fTaps','train','step','iters')
end
toc
