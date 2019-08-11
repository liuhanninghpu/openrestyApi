--Nginx服务器中使用lua获取get参数
local arg = ngx.req.get_uri_args()
local code = nil
local response = {}
local cjson = require("cjson")
local mysql = require("resty.mysql")

for k,v in pairs(arg) do
    if k == 'code' then
        code = ndk.set_var.set_quote_sql_str(v) --sql注入规避
    end
end
if code == nil then
    response['code'] = -1
    response['data'] = ''
    response['message'] = 'params is err'
    ngx.say(cjson.encode(response))
    return
end
--ngx.req.read_body() -- 解析 body 参数之前一定要先读取 body
--local arg = ngx.req.get_post_args()
--for k,v in pairs(arg) do
--    ngx.say("[POST] key:", k, " v:", v)
--end
local config = require("config") --统一配置文件，在config.lua下
local dbconfig = config.dbConfig()

--lua连接数据库
local function close_db(db)
    if not db then
        return
    end
    db:close()
end


local db, err = mysql:new()
if not db then
    response['code'] = -1
    response['data'] = ''
    response['message'] = 'some err'
    ngx.say(cjson.encode(response))
    return
end

db:set_timeout(1000)

local res, err, errno, sqlstate = db:connect(dbconfig)

if not res then
    response['code'] = -1
    response['data'] = ''
    response['message'] = 'some err'
    ngx.say(cjson.encode(response))
    return close_db(db)
end


--2e198f7f877494b7e5e58522a1c3a129
local select_sql = string.format([[select * from active where idfamd5 = %s]], code)
res, err, errno, sqlstate = db:query(select_sql)
if not res then
    response['code'] = -1
    response['data'] = ''
    response['message'] = 'some err'
    ngx.say(cjson.encode(response))
    return close_db(db)
end

local tableLen = table.getn(res)
if tableLen == 0 then
    response['code'] = -1
    response['data'] = ''
    response['message'] = 'no data'
    ngx.say(cjson.encode(response))
    return
else
    response['code'] = 0
    response['data'] = 'exist id'
    response['message'] = 'success'
    ngx.say(cjson.encode(response))
end
ngx.exit(ngx.HTTP_OK)
ngx.flush(true)

