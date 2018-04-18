%************************************************************************** 
%Course: Biomedical signal and processing  
%SAV0
%Autor: Thiago Henrique Pincinato 
%Date: 15.09.2017
%Version: 1.0 
%-------------------------------------------------------------------------
close all;
clear all;
load 'theECGs_4sav.dat'
% THE DOCUMENTATION IN THE FOLDER EXPLAIN HOW THE SYNCHRONIZED AVERAGING
% WORK(pg 95, book, or using the adobe pagination 12.
% As the ecg wave are already sinchronized( with row un ecg pulse), it is
% really simpe to do the synchronized averaging filter. We need just to add
% the the differente ecg pulse and divided by the number of fragments
% added. NOTE : notice that it is not that difficul because the signal was
% already fragmented and synchronized, ohterwise, it should be our tak to
% to do it, which it is not so trivial.
%% Prob1
fs = 1000;
time =  [1:size(theECGs_4sav,1)]/fs;
title( "Ex 1 figure 1");
M=16;
coin=randi([1 (size(theECGs_4sav,1)-1)],1,M);
filter_sav=zeros(1,size(theECGs_4sav,1));
for i=1:M
    subplot(M/2,2,i)
    plot(time,theECGs_4sav(:,coin(i)));
    text=int2str(coin(i));
    text=strcat(text,'° signal');
    title(text);
    filter_sav=filter_sav+theECGs_4sav(:,coin(i));
end
figure (2);
filter_sav=filter_sav/M;
plot(time,filter_sav);
text=' ECG signal with M =';
text=strcat(text,int2str(M));
title(text);
xlabel('time in seconds');
ylabel('Amplitude');
%% Prob 2
load 'theERPs_4sav.dat'
fs = 1000;
time = [1:size(theERPs_4sav,1)]/fs;
figure(3)
for i=[1 2 3 4 6]
    subplot(3,2,i)
    plot(time,Synchronized_Averaging_Filter(theERPs_4sav,i*4));
    text='M =';
    text=strcat(text,int2str(i*4));
    title(text);
end
%% Prob 3
load 'ecg_hfn.dat'
figure(4)
subplot(3,1,1)
plot(ecg_hfn);
template=ecg_hfn(1:700);
window=700-1;
c=normxcorr2(template,ecg_hfn);
subplot(3,1,2)
plot(c); hold on;
threshold=0.9;
safe_factor=5;
peaks=find((c>threshold) & (c>circshift(c,-safe_factor)) & (c>circshift(c,safe_factor)) & (c>circshift(c,-1)) & (c>circshift(c,1)) );
plot(peaks,c(peaks),'*'); hold off;
a=circshift(peaks,1);
a(1)=0;
sizediff=peaks(length(peaks(:,1)))-length(ecg_hfn(:,1));
mindiff=min(peaks -a);
fragmented_signal=zeros(1+mindiff-sizediff,length(peaks));
filtered_sav3=zeros(1+mindiff-sizediff,1);
for i=1:length(peaks)
   fragmented_signal(:,i)=ecg_hfn((peaks(i)- mindiff):peaks(i)-sizediff);
   filtered_sav3=filtered_sav3+fragmented_signal(:,i);
end
filtered_sav3=filtered_sav3/length(peaks);
filtered_sav3_complete=repmat(filtered_sav3,length(peaks));
subplot(3,1,3)
plot(1:length(filtered_sav3_complete(:,1)),filtered_sav3_complete);
figure(10)
for i=1:12
    subplot(6,2,i)
    plot(fragmented_signal(:,i));
end