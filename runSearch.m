function runSearch(i)
% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

tic
delete(gcp('nocreate'))
% maxNumCompThreads(8)
parpool('local',10)

fiberLength = 13;

transferFs = {...
    'compet'
    'elliotsig'
    'hardlim'
    'hardlims'
    'logsig'
    'netinv'
    'poslin'
    'purelin'
    'radbas'
    'radbasn'
    'satlin'
    'satlins'
    'softmax'
    'tansig'
    'tribas'
    };

trainFs = {...
    'trainlm'
    'trainbr'
    'trainbfg'
    'trainrp'
    'trainscg'
    'traincgb'
    'traincgf'
    'traincgp'
    'trainoss'
    'traingdx'
    'traingdm'
    'traingd'
    };

indx = combvec(1:12,1:15);
i
size(indx)
train = char(trainFs(indx(1,i)));
trans = char(transferFs(indx(2,i)));
[berR] = annSearch(40,4000,train,trans,fiberLength);
berR
saveName = sprintf('search_%03d',i);
save(saveName,'berR','train','trans');
toc

end

