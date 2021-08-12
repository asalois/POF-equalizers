% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
clear; clc; close all;
myCell = cell(20,2,1); % (fiberLen, [in out], runNum)
for fiberLen = 1:20
    for snr = [97 90]
        for runNum = 1:20
            loadName = sprintf('pam_snr_%02d_len_%04d_%04d',snr,fiberLen*10,runNum);
            try
                load(loadName)
            catch
                break
            end
            
            % rescale
            inSig = real(InNode{1,2}.Signal.samples);
            outSig = real(InNode{1,1}.Signal.samples);
            outSig = outSig - min(outSig);
            outSig = outSig/max(outSig);
            if snr == 97
                myCell{fiberLen,1,runNum} = inSig;
                myCell{fiberLen,2,runNum} = outSig;
            else
                myCell{fiberLen,1,runNum+1} = inSig;
                myCell{fiberLen,2,runNum+1} = outSig;
            end
        end
    end
end

%%
% for fiberLen = 1:20
% for i = 1
%     loadName = sprintf('pam_snr_%02d_len_%04d_%04d',97,fiberLen*10,1);
%     load(loadName)
%
%     % rescale
%     inSig = real(InNode{1,2}.Signal.samples);
%     outSig = real(InNode{1,1}.Signal.samples);
%     outSig = outSig - min(outSig);
%     outSig = outSig/max(outSig);
%     tempCell = cell(2,1);
%     tempCell{1,i} = inSig;
%     tempCell{fiberLen,2,i} = outSig;
%
% end
% end