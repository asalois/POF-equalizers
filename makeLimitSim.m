tic
ns= 2^28
M = 4
x = randi(M-1,ns,1);
sig = pammod(x,M);
ber = zeros(1,31);
errs = zeros(1,31);
for snr = 5:35
    selectOutSNR =  awgn(sig,snr,'measured');
    bitsIn = pamdemod(sig,M);
    bitsOut = pamdemod(selectOutSNR,M);
    % get BER
    [errs(1,snr-4),ber(1,snr-4)] = biterr(bitsIn,bitsOut);
end
errs
ber
save('ber_limit','ber')
toc
