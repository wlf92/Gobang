local ByteArray = require("app.other.ByteArray")
local SimpleTCP = require("framework.SimpleTCP")

local CONST_ADDR = "127.0.0.1"
local CONST_PORT = 18801

local MgrNet = class("MgrNet")

function MgrNet:ctor()
    self._isConnecting = false
    self._isConnected = false
    self._stcp = SimpleTCP.new(CONST_ADDR, CONST_PORT, handler(self, self.onTCPEvent))
end

function MgrNet:onTCPEvent(even, data)
    if even == SimpleTCP.EVENT_DATA then
        print("==receive data:", data)
        local recvBA = ByteArray.new()
        recvBA:writeBuf(self._lastData or "")
        recvBA:writeBuf(data)
        recvBA:setPos(1)

        while recvBA:getAvailable() > 2 do
            local availableLen = recvBA:getAvailable()
            local needLen = recvBA:readShort()
            if availableLen < needLen then
                break
            end
            local id = recvBA:readUShort()
            local str =  recvBA:readBuf(needLen - 2)
            -- recvBA:readString(needLen - 2)
            print(id)
            if id == 1000 then
                -- device.showAlert("", json.decode(str).msg, "确定")
            else
                MgrEvent:notify(id, str)
            end
        end
        self._lastData = recvBA:readBuf(recvBA:getAvailable())
    elseif even == SimpleTCP.EVENT_CONNECTING then
        print("==connecting")
        self._isConnecting = true
    elseif even == SimpleTCP.EVENT_CONNECTED then
        print("==connected")
        self._isConnecting = false
        self._isConnected = true
        if self._sendBA then
            self._stcp:send(self._sendBA:getPack())
        end
    elseif even == SimpleTCP.EVENT_CLOSED then
        print("==closed")
        self._isConnecting = false
        self._isConnected = false
        -- you can call self._stcp:connect() again or help user exit game.
    elseif even == SimpleTCP.EVENT_FAILED then
        print("==failed")
        self._isConnecting = false
        self._isConnected = false
        -- you can call self._stcp:connect() again or help user exit game.
    end
end

function MgrNet:startConnect()
    self._stcp:connect()
end

function MgrNet:send(id, datas)
    self._sendBA = ByteArray.new()
    self._sendBA:writeUShort(#datas + 2)
    self._sendBA:writeUShort(id)
    self._sendBA:writeString(datas)

    if self._isConnected == true then
        self._stcp:send(self._sendBA:getPack())
        self._sendBA = nil
    elseif self._isConnected == false then
        self._stcp:connect()
    end
end

return MgrNet