function [y] = interpolation_pincinato(x,D,adjust)
%INTERPOLATION_PINCINATO Summary of this function goes here
%   Detailed explanation goes here

a=adjust-length(x);
a=a*D;
y=zeros(length(x)*8+a,1);
j=1;
for i=1:length(y)
    y(i)=0;
    if(mod(i,D)==0)
        y(i)=x(j);
        j=j+1;
    end    
end
b=fir1(D*10,1/D,'low');
y=filter(b,1,y);
y=D*circshift(y,-(D*5)); % need to be multiple by D to correct the amplitude. It is because the power of each sample is followed by D-1 zero.
                         % As the nature of the filter FIR, the power will
                         % by divide by the size of the windows in this
                         % case (D-1)+1 = D.  So it is needed to multiple
                         % by D to keep the power.
                    
