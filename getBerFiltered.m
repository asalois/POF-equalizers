
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
rng(123)
tic

snrs = 1:50
lens = [1 2 4 8 16]
labels = cell(size(lens));
bers = zeros(length(lens),length(snrs));
for j = 1:length(lens)
    name = sprintf("%d samples",lens(j));
    labels(j) = {name}; 
    for i = 1:length(snrs)
        bers(j,i) = boxFilter(lens(j),snrs(i),false);
    end
end
%%
labels(1) = {"No Filtering"};
figure()
semilogy(snrs,bers','-*')
xlabel('SNR [dB]')
ylabel('BER')
legend(labels,'Location','southwest')
% titleName = sprintf('EQs for %d m of POF',fiberLength);
% title(titleName)
% saveFigureName = sprintf('EqsSpanfor%02dmPOF.png',fiberLength);
saveas(gcf,"boxFiltering.png")
% saveName = sprintf('EqsSpanfor%02dmPOF',fiberLength);
% save(saveName)
toc
