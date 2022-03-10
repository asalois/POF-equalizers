function mat = makeInputMat(input,numSymbols,numSamples)
%makeInputMat Makes in input matrix
%   Detailed explanation goes here
if numSamples == 16
    colSize = 16*numSymbols;
    mat = zeros(colSize,length(input)/colSize);
    for i = 1:(length(mat)-1)
        mat(:,i) = input(1+(i-1)*colSize:i*colSize);
    end
else
    colSize = numSamples*numSymbols;
    
    startOut = 16/numSamples;
    select = input(startOut:startOut:end);
    mat = zeros(colSize,length(select)/colSize);
    for i = 1:(length(mat)-1)
        mat(:,i) = select(1+(i-1)*colSize:i*colSize);
    end

end

