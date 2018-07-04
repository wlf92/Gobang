local Chess = class("Chess", function() return display.newNode() end)

function Chess:ctor(chair)
    if chair % 2 == 0 then
        display.newSolidCircle(30, { color = cc.c4f(237 / 255, 237 / 255, 237 / 255, 1) }):addTo(self)
    else
        display.newSolidCircle(30, { color = cc.c4f(59 / 255, 32 / 255, 12 / 255, 1) }):addTo(self)
    end
end

return Chess