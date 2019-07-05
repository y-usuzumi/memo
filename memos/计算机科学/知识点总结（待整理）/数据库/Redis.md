# Redis

## 支持的数据类型

* Binary-safe strings
* Lists：链表
* Sets
* Sorted sets：每个元素对应一个分值。
* Hash：键值均为字符串的映射表。
* Bit arrays (bitmaps)：可以通过特殊命令按位操作字符串。
* HyperLogLogs：概率结构，用于估计集合的势（大小）。
* Streams：唯增集合，存储类似映射表的条目，提供抽象日志数据类型。

## 命令一览

## 内部实现

### Sorted sets (zset)

满足以下条件时，使用ziplist：

1. 元素数量小于128个
1. 所有member的长度都小于64字节

ziplist编码的有序集合使用紧挨在一起的压缩列表节点来保存，第一个节点保存member，第二个保存score。ziplist内的集合元素按score从小到大排序，score较小的排在表头位置。

如不满足上述条件，使用skip list。

## 使用Redis实现分布式锁

一般来讲就是`SET resource_name my_random_value NX PX 30000`。

但是如果Redis挂掉了？加个从机，不过仍然存在如下的问题：

假设：

1. 客户端A申请主机上的锁。
1. 主机挂了，此时A上的写操作还没有转移到从机上。
1. slave被提升为主机。
1. 客户端B申请锁，可以成功申请！！！

解决办法：



