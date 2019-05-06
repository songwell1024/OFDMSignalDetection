function [carry_num] = carrier_number(yc,N,snr,K)
%**************************************************************************
%功能:过采样法估计子载波数目
%yc:输入信号
%N:符号个数
%snr:信噪比
%carry_num:子载波数目
%**************************************************************************

yd = awgn(yc,snr,'measured');
fff = 3; % 检测采样率,对信号进行过采样
y1 = yd(ones(fff,1),:); % 码元复制
sig_2 = reshape(y1, 1, fff*length(y1));
%P=length(sig_2)/N;
P = length(yc)/N;
fft_num = 6000;       %fft点数
Rx_c = zeros(length(sig_2),P);
data1 = [sig_2,zeros(1,P)];
 for i = 1 : length(sig_2)
    for tao = 1 :P
         Rx_c(i,tao) = Rx_c(i,tao) + data1(i)*conj(data1(tao+i));
    end
 end
RRR_c=ifft(Rx_c(:,1),fft_num);
if K==1
    figure
    stem(abs(RRR_c));
    xlabel('FFT点数')
    ylabel('幅度')
    title('Rxx(n,1)的FFT');
end

Ln = fft_num/fff-100;   %设置搜索的区间
ab1 = sort( abs(RRR_c(Ln+1:2*Ln)));    %按升序排序
Z = length(ab1);
[a1 ,a2] = find(abs(RRR_c(Ln+1:2*Ln))==ab1(Z,1));%取峰值高度为第二高的峰值对应坐标

ab2 = sort( abs(RRR_c(2*Ln+1:3*Ln)));    %按升序排序
Z = length(ab2);
[a3 ,a4] = find(abs(RRR_c(2*Ln+1:3*Ln))==ab2(Z,1));%取峰值高度为第二高的峰值对应坐标
interval = a3+Ln-a1;         %峰值间隔
q = fft_num/interval;     %过采样率

 Lp = length(sig_2)/N;   %自相关遍历周期
[Tu_over] = overfind_num(sig_2,Lp,N,fff);
carry_num = Tu_over/q;