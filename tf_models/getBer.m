%% Proakis Synthetic Channel Equilization with Deep NNs

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc; clear; close all 
tic
ber = zeros(1,31);
labels = cell(1,10);
%%
samples = 3
signals = 64
name = cellstr(sprintf('%d Samples',samples))
labels(samples) = name;
for i = 1:31
	snr = i + 4;
	rname = sprintf('predictionsSNR%02d.mat',snr);
	load(rname);
        predSeq = zeros(1,length(pred'));
 	[~,maxIndx] = max(pred',[],1);
        for z = 1:length(maxIndx)
            if maxIndx(z) == 1
                predSeq(z)=3;
            elseif maxIndx(z) == 2
                predSeq(z)=1;
            elseif maxIndx(z) == 3
                predSeq(z)=-1;
            elseif maxIndx(z) == 4
                predSeq(z)=-3;
            end
        end
        targetSeq = zeros(1,length(testTarget'));
 	[~,maxIndx] = max(testTarget',[],1);
        for z = 1:length(maxIndx)
            if maxIndx(z) == 1
                testSeq(z)=3;
            elseif maxIndx(z) == 2
                testSeq(z)=1;
            elseif maxIndx(z) == 3
                testSeq(z)=-1;
            elseif maxIndx(z) == 4
                testSeq(z)=-3;
            end
        end
	x_b = pamdemod(testSeq,4);
	y_b = pamdemod(predSeq,4);
	[~, ber_dnn] = biterr(x_b,y_b)
	ber(i) = ber_dnn;
end
toc
%%
%snr = 5:35;
%figure()
%semilogy(snr,ber,'-*')
%title('SNR vs BER for 100 m POF')
%ylabel('BER')
%xlabel('SNR (dB)')
%legend()
%saveas(gcf,'bernn.png')
save('berSymDeepTF_01','ber')

