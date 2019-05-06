function qpsk= QPSK()
%------------------ 初始化 --------------------
chip=randi([0,1],1,32);
fc = 10e6;          %载波频率
fs = 40e6;          %采样频率
L=200;             % 每码元的采样点数,抽样时间间隔
M=length(chip);    % 码元数
N=M*L;             % 采样点数
Rb=200000;            % 发送码元的信息速率:2Mbps
Tb=1/Rb;           % 码元宽度:0.5us
dt=Tb/L;           % 采样间隔 
T=N*dt;            % 截短时间
N_samples=T*fs;    %每符号内的采样点数
dt = 1/fs;
t = 0:dt:T-dt;

for n=1:length(chip)
    if chip(n)==1
        ak(n)=+1;
    elseif chip(n)==0;
        ak(n)=-1;
    end
end
            
% 串并变化利用reshape函数处理
IQ=reshape(ak,2,length(ak)/2);
I=IQ(1,:);   
Q=IQ(2,:);

Isig=[];
Qsig=[];
for ii=1:length(IQ)
    if I(ii)==1;
        if Q(ii)==1;
           Isig(ii)=1;
           Qsig(ii)=-1;
        else Isig(ii)=-1;
             Qsig(ii)=-1;
        end
    else
        if Q(ii)==1;
           Isig(ii)=-1;
           Qsig(ii)=1;
        else Isig(ii)=1;
             Qsig(ii)=1;
        end
    end
end


I=Isig;
Q=Qsig;          
I=[I;I];
I=reshape(I,1,2*length(I));
% I=[1,I];   %延时一个时间单位；图形是对Q路延时对应I的第一个与Q的第二相加，故在编程中反映的就是这样

Q=[Q;Q];
Q=reshape(Q,1,2*length(Q));

%将码元转到码元时间序列中来p;
It=[];Qt=[];                 %Q,I两路信号的时间序列；
%码元数多出一个的直接扔掉；使得I,Q两路信号码元数一样；
m=min(length(I),length(Q));
for i=1:L
    It=[It;I];
    Qt=[Qt;Q];
end

It1=It(:);
It2=It1';
It=It2(1:m*L);
Qt1=Qt(:);
Qt2=Qt1';
Qt=Qt2(1:m*L);
c1=1;
s1=1;
c2=cos(2*pi*fc*t);
s2=sin(2*pi*fc*t);
%对两路信号进行加权调制
Q_out1=Qt.*s1;      %加权sin(pi*t/2Ts)后的信号
I_out1=It.*c1;      %加权cos(pi*t/2Ts)后的信号
Q_out=Q_out1.*s2;%输出I路调制信号  
I_out=I_out1.*c2;%输出Q路调制信号
qpsk=I_out-1i*(Q_out);
