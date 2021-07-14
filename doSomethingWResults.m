% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;

results = readmatrix('outLMS.csv')';
results = results(2:end,:);
results = [results(1:2,:); results(4:5,:)];

[mn,i]=min(results(4,:));
minSNR = results(:,i-17:i+22);
[mx,ii] = max(results(4,:));
maxSNR = results(:,ii-9:ii+30);

figure()
semilogy(minSNR(1,:),minSNR(4,:),'-*',maxSNR(1,:),maxSNR(4,:),'-*')
xlim([10 30])