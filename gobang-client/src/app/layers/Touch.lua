local Touch = class("Touch", function()
    return display.newLayer()
end)

function Touch:ctor()
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
    self:setTouchEnabled(true)
end

function Touch:onTouch(event)
    if event.name == "began" then
        self._isValidClick = true
        return true
    end

    if event.name == "moved" then
        -- self._isValidClick = false
    end

    if event.name == "ended" and self._isValidClick == true then
        self:onClickPos(event.x, event.y)
    end
end

function Touch:onClickPos(posX, posY)
    local x, y = math.floor(posX / CONST_SPACE), math.floor(posY / CONST_SPACE)

    local PutReq = pb2_pb.PutReq()
    PutReq.x = 3
    PutReq.y = 4
    MgrNet:send(MSG.PUT_CHESS_REQ, PutReq:SerializeToString())
end

return Touch