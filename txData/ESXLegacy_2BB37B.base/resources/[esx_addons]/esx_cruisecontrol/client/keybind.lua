if Config.Cruise.Enable then
    ESX.RegisterInput('esx_cruisecontrol:Enable', Translate('cruiseControl'), "keyboard", Config.Cruise.Key, function()
        if not Utils.vehicle then return end
        
        if CC.cruiseActive then
            CC:Reset()
            return
        end
        CC:Enable()
    end)

    ESX.RegisterInput('esx_cruisecontrol:IncreaseSpeed', Translate('increaseSpeed'), "keyboard", "ADD", function()
        if not Utils.vehicle then return end
        CC:ChangeSpeed(true)
    end)

    ESX.RegisterInput('esx_cruisecontrol:DecreaseSpeed', Translate('decreaseSpeed'), "keyboard", "SUBTRACT", function()
        if not Utils.vehicle then return end
        CC:ChangeSpeed(false)
    end)
end


