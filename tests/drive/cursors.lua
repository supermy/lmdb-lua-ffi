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

local os = require "os"
local lmdb = require "src/lmdb"
local utils = require "src/utils"
local dump = utils.dump
local testdb = "./db/test-10k"
local env, msg = nil
local intdb = nil

--以下按照table分类测试用例（分组TestRoaring）
TestLMDBCursors = {} --class

function TestLMDBCursors:setUp()
    print("\n", string.rep("-", 100), "set up")

    env, msg = lmdb.environment(testdb, {subdir = false, max_dbs = 8})
    intdb = env:db_open("int_db", {integer_keys = true})
    env:transaction(
        function(txn)
            for i = 1, 100 do
                txn:put(101 - i, 101 - i)
            end
        end,
        lmdb.WRITE,
        intdb
    )
end

function TestLMDBCursors:tearDown()
    print("\n", string.rep("-", 100), "tear down")

    env = nil
    msg = nil
    collectgarbage()
    os.remove(testdb)
    os.remove(testdb .. "-lock")
end

function TestLMDBCursors:test1_checks_cursor_simple_iteration()
    pref(
        function()
            env:transaction(
                function(txn)
                    local i, c = 1, txn:cursor()
                    for k, v in c:iter() do
                        lu.assertEquals(k, tonumber(tostring(v)))
                        lu.assertEquals(k, i)
                        i = i + 1
                    end
                end,
                lmdb.READ_ONLY,
                intdb
            )
        end
    )
end

function TestLMDBCursors:test2_checks_cursor_reverse_iteration()
    pref(
        function()
            env:transaction(
                function(txn)
                    local i, c = 100, txn:cursor()
                    for k, v in c:iter({reverse = true}) do
                        lu.assertEquals(k, tonumber(tostring(v)))
                        lu.assertEquals(k, i)
                        i = i - 1
                    end
                end,
                lmdb.READ_ONLY,
                intdb
            )
        end
    )
end
function TestLMDBCursors:test3_checks_cursor_seek()
    pref(
        function()
            env:transaction(
                function(txn)
                    local i, c = 50, txn:cursor()
                    lu.assertEquals(50, tonumber(tostring(c:seek(50))))
                    i = 50
                    for k, v in c:iter() do
                        lu.assertEquals(k, tonumber(tostring(v)))
                        lu.assertEquals(k, i)
                        i = i + 1
                    end
                end,
                lmdb.READ_ONLY,
                intdb
            )
        end
    )
end
function TestLMDBCursors:test4_checks_cursor_seek_not_found()
    pref(
        function()
            env:transaction(
                function(txn)
                    local c = txn:cursor()
                    lu.assertNil(c:seek(101))
                end,
                lmdb.READ_ONLY,
                intdb
            )
        end
    )
end
function TestLMDBCursors:test6_checks_cursor_iteration_after_seek_not_found()
    pref(
        function()
            env:transaction(
                function(txn)
                    local i, c = 1, txn:cursor()
                    lu.assertNil(c:seek(0))
                    for k, v in c:iter() do
                        lu.assertEquals(k, tonumber(tostring(v)))
                        lu.assertEquals(k, i)
                        i = i + 1
                    end
                end,
                lmdb.READ_ONLY,
                intdb
            )
        end
    )
end

function TestLMDBCursors:test7_checks_cursor_seek_first_found()
    pref(
        function()
            env:transaction(
                function(txn)
                    local c = txn:cursor()
                    local k, v = c:seek(0, true)
                    lu.assertEquals(1, k)
                end,
                lmdb.READ_ONLY,
                intdb
            )
        end
    )
end
-- class TestLMDBCursors

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
