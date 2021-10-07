% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
load('data.mat')
%% 100 m POF

scaleFactor = 1.2;
figure()
histogram(scaleFactor*test(31,:))

figure()
histogram(scaleFactor*train(31,:))

figure()
histogram(target(31,:))