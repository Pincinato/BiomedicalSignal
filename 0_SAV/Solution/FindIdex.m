function [ y ] = FindIdex( vector,value )
%FINDIDEX Summary of this function goes here
%   Detailed explanation goes here

if nargin == 0
	disp('Averaging: Not enough input arguments');
	y=nan;%output(s) NaN
    return;
end

for i=1:size(vector,1)
    if vector(i) == value
        y=i;
    end
end

