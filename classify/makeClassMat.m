function mat = makeClassMat(input,numSamples)
%makeInputMat Makes in input matrix
%   Detailed explanation goes here

mat = zeros(4,length(input));
for i = 1:length(input)
    if input(i) < 1/6
        mat(:,i) = [0;0;0;1];
    elseif input(i) > 5/6
        mat(:,i) = [1;0;0;0];
    else
        if input(i) > 1/2
            mat(:,i) = [0;1;0;0];
        else
            mat(:,i) = [0;0;1;0];
        end
    end
    
end
mat = mat(:,1:end-(numSamples-1));
end
