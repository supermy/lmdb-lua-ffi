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
废弃 busted； 改用 luaunit

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
