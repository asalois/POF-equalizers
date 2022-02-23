function mat = makeInputMat(input,numSymbols)
%makeInputMat Makes in input matrix
%   Detailed explanation goes here
colSize = 16*numSymbols;
mat = zeros(colSize,length(input)/colSize);
for i = 1:(length(mat)-1)
    mat(:,i) = input(1+(i-1)*colSize:i*colSize);
end
end

