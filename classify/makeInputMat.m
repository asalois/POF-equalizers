function mat = makeInputMat(input,numSamples)
%makeInputMat Makes in input matrix
%   Detailed explanation goes here
mat = zeros(numSamples,length(input));
for i = 1:numSamples
    mat(i,:) = circshift(input,-(i-1));
end
mat = mat(:,1:end-(numSamples-1));
end

