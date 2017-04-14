ngx-traffic-plugin
====

>ngx-lua 插件，实现特定场景下接口全局或者分用户限流。

#### 使用准备

1. 具有lua模块的ngx
2. redis，并且将 atomic 目录下脚本刷到redis中

#### 使用

1. 参考traffic.conf配置即可

#### TODO

可以将目前lua脚本实现的限流通过ngx c module实现，用以提升性能

#### Licence

MIT
