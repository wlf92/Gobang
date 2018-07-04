
require("config")
require("cocos.init")
require("framework.init")

local AppBase = require("framework.AppBase")
local MyApp = class("MyApp", AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)

    math.randomseed(os.time())
end

function MyApp:run()
    if device.platform == "mac" then
        local user = os.getenv("USER")
        cc.FileUtils:getInstance():addSearchPath("/Users/"..user.."/Desktop/Gobang/gobang-client/src/")
        cc.FileUtils:getInstance():addSearchPath("/Users/"..user.."/Desktop/Gobang/gobang-client/res/")
    else
        cc.FileUtils:getInstance():addSearchPath("res/")
    end

    MSG = require("app.other.MSG")
    Utils = require("app.other.Utils")

    MgrEvent = require("app.other.MgrEvent").new()
    MgrNet = require("app.other.MgrNet").new()
    self:enterScene("GameScene")
end

return MyApp
