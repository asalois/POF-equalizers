% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
tic
z = randi(100);
A = randi(100);
sample = 9;
snr = 40;
i = 8;
mat_file_path = "/home/alexandersalois/Documents/pof_data/fiberLen100/";
mat_file_path = mat_file_path + sprintf('%02d_samples/',sample)
saveName = mat_file_path + sprintf('testDataSnr%02d',snr)
save(saveName,'z');

saveName = mat_file_path + sprintf('cv%02dDataSnr%02d',i,snr)
save(saveName,'z');
