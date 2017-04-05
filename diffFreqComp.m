function [SD,M] = diffFreqComp(original,signal)
  diffArray=[];
    for i = 1:round(length(signal)/2)
        diffArray=[diffArray,(signal(i))-(original(i))];
    end
    SD=std(diffArray);
    M=mean(diffArray);
end