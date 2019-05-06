function [Tu,Ts,Tg ] = effectivelength_rayleigh(x,fs,snr,N,K,itau,power,fmax,itn)
%**************************************************************************
%功能：求信号的有效数据长度和总的数据长度
%x:输入的信号
%fc:信号的频率
%fs:信号的采样频率
%snr:信噪比
%N:信号每帧的符号数
%**************************************************************************
 %sig_1= RayFade(itau,power,fmax,fs,x,snr);
 sig_1 = MUL_RAYLEIGH(x,itau,power,itn,length(itau),length(x),1/fs,fmax,0);
 sig_1 = awgn(sig_1,snr,'measured');
 L=length(sig_1);
 t=1/fs;
 P=(L/N);
 xcorr_len=1;    %自相关长度,以OFDM符号为单位
 [Tu,Ts]=auto_xcorr(sig_1,P, xcorr_len, N,t,K);           %发送信号整个的自相关
 Tg=Ts-Tu;   %使用固定时延的fft求解CP长度
