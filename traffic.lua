-- 模块参数
-- 参数$traffic_env  全局还是单用户(0:全局，1:单用户)
-- 参数$traffic_expired_time  生命周期段(秒)
-- 参数$traffic_visits_threshold  访问频次阈值(次数)
-- 参数$traffic_method 请求方法

-- redis参数
-- $traffic_monitor_host
-- $traffic_monitor_port

local redis = require "resty.redis"
local str = require "resty.string"

local red = redis:new()
red:set_timeout(1000)

-- hard code
local host = ngx.var.monitor_host
local port = tonumber(ngx.var.monitor_port)
local atomic_s = ngx.var.traffic_atomic_script

red:connect(host, port)

local env = tonumber(ngx.var.traffic_env)
local expired_time = tonumber(ngx.var.traffic_expired_time)
local visits_threshold = tonumber(ngx.var.traffic_visits_threshold)

local req_url = ngx.var.request_uri
local setting_req_method = ngx.var.traffic_method
local real_req_method = ngx.req.get_method()

-- 1. 判断env 和 http method
-- 2. 执行redis lua脚本，之后获取访问频次值
-- 3. 判断返回值是否超过阈值，执行行为

local key
if (env == 0 and real_req_method == setting_req_method) then
    key = 'global:' .. str.to_hex(req_url)
elseif (env == 1 and real_req_method == setting_req_method) then
    local token = ngx.req.get_headers()["authkey"]
    key = token .. ':' .. str.to_hex(req_url)
end

local res = tonumber(red:evalsha(atomic_s, 1, key, expired_time))

if res >= visits_threshold then
    ngx.exit(ngx.HTTP_FORBIDDEN)
end

return