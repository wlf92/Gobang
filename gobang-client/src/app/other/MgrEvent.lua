Event = {}
Event.HELLO_SEND = 1
Event.HELLO_RECV = 3


local MgrEvent = class("MgrEvent")

function MgrEvent:ctor()
    self._temp = {}
    self._forever = {}
end

function MgrEvent:register(id, func)
    self._temp[id] = func
end

function MgrEvent:registerForever(id, func)
    self._forever[id] = func
end

function MgrEvent:notify(id, info)
    if self._temp[id] then
        self._temp[id](info)
    end
    if self._forever[id] then
        self._forever[id](info)
    end
end

function MgrEvent:remove(id)
    self._forever[id] = nil
end

function MgrEvent:removeAll()
    self._temp = {}
end

return MgrEvent