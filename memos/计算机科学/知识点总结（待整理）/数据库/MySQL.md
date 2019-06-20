# MySQL

## MyISAM和InnoDB的区别

|Metric|MyISAM|InnoDB|备注|
|---|---|---|---|
|事务处理|不支持|支持||
|外键|不支持|支持||
|行级锁|不支持|支持||
|FULLTEXT类型的索引|支持|不支持||
|保存表行数|是|否||
|AUTO_INCREMENT是否需要单独索引|否|是|MyISAM可以联合索引|
|DELETE FROM table|重建表|一行行删除||
|LOAD TABLE FROM MASTER||不起作用||
|其他||||

