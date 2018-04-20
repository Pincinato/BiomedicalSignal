function [y ] = decimator_pincinato(x,D)
%DECIMATOR_PINCINATO Summary of this function goes here
%   Detailed explanation goes here

b=fir1(D*10,1/D,'low');
filtered=filter(b,1,x);
filtered=circshift(filtered,-(D*(5-1)));
j=1;
y=zeros(int32(length(x)/D),1);
for i=1:length(x)
    if(mod(i,D)==0)
        y(j)=filtered(i);
        j=j+1;
    end 
end

