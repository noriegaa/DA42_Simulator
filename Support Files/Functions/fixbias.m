function [bias fixed] = fixbias(true,sim)
bias = mean(true(1:25,1))-mean(sim(1:25,1));
fixed = sim+bias;
end