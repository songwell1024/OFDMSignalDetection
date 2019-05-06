function [Sig_MFSK] = FSK8()
%搞定          
M=8;
Symbolrate=100;    %符号速率
nsamp=100;    %每个符号的采样点数
fs=Symbolrate*nsamp;
len=3200;
%x=randint(1,len,M);             %取值在0-(M-1) 的随机序列作为信息序列，产生信号还可以用randsrc函数，这函数可以自定义元素的值
x=randi([0,M-1],1,len);             %取值在0-(M-1) 的随机序列作为信息序列，产生信号还可以用randsrc函数，这函数可以自定义元素的值
y=fskmod(x,M,Symbolrate,nsamp,fs);   %8fsk调制信号
% fc=10e6;
% fs=40e6;
% %y=real(y.*exp(j*2*pi*fc/fs*(0:length(y)-1)));
% y=(y.*exp(j*2*pi*fc/fs*(0:length(y)-1)));
Sig_MFSK=y(1:len);


