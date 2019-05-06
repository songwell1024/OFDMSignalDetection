# 短波OFDM信号侦测与参数估计 

程序实现的主要功能：</br>

1. OFDM调制识别：研究了基于高阶累量和基于小波变换的OFDM信号和单载波调制信号的识别算法，仿真分析了两种算法在高斯信道和多径瑞利衰落信道下的信号识别性能。</br>

2. OFDM参数估计：研究了基于Welch算法和AR模型法求解功率谱进而估计信号带宽的算法，对两种算法的估计性能进行了比较；根据OFDM信号的循环平稳性研究了基于循环谱的载频估计算法；根据 OFDM信号的自相关性研究了基于可变延时自相关和固定延时自相关的FFT相结合的算法，估计了OFDM信号的有效数据长度、符号总长度、循环前缀长度和子载波间隔；最后研究了基于带宽和基于过采样估计子载波数目两种算法，并在高斯信道和多径瑞利衰落信道下对以上参数估计算法进行了仿真分析。</br>

其中OFDM_DEMO为整个项目的程序入口，其余均为辅助函数，每一个函数均有参数注释和功能说明。</br>

其中相关的参考博客：</br>

[短波信道模型--多径瑞利信道原理详解及matlab实现](https://blog.csdn.net/WilsonSong1024/article/details/79449425)</br>

[用Burg法估计AR模型的参数原理详解及matlab实现](https://blog.csdn.net/WilsonSong1024/article/details/79449161)</br>

[OFDM信号循环谱原理详解及matlab实现](https://blog.csdn.net/WilsonSong1024/article/details/79449213)</br>

[OFDM信号的循环自相关函数原理详解及matlab实现](https://blog.csdn.net/WilsonSong1024/article/details/79449318)</br>