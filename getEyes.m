% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
stp = 1;
for i = [50 100]
    %     loadName = sprintf('pam_snr_%02d_len_%04d_%04d',97,10*i,1);
    loadName = sprintf(...
        '/home/alexandersalois/Documents/working_mats/pam_pow_%02d_len_%04d_%04d'...
        ,18,10*i,1);
    load(loadName);
    x = real(InNode{1,1}.Signal.samples);
    x = x - min(x);
    x = x/max(x);
    x = x*6-3;
    part = 1:2^18;
    eTitle = sprintf('%2d m at 100 Mbps',i);
    saveName = sprintf('%02d_m_eye.png',i);
    eyediagram(x(part),16);
    title(eTitle);
    saveas(gcf,saveName)
end
%%

