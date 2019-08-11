--
-- Created by IntelliJ IDEA.
-- User: Admin
-- Date: 2019/8/6
-- Time: 22:06
-- To change this template use File | Settings | File Templates.
--
local _M = {}

function _M.dbConfig()
    local config = {
        host = "127.0.0.1",
        port = 3306,
        database = "active_data",
        user = "root",
        password = "0bdd0151ab8abc97"
    }
    return config
end

function _M.redisConfig()
    local config = {
        host = "127.0.0.1",
        port = 6379,
        password = ""
    }
    return config
end

return _M


