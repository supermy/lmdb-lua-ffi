local lu = require("luaunit")

local socket = require("socket")
local ffi = require "ffi"
local new_tab = require "table.new" -- 需要luajit-2.1.0-beta3
local clear_tab = require "table.clear" -- 需要luajit-2.1.0-beta3

-- 当 verbose 变量为 false 时（默认就为 false 哈），我们使用 jit.v 模块打印出比较简略的流水信息到 /tmp/jit.log 文件中；而当 verbose 变量为 true 时，我们则使用 jit.dump 模块打印所有的细节信息，包括每个 trace 内部的字节码、IR 码和最终生成的机器指令。
-- if "luajit" == arg[-1] then
--     local verbose = false
--     local name = "-"..arg[-1]
--     if verbose then
--         local dump = require "jit.dump"
--         dump.on(nil, "target/jit-roaring.log")
--     else
--         local v = require "jit.v"
--         v.on("target/jit-roaring.log")
--     end
-- end

local verbo = require("jit.v")
verbo.start()

local tonumber, tostring, type = tonumber, tostring, type

local log_debug = function(arr, ...)
    local arg = {...}
    for key, value in ipairs(arg) do
        arr = arr .. value
    end
    print(debug.traceback(arr))
end

collectgarbage("setpause", 200)
collectgarbage("setstepmul", 5000)

local function pref(fn)
    local msg = {}
    -- table.insert(msg,desc)
    msg[#msg + 1] = "\npref:"
    -- 先统计现有内存使用情况
    local mem1 = collectgarbage("count")
    msg[#msg + 1] = string.format("初始内存:%d kb", mem1)
    local t0 = socket.gettime()
    local s = os.clock()

    -- local r = fn(c_options, c_err)
    fn()

    local t1 = socket.gettime()
    local e = os.clock()

    msg[#msg + 1] = string.format("have time [%f微秒]", (t1 - t0) * 1000 * 1000)
    msg[#msg + 1] = string.format("have time [%f毫秒]", (t1 - t0) * 1000)
    msg[#msg + 1] = string.format("have time [%s秒]", (e - s))

    local mem2 = collectgarbage("count")
    msg[#msg + 1] = string.format("添加变量后: %0.2f kb, 增加 %0.2f kb", mem2, mem2 - mem1)

    -- 内存回收
    collectgarbage("collect")

    -- 检查回收完的内存
    local mem3 = collectgarbage("count")
    msg[#msg + 1] = string.format("垃圾收集一次: %0.2fkb, 减少 %0.2fkb", mem3, mem3 - mem2)
    -- if c_err[0] ~= nil then
    --   error(ffi.string(c_err[0]))
    -- end
    print(table.concat(msg, "\n"))
    -- return r
end

local os = require 'os'
local lmdb = require 'src/lmdb'
local utils = require 'src/utils'
local dump = utils.dump
local testdb = './db/test-10k'
local env, msg = nil
local int_db = nil

local imgu = require("src/imgutils")
local image_path = "tests/drive/my.jpg"
local image_copy_path = "tests/drive/my-copy.jpg"
local label = 'my 相册'

--以下按照table分类测试用例（分组TestRoaring）
TestLMDBIntKeys = {} --class

function TestLMDBIntKeys:setUp()
    print("\n", string.rep("-", 100), "set up")

    env, msg = lmdb.environment(testdb, {subdir = false, max_dbs=8})
    int_db = env:db_open( 'str_keys', {integer_keys = false})

    local mdbVal=imgu:readImg(image_path)
    env:transaction(function(txn)
        txn:put("img", mdbVal)
        txn:put("label", label)
    end, lmdb.WRITE, int_db)
end

function TestLMDBIntKeys:tearDown()
    print("\n", string.rep("-", 100), "tear down")

    env = nil
    msg = nil
    collectgarbage()
    os.remove(testdb)
    os.remove(testdb .. '-lock')
end

function TestLMDBIntKeys:test1_get_img_from_test_database()
    pref(
        function()
                -- lu.assertNil(msg)
                env:transaction(function(txn)
                    local valImg=txn:get("img")
                    local valLabel=txn:get("label")

                    imgu:fwriteImg(image_copy_path,valImg);
                    print(valLabel)
                    print(tonumber(valImg.mv_size))

                end, lmdb.READ_ONLY, int_db)
        end
    )
end


local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
-- runner:setOutputType("junit")
os.exit(runner:runSuite())
