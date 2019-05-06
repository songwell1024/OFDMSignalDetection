function y2=ofdm(N,para,ratio)
%**************************************************************************
%功能：ofdm信号产生函数
%N:符号个数
%para:子载波数目
%**************************************************************************

M = 16;   %16QAM调制
Signal = randi([0,M-1],1,para*N);
QAM_out = modulate(modem.qammod(16),Signal);
x = reshape(QAM_out,para,N);       %串并转换
y = ifft(x);                        %对调制后的数据进行ifft变换
y1 = [y(end-round(length(y(:,1))*ratio)+1:end,:);y];%插入循环前缀比例1/4
y2 = reshape(y1,1,(length(y1(:,1)))*N);   %并串转换
P = std(y2);
y2 = y2/P;


