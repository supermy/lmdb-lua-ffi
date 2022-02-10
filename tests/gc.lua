-- lua5.1版本使用 __gc

local function setmt__gc(t, mt)
    local prox = newproxy(true)
    getmetatable(prox).__gc = function() mt.__gc(t) end
    t[prox] = true
    return setmetatable(t, mt)
end

local function gctest(self)
    print("cleaning up: ", self._name)
end

local test = setmt__gc({_name = "外星人"}, {__gc = gctest})
 collectgarbage("collect") -- 强制垃圾回收

 
