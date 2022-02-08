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
local testdb = './db/test'
local env, msg = nil

--以下按照table分类测试用例（分组TestRoaring）
TestLMDBIntKeys = {} --class

function TestLMDBIntKeys:setUp()
    print("\n", string.rep("-", 100), "set up")

    env, msg = lmdb.environment(testdb, {subdir = false, max_dbs=8})

end

function TestLMDBIntKeys:tearDown()
    print("\n", string.rep("-", 100), "tear down")

    if env then
        env = nil
        msg = nil
    end
    collectgarbage()
    os.remove(testdb)
    os.remove(testdb .. '-lock')
end

function TestLMDBIntKeys:test1_checks_for_environment_clean_open()
    pref(
        function()
        lu.assertNil(msg)
        lu.assertNotNil(env)
        lu.assertNotNil(env['dbs'][1])
        lu.assertEquals(testdb, env:path())
        end
    )
end

function TestLMDBIntKeys:test2_check_for_read_transaction()
    pref(
        function()
                local result, msg = env:transaction(function(txn)
                    lu.assertNotNil(txn)
                    lu.assertTrue(txn.read_only)
                end, lmdb.READ_ONLY)
                lu.assertNotNil(result)
                lu.assertNil(msg)
        end
    )
end
function TestLMDBIntKeys:test3_check_database_open()
    pref(
        function()
                local test_db, msg = env:db_open('calin')
                lu.assertNil(msg)
                lu.assertNotNil(test_db)
        end
    )
end
function TestLMDBIntKeys:test4_check_read_after_commited_write()
    pref(
        function()
                local t = os.time()
                env:transaction(function(txn)
                    txn:put('test-key',t)
                end, lmdb.WRITE)
                local got_t = nil
                env:transaction(function(txn)
                    got_t = txn:get('test-key')
                end, lmdb.READ_ONLY)
                lu.assertEquals(t, tonumber(tostring(got_t)))
        end
    )
end

-- simple test functions that were written previously can be integrated
-- in luaunit too
function test1_withAssertionError()
    assert(1 == 1)
    -- will fail
    assert(1 == 2)
end

function test2_withAssertionError()
    assert("a" == "a")
    -- will fail
    assert("a" == "b")
end

function test3()
    assert(1 == 1)
    assert("a" == "a")
end

local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
-- runner:setOutputType("junit")
os.exit(runner:runSuite())
