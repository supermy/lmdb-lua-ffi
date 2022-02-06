.PHONY: ver
ver:
	luajit -e 'local l = require "src/lmdb" v = l.version() print(v)'

.PHONY: deps
deps:
	busted -v
.PHONY: deps-install
deps-install:
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
	luarocks --lua-dir=/usr/local/opt/lua@5.1 install concurrentlua

.PHONY: test
test: deps
	busted -o TAP