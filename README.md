[![Build Status](https://travis-ci.org/calind/lmdb-lua-ffi.svg?branch=master)](https://travis-ci.org/calind/lmdb-lua-ffi)

lmdb-lua-ffi
============

LuaJIT FFI based bindings for lmdb (http://symas.com/mdb/). This library is work-in-progess and is far for being stable. The interface is inspired by [py-lmdb](http://lmdb.readthedocs.org/).

So far the environment and transaction implementation in almost complete. The cursors are WIP.

luarocks --lua-dir=/usr/local/opt/lua@5.1 install busted
luarocks --lua-dir=/usr/local/opt/lua@5.1 install luafilesystem
luarocks --lua-dir=/usr/local/opt/lua@5.1 install lua_cliargs
luarocks --lua-dir=/usr/local/opt/lua@5.1 install penlight
luarocks --lua-dir=/usr/local/opt/lua@5.1 install lua-term
luarocks --lua-dir=/usr/local/opt/lua@5.1 install luasystem
luarocks --lua-dir=/usr/local/opt/lua@5.1 install mediator_lua
luarocks --lua-dir=/usr/local/opt/lua@5.1 install lua_cliargs
luarocks --lua-dir=/usr/local/opt/lua@5.1 install luassert
luarocks --lua-dir=/usr/local/opt/lua@5.1 install say
busted -v
busted -o TAP

TODO
废弃 busted； 改用 luaunit

underscore提供集合数组func Object 的常用函数； 建議使用Lo-Dash，性能優異很多的實現。
Underscore.funcs.for_each = Underscore.funcs.each
Underscore.funcs.collect = Underscore.funcs.map
Underscore.funcs.inject = Underscore.funcs.reduce
Underscore.funcs.foldl = Underscore.funcs.reduce
Underscore.funcs.filter = Underscore.funcs.select
Underscore.funcs.every = Underscore.funcs.all
Underscore.funcs.some = Underscore.funcs.any
Underscore.funcs.head = Underscore.funcs.first
Underscore.funcs.tail = Underscore.funcs.rest
Underscore.lua, 一个Lua版本的Underscore, 函数都通用. 包含面向对象封装和链式语法. (源码)
_ = require 'underscore' 是一个提供一组实用程序的Lua库   用于处理迭代器，数组，表和函数的函数。   这是api和文档受Underscore.lua的启发。   在Lua中使用下划线字符来丢弃变量是惯用的，所以你可以简单地将它分配给另一个变量名




Copyright and License
=====================

Copyright (c) 2014, Calin Don
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
