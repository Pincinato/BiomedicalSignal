function [ y ] = Synchronized_Averaging_Filter( x,M )
%************************************************************************** 
%Scope: Retuern a signal filtered by a mean filter
%Autor: Thiago Henrique Pincinato 
%Date:  13 09 2017 
%Version: 1.0 
%-------------------------------------------------------------------------
%Input: %----
%	x: vector .
%   N: Escalar   
%
%Output: %-----	
%	y: Vector.
%-------------------------------------------------------------------------
%Version History: %1.0: Create, Day Month Year
%-------------------------------------------------------------------------
%- This function  ?lter a signal usinge a mean filter
%**************************************************************************

%Check Input(s)

if nargin == 0
	disp('Averaging: Not enough input arguments');
	y=nan;%output(s) NaN
    return;
end
y=zeros(size(x(:,1),1));
for i=1:M
    y=[y+x(:,i)];
end
y=y/M;