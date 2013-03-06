function [truevalue]=errorbounds(time,true,tolerance,varargin)
% Given the timeseries TRUE value of the flight parameter, this function
% returns a TRUEVALUE vector whose columns are the upper bound, the true
% value, and the lower bound respectively. The inputs are the time, the
% values, the tolerance and the type of tolerance. '%' is used to indicate
% that the tolerance is a percent of the true value.

if nargin>3
    if strcmp(varargin(1),'%')
    upper = true*(1+tolerance/100);
    lower = true*(1-tolerance/100);
    else
        disp('Error: Please enter the type of error as %');
    end
else
    upper = true+tolerance;
    lower = true-tolerance;
end

truevalue(:,1) = upper;
truevalue(:,2) = true;
truevalue(:,3) = lower;

end