# Fontconfig解析逻辑

## 文件解析顺序

* /etc/fonts/fonts.conf
* /etc/fonts/conf.d

以numerical order方式读取。
在Arch中，默认50-user.conf和51-local.conf，简直不合逻辑。
可以创建99-mine.conf来进行最后的反抗。

## 工作原理

Fontconfig通过计算pattern和系统中各个字体的距离进行选择，选取距离最近的字体作为最终的字体。

pattern是各种字体属性 (font property) 的集合，比如family, familylang, slant, weight, hinting等。每个属性的值都可以为多个，比如family, lang，排在前面的被认为是距离更近的，但是有一个特例，family被分为强绑定 (strong) 和弱绑定 (weak) 两种，强绑定的优先级比lang更高，弱绑定的优先级比lang更低。

Fontconfig通过解析配置，逐步修改pattern中每个属性的值，最后进行距离的计算。

## Fontconfig通过计算pattern和系统中各个字体的距离进行选择，选取距离最近的字体作为最终的字体。

pattern是各种字体属性 (font property) 的集合，比如family, familylang, slant, weight, hinting等。每个属性的值都可以为多个，比如family, lang，排在前面的被认为是距离更近的，但是有一个特例，family被分为强绑定 (strong) 和弱绑定 (weak) 两种，强绑定的优先级比lang更高，弱绑定的优先级比lang更低。

Fontconfig通过解析配置，逐步修改pattern中每个属性的值，最后进行距离的计算。

一般使用两种方式。

### match + edit

```xml
<match target="pattern">
    <test qual="any" name="family" compare="eq">
        <string>sans-serif</string>
    </test>
    <edit name="family" mode="prepend_first">
        <string>Droid Sans</string>
        <string>Source Han Sans SC</string>
        ...
    </edit>
</match>
```

其中，qual="any"表示用测试值匹配当前属性值中任意一值（因为属性值可以为多个），qual="all"表示匹配当前属性值的所有值。edit有几种模式：

|Mode|With Match|Without Match|
|---|---|---|
|"assign"|Replace matching value|Replace all values|
|"assign_replace"|Replace all values|Replace all values|
|"prepend"|Insert before matching|Insert at head of list|
|"prepend_first"|Insert at head of list|Insert at head of lit|
|"append"|Append after matching|Append at end of list|
|"append_last"|Append at end of list|Append at end of list|
|"delete"|Delete matching value|Delete all values|
|"delete_all"|Delete all values|Delete all values|

一般应使用"prepend_first"。

### alias + prefer/accept/default

```xml
<alias>
	<family>Courier</family>
	<prefer><family>Courier New</family></prefer>
	<default><family>monospace</family></default>
</alias>
```

对应前种方式，prefer相当于prepend，accept相当于append，default相当于append_last，
这种方式更适用于字体替换，因为当不缺少字体时，多次对同一目标使用alias+prefer不会生效，仅当前面设置的prefer字体不存在时，后面的prefer才有意义。

|Name|Value|Meaning|
|---|---|---|
|MATCH|1|Brief information about font matching|
|MATCHV|2|Extensive font matching information|
|EDIT|4|Monitor match/test/edit execution|
|FONTSET|8|Track loading of font information at startup|
|CACHE|16|Watch cache files being written|
|CACHEV|32|Extensive cache file writing information|
|PARSE|64|(no longer in use)|
|SCAN|128|Watch font files being scanned to build caches|
|SCANV|256|Verbose font file scanning information|
|MEMORY|512|Monitor fontconfig memory usage|
|CONFIG|1024|Monitor which config files are loaded|
|LANGSET|2048|Dump char sets used to construct lang values|
|MATCH2|4096|Display font-matching transformation in patterns|

匹配结果中可以看到当前字体对pattern的匹配分数，类似这种：
Best score 0 0 0 0 0 0 0 10 0 0 1000 0 0 0 0 0 0 0 0 0 0 0 0 0 2.1474e+12

这个匹配分数中每一项对应源码中的如下结构：

```c
typedef enum _FcMatcherPriority {
    PRI1(FILE),
    PRI1(FONTFORMAT),
    PRI1(VARIABLE),
    PRI1(SCALABLE),
    PRI1(COLOR),
    PRI1(FOUNDRY),
    PRI1(CHARSET),
    PRI_FAMILY_STRONG,
    PRI_POSTSCRIPT_NAME_STRONG,
    PRI1(LANG),
    PRI_FAMILY_WEAK,
    PRI_POSTSCRIPT_NAME_WEAK,
    PRI1(SYMBOL),
    PRI1(SPACING),
    PRI1(SIZE),
    PRI1(PIXEL_SIZE),
    PRI1(STYLE),
    PRI1(SLANT),
    PRI1(WEIGHT),
    PRI1(WIDTH),
    PRI1(DECORATIVE),
    PRI1(ANTIALIAS),
    PRI1(RASTERIZER),
    PRI1(OUTLINE),
    PRI1(FONTVERSION),
    PRI_END
} FcMatcherPriority;
```

但对于每一项所占比重，需要看源码（懒）
