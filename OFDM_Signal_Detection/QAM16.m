function y = QAM16()
N=64; % 码元数
df=50; % 频率分辨率
M=16; % 16QAM调制
x=randi([0,M-1],1,N);% 产生随机序列 (信号源)
%============= Use 16-QAM modulation=====================% QAM 调制
% fc=10e6; % 载波频率
% fs=40e6; % 采样频率
% ts=1/fs; % 采样间隔

% t=[0:ts:N*df*ts]; % 时间向量

h = modem.qammod(M);
y = modulate(h,x);
y = repmat(y,df,1);
y = reshape(y,1,df*N);
P=std(y);           %求y的标准差，用库函数来求，作用与mean（abs（））相同。标准差是方差的开方
y=y/P;              %P1和P显然不同，归一化是除以标准差？还是除以模的均值,还是除以平方和的开方

% c=exp(j*2*pi*fc.*t); % 载波信号
% y=y.*c(1:length(y));
