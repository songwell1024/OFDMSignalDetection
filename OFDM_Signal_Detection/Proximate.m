function [as1, as11]=Proximate(b,aa)
%%% b是要找的参照值
%%% aa是你要找的数组

%%不管aa是几维的数组 统一化成一维
a=aa(:);                                            %%将给定数组化为一维的
ab=(a(:)-b)';                                     %%将数组a与b做差
abc=abs(ab);                  
abc=sort(abc);                                  %%差值取绝对值并排序

%%%  二维数组as即是与b值相近的值在数组abc中的坐标 
%    找到与b差值为第一种情况的所有值得坐标（即等于b的）
[as1 ,as11] =find(abs((a(:)-b))==abc(1,1));
