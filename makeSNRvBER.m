% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic
for k = [13 20]
	fiberLength = k
	iters = 100;
	[berA, x] = lmsSNRvBER([2 2^10 0.01],fiberLength,iters);
	toc
	[berB, ~] = dfeSNRvBER([2 1 2^7],fiberLength,iters);
	toc
	[berC, ~] = dfeSNRvBER([2 1 2^8],fiberLength,iters);
	toc

	%
	tic
	%[berE, ~] = annSNRvBER(40,2^17,5000,fiberLength,1);
	toc
	[berF, ~] = annlSNRvBER(40,2^17,5000,fiberLength,1);
	toc
	%berD = [berA; berB; berC; berE; berF];
	berD = [berA; berB; berC; berF];


	%
	figure()
	semilogy(x,berD','-*')
	xlabel('SNR [dB]')
	ylabel('BER')
	legend('NO EQ','LMS','DFE Train 128','DFE Train 256','Linear ANN','Location','southwest')
	titleName = sprintf('EQs for %d m of POF',fiberLength);
	title(titleName)
	saveFigureName = sprintf('Eqsfor%02dmPOF.png',fiberLength);
	saveas(gcf,saveFigureName)
	saveName = sprintf('Eqsfor%02dmPOF',fiberLength);
	save(saveName)
	toc
end
