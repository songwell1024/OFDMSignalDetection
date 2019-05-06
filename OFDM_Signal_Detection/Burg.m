function [psdviaBurg, f, p] = Burg(x, Fs, varargin)
%MYBURG      根据burg算法实现的AR模型功率谱计算
% psdviaBurg 根据burg算法求出的功率谱值
% f          频率轴参数
% p          模型阶次
% x          输出信号
% Fs         采样率
% varargin   若为数值型，则为AR模型阶次
%            若为字符串，则为定阶准则，AR模型阶次由程序确定
%
% 解析输入参数内容
if strcmp(class(varargin{1}), 'double')
    p = varargin{1};
elseif ischar(varargin{1})
    criterion = varargin{1};
else
    error('参数2必须为数值型或者字符串');
end
x = x(:);
N = length(x);
% 模型参数求解
if exist('p', 'var') % p变量是否存在，存在则不需要定阶，直接使用p阶
    [a, E] = computeARpara(x, p);
else % p不存在，需要定阶，定阶准则即criterion
    p = ceil(N/3); % 阶次一般不超过信号长度的1/3
    
    % 计算1到p阶的误差
    [a, E] = computeARpara(x, p);
    
    % 根据误差求解目标函数最小值
    kc = 1:p + 1;
    switch criterion
        case 'FPE'
            goalF = E.*(N + (kc + 1))./(N - (kc + 1));
        case 'AIC'
            goalF = N.*log(E) + 2.*kc;
    end
    [minF, p] = min(goalF); % p就是目标函数最小的位置，也即定阶准则给出的阶次
    
    % 使用p阶重新求解AR模型参数
    [a, E] = computeARpara(x, p);
end
[h, f] = freqz(1, a, 20e5, Fs);
psdviaBurg = E(end)*abs(h).^2./Fs;
psdviaBurg=psdviaBurg/abs(max(psdviaBurg));
psdviaBurg=(10*log10(abs(psdviaBurg)));