function [ Tu_rate,Ts_rate,Tg_rate] = Length_rate_difratio(x,fs,snr,N,K)
%**************************************************************************
%功能：有效数据长度，数据总长度，循环前缀长度估计性能
%x:输入信号
%fs：采样频率
%snr：信噪比
%N：符号个数
%Tu_rate：有效数据长度估计性能
%Ts_rate：数据总长度估计性能
%Tg_rate：循环前缀估计性能
%**************************************************************************
meantimes=100;
Lx=length(snr);
Tu_num=zeros(1,Lx);
Ts_num=zeros(1,Lx);
Tg_num=zeros(1,Lx);

%准确率
Tu_rate=zeros(1,Lx);
Ts_rate=zeros(1,Lx);
Tg_rate=zeros(1,Lx);
% Tu_ideal=(3.2e-6);
% Ts_ideal=(4.0e-6);
% Tg_ideal=(8.0e-7);

% Tu_ideal=3.2e-6;
% Tg_ideal=(8.0e-7)*ratio*4;
% Ts_ideal=Tu_ideal+Tu_ideal;
[Tu_ideal,Ts_ideal,Tg_ideal] = effectivelength(x,fs,100,N,0); %理论值，此处为了简便，也可直接赋值，但注意运算位数导致的亿分之一的小数误差，

for i=1:Lx
    for j=1:meantimes
        [Tu(i,j),Ts(i,j),Tg(i,j)] = effectivelength(x,fs,snr(i),N,0);
        
        if  (Tu(i,j)==Tu_ideal)
            Tu_num(i)=Tu_num(i)+1;
        end
        if  (Ts(i,j)==Ts_ideal)
            Ts_num(i)=Ts_num(i)+1;
        end
        if  (Tg(i,j)==Tg_ideal)
            Tg_num(i)=Tg_num(i)+1;
        end
    end
    Tu_rate(i)=Tu_num(i)/meantimes;
    Ts_rate(i)= Ts_num(i)/meantimes;
    Tg_rate(i)=Tg_num(i)/meantimes;
end

if K==1
    figure
    plot(snr,Tu_rate,'b-o');
    grid on;
    title('有效数据长度估计性能');
    figure
    plot(snr,Ts_rate,'b-o');
    grid on;
    title('数据总长度估计性能');
    figure
    plot(snr,Tg_rate,'b-o');
    grid on;
    title('循环前缀长度估计性能')
end
end