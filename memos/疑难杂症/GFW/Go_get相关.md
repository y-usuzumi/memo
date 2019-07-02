# Go get相关

`go get`似乎不吃socks5代理，比如用proxychains或`env socks5_proxy=http://...`都没起效。

网上找到的方法是使用代理工具把socks5代理转成http代理即可。

polipo已经停止维护。使用privoxy。

Update:似乎使用git的某个proxy配置项即可。
