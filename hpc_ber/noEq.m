function [ber]=noEq(seq,ref)
% LMS EQ Graph
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

M = 4;

bitsIn = pamdemod(ref,M);
bitsOut = pamdemod(seq,M);
[~,ber] = biterr(bitsIn,bitsOut);  % get BER
end
