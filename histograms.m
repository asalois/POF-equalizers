% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
%% 100 m POF
load('pam_pow_18_len_1000_0001.mat')

figure()
histogram(1.2*test(31,:))
% figure()
% histogram(train(31,:))
% figure()
% histogram(target(31,:))