local Utils = {}

Utils.newButton = function(img) 
    local btn = ccui.Button:create()
    btn:loadTextures(img, img)
    btn:setPressedActionEnabled(true)
    btn:addTouchEventListener(function(sender, event)
        if event == ccui.TouchEventType.ended and btn._clickCB then
            btn._clickCB()
        end
    end)

    -- function extend
    btn.onClickEvent = function(_btn, clickCB)
        btn._clickCB = clickCB
        return self
    end

    return btn
end

Utils.calculatePos = function(totalPoint, currPoint, space)
    return (-totalPoint / 2 + 0.5 + currPoint - 1) * space
end

return Utils