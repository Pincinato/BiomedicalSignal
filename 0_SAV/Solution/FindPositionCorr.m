function [y ] = FindPositionCorr( vectors)
%FINDPOSITIONCORR Summary of this function goes here
%   Detailed explanation goes here

if nargin == 0
	disp('Averaging: Not enough input arguments');
	y=nan;%output(s) NaN
    return;
end
y=[];
for i =1:size(vectors,2)
    [x,lag]=xcorr(vectors(:,1),vectors(:,i))
    x=x.*x;
    y=[y FindIdex(x,max(x))];
end
end 