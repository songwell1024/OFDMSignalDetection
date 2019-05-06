%random_binary.m
%产生二进制信源随机序列
function [info]=random_binary(N)
 if nargin == 0,     %如果没有输入参数，则指定信息序列为10000个码元
  N=10000;
end;
for i=1:N,
  temp=rand;             
  if (temp<0.5),
    info(i)=0;         % 1/2的概率输出为0
  else
    info(i)=1;         % 1/2的概率输出为1
  end
end;