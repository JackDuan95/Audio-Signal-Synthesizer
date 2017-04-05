function [SD,M] = diffAmpComp(original,signal,IntervalNum)
M=[];
SD=[];
start=1;
for j=1:IntervalNum
    diffArray=[];
    for i = start:start+round(length(original)/IntervalNum)
        diffArray=[diffArray,((signal(i))-(original(i)))];
    end
    start=start+round(length(original)/IntervalNum);
    SD=[SD,std(diffArray)];
    M=[M,mean(diffArray)];
end

end