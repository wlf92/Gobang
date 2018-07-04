require("app.proto.pb2_pb")

CONST_SPACE = 80


local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()

    display.newColorLayer(cc.c4b(222, 129, 0, 255)):addTo(self)

    local x = 0
    while x < display.width do
        display.newLine({ { x, 0 }, { x, display.width } }, { borderWidth = 2 }):addTo(self)
        x = x + CONST_SPACE
    end

    local y = 0
    while y < display.width + 1 do
        display.newLine({ { 0, y }, { display.width, y } }, { borderWidth = 2 }):addTo(self)
        y = y + CONST_SPACE
    end
    require("app.layers.Touch").new():addTo(self)

    MgrNet:startConnect()
end


function MainScene:onEnter()
    MgrEvent:register(MSG.GAME_STATUS, handler(self, self.recvGameStatus))
    MgrEvent:register(MSG.PUT_CHESS_ACK, handler(self, self.recvPutChessAck))
end

function MainScene:onExit()
end

function MainScene:recvGameStatus(info)
    if info.Steps == nil then
        return
    end

    for i, v in ipairs(info.Steps) do
        print(v.chair, v.x, v.y)
        require("app.component.Chess").new(v.chair):pos(40 + v.x * 80, 40 + v.y * 80):addTo(self)
    end
end

function MainScene:recvPutChessAck(datas)
    local PutAck = pb2_pb.PutAck()
    PutAck:ParseFromString(datas)

    print(PutAck.x)
    print(PutAck.y)


    -- PutAck.x = 3
    -- PutAck.y = 4
    -- MgrNet:send(MSG.PUT_CHESS_REQ, PutReq:SerializeToString())
    -- require("app.component.Chess").new(info.chair):pos(40 + info.x * 80, 40 + info.y * 80):addTo(self)
end

return MainScene