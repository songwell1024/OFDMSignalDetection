function [Tu,Ts,Tg ] = effectivelength(x,fs,snr,N,K)
%**************************************************************************
%功能：求信号的有效数据长度
%x:输入的信号
%fc:信号的频率，fs为信号的采样频率
%snr:信噪比
%N:信号每帧的符号数
%短波信号Tu的理论值3.2us,Ts的理论值4us
%**************************************************************************
 p = std(x);
 x = x/p;
 sig_1 = awgn(x,snr,'measured');
 L=length(x);
 t=1/fs;
 P=(L/N);
 xcorr_len=1;    %自相关长度,以OFDM符号为单位
 [Tu,Ts]=auto_xcorr(sig_1,P, xcorr_len, N,t,K);           %发送信号整个的自相关
 Tg=Ts-Tu;   %使用固定时延的fft求解CP长度
