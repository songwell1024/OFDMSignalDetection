function [Sig_8ASK] = ASK8()
%产生基带符号流
M=8;       %进制 8ASK
N=30;       %信源比特流长度,为保证对齐,选择是log2(M)的整倍数
bit=randint(1,N,2); 
symbol=zeros(1,N/log2(M));
S = [0,1,2,3,4,5,6,7];
for i=1:length(symbol)
    symbol(i)=S(bit(i)*4+bit(i+1)*2+bit(i+2)+1);
end
%产生载波
fc = 10e6;          %载波频率
fs = 40e6;          %采样频率
L=20;               % 每码元的采样点数,抽样时间间隔
M=length(symbol);     % 码元数
N=M*L;              % 采样点数
Rb=2e6;             % 发送码元的信息速率:2Mbps
Tb=1/Rb;            % 码元宽度:0.5us
dt=Tb/L;            % 采样间隔 
T=N*dt;             % 截短时间
N_samples=T*fs;  %每符号内的采样点数
dt = 1/fs;
t = 0:dt:T-dt;
carrier = cos(2*pi*fc.*t);
%生成调制信号S(t)
r=zeros(1,length(carrier)*length(symbol));
for n1=1:length(symbol)
    r((N_samples*(n1-1)+1):(N_samples*(n1-1)+N_samples))=symbol(n1)*carrier;
end
% plot(r)
Sig_8ASK = awgn(r,SNR,'measured');
% end