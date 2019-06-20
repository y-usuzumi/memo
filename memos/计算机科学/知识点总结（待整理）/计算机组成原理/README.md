# 计算机组成原理

## 机械硬盘

> WTMD网上查到的资料扇区和块的概念各种混乱！！！！
> 有的人说扇区是弧形区域有的人说是扇形区域！！！！！
> 我以
> [https://www.youtube.com/watch?v=aZjYr87r1b8](https://www.youtube.com/watch?v=aZjYr87r1b8)
> 为准！


### 磁道 (track)

一个个的同心圆。

### 扇区 (sector)

一个扇型区域。

### 块 (block)

一个弧形区域，可以是512字节或4096字节大小（理论上可以是任意大小）。

块由 (磁道号, 扇区号) 定位。块中的每个字节通过偏移量 (offset) 定位。
