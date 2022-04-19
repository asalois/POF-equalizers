% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
function ber = boxFilter(len,snr,eyes)


loadFilePath = "H:/OneDrive - Montana State University/optSimData/100Mbps/100m/19/";
pow = 19;
fl = 100;
M = 4;
symbolPeriod = 16;
rng(snr)
rn = randi(64,1);
loadName = loadFilePath + sprintf('pam_pow_%02d_len_%04d_%04d',pow,fl*10,rn);
load(loadName)

% rescale
inSig = real(InNode{1,2}.Signal.samples);
selectIn = inSig(4:symbolPeriod:end);

outSig = real(InNode{1,1}.Signal.samples);
outSig = outSig - min(outSig);
outSig = outSig/max(outSig);

outSigSNR = awgn(outSig,snr,'measured');
bers = zeros(1,16);
if len ~= 1
    selectIn = selectIn(1:end -1);
end
if len <8
    startOut = 16;
elseif len == 8
    startOut = 13;
else
    startOut = 11;
end

if len == 1
    selectOut = outSigSNR(startOut:symbolPeriod:end);

    if snr == 100 & eyes
        scaled = (outSigSNR -0.5)*6;
        sel = 100:2^16;
        eyediagram(scaled(sel),2*symbolPeriod,2*symbolPeriod);
        name = sprintf("eye_filtered_samples_%02d.png",len);
        saveas(gcf,name)
    end

else
    bk = ones(1,len);
    bk = bk/len;
    delay = len/2;

    filtered = filter(bk,1,outSigSNR);
    filtered = filtered(delay+1:end-(symbolPeriod - delay));
    
    selectOut = filtered(startOut:symbolPeriod:end);


    if snr == 100 & eyes
        scaled = (filtered -0.5)*6;
        sel = 100:2^16;
        eyediagram(scaled(sel),2*symbolPeriod,2*symbolPeriod);
        name = sprintf("eye_filtered_samples_%02d.png",len);
        saveas(gcf,name)
    end
end



selectIn = (selectIn - 0.5) * 6;
selectOut = (selectOut - 0.5) * 6;

bitsIn = pamdemod(selectIn,M);
bitsOut = pamdemod(selectOut,M);

[errs, ber] = biterr(bitsIn,bitsOut);
% end
% [ber, idx] = min(bers);
% if snr == 35
%     idx
%     bers;
% end