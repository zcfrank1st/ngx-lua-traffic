--
-- Created by IntelliJ IDEA.
-- User: zcfrank1st
-- Date: 14/04/2017
-- Time: 9:12 AM
--
-- load script to redis ->
-- redis-cli SCRIPT LOAD "$(cat ./atomic_traffic.lua)"
-- redis-cli EVALSHA 2991700e011be3d5bfa7cb9b36c85448f748c273 1 i 10
-- redis-cli --ldb --eval /tmp/script.lua mykey somekey , arg1 arg2

local current
current = redis.call("incr",KEYS[1])
if tonumber(current) == 1 then
    redis.call("expire",KEYS[1], ARGV[1])
end
return current