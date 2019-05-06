function [ff] = cyclic_spectrum(x, N, fs, M,K)
%*******************************************************************
% 功能：平滑周期图法求循环谱
% x ：信号
% N ： 循环谱检测采样长度，必须小于等于信号序列长度
% fs ： 采样频率, 检测带宽为-fs/2至fs/2
% M ：平滑点数, 时间分辨率*频率分辨率=M
%*******************************************************************
win = 'hamming'; % 平滑窗类型

d_alpha = fs/(N); % 1/时间分辨率=循环频率分辨率
alpha = -fs:d_alpha:fs; % 循环频率, 分辨率=1/时间分辨率
a_len = length(alpha); % 循环频率取样个数

f_len = floor(N/M-1)+1; % 最大平滑窗个数, 即频率采样个数
f = -(fs/2-d_alpha*floor(M/2)) + d_alpha*M*(0:f_len-1); % 频率采样点位置

S = zeros(a_len, f_len); % 初始相关功率谱
i = 1; 

%%% 信号fft变换 %%%
X = fftshift(fft(x(1:N))); 
X = X';

%%% 遍历循环频率取值 %%%
for alfa = alpha

    interval_f_N = round(abs(alfa)/d_alpha); % 循环频率所对应的频谱序列序号
    f_N = floor((N-interval_f_N-M)/M)+1; % 平滑窗的个数
    
    %%% 生成平滑窗函数 %%%
    %g = feval(win, M); 
    %window_M = g(:, ones(f_N,1));
    
    %%% 频域序列平滑模板 %%%
    t = 1:M*f_N;
    t = reshape(t, M, f_N);
    
    %%% 计算X1,X2 %%%
    %X1 = X(t).*window_M;
    %X2 = X(t+interval_f_N).*window_M; 
    X1 = X(t);
    X2 = X(t+interval_f_N); 
    %%% 计算谱相关 %%%
    St = conj(X1).*X2;
    St = mean(St, 1); % 平滑平均
    S(i, floor((f_len-f_N)/2)+(1:f_N)) = St/N; % 将结果平移至序列中央以便作图
    i = i+1;
    
end
%%% 遍历循环频率取值结束 %%%
 
%%% 循环谱作图 %%%
if K==1
    figure;
    mesh(f, alpha, abs(S)); 
    axis tight;
    title('QAM-OFDM 循环谱');
    xlabel('f'); 
    ylabel('a');
end

normal_data=S(floor(length(S(:,1))/2)+1,:);
if K==1
    figure;
    plot(f,abs(normal_data))
    xlabel('频率 [Hz]');
    ylabel('S0(f)');
    title('OFDM谱相关函数a=0的二维切面');
    grid;
end
normal_data =interp(normal_data,100);
ff = interp(f,100);
%***********************************************
%载频估计
%***********************************************
for i=1:length(normal_data)/2
  if(abs(normal_data(i)) ==max(abs(normal_data(1,1:length(normal_data)/2))))
      f1=abs(ff(i));
  end
end
for ii=length(normal_data)/2:length(normal_data)
  if(abs(normal_data(ii)) ==max(abs(normal_data(1,length(normal_data)/2:end))))
      f2=abs(ff(ii));
  end
end

ff=(f1+f2)/2;

[as2, as22]=Proximate(10e6,f);
data3=S(:,as2);
normal_data3=data3/max(data3);
 if K==1
    figure;
    plot(alpha,abs(normal_data3))
    xlabel('频率 [Hz]');
    ylabel('S0(f)');
    title('OFDM谱相关函数f=fc的二维切面');
    grid;
 end