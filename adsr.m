function [x]=adsr(dur,sig)
A = linspace(0, 0.7, (length(sig)*0.2)); %rise 20% of signal
D = linspace(0.7, 0.5,(length(sig)*0.05)); %drop of 5% of signal
S = linspace(0.5, 0.5,(length(sig)*0.6)); %delay of 40% of signal
R = linspace(0.5, 0,(length(sig)*0.15)); %drop of 35% of signal
[x] = [A D S R] ; %make a matrix
end