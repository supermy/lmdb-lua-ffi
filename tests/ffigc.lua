local ffi = require "ffi"

local n=1
local p = ffi.gc(ffi.C.malloc(n), ffi.C.free)

p = nil -- Last reference to p is gone.
-- GC will eventually run finalizer: ffi.C.free(p)

ffi.C.free(ffi.gc(p, nil)) -- Manually free the memory.
