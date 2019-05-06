function [ sig_chnl ] = PSD_generate( N)
%产生求功率谱的ofdm信号
%N一个祯结构中OFDM信号的个数，每次发送的ofdm信号的个数

para=128;%设置并行传输的子载波个数,有效数据长度
M=16;
Signal=randi([0,M-1],1,para*N);
QAM_out=modulate(modem.qammod(16),Signal);
x=reshape(QAM_out,para,N);      %串并转换
L=length(x(:,1));
for i=1:N
      x1(:,i)  = [x( 1 : end / 2,i) ;zeros(4*L,1) ;x( end / 2 + 1 : end,i)];  %4倍过采样
end

yy=ifft(x1);                         %对调制后的数据进行ifft变换
yy1=[yy(end-round(length(yy)/4)+1:end,:);yy];%插入循环前缀比例1/4
yy1=[zeros(round(length(x1)/3),N);yy1; zeros(round(2*length(x1)/3),N)];  %前后插零
sig_chnl=reshape(yy1,1,(length(yy1))*N);
P0=std(sig_chnl);
sig_chnl=sig_chnl/P0;
