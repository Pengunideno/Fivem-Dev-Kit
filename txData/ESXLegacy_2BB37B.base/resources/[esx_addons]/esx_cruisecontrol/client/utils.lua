Utils = {
    ped = 0,
    vehicle = nil,
    driver = false,
    DriverCheck = function(self)
        if not self.vehicle then return false end
        if not DoesEntityExist(self.vehicle) then return false end
        if GetPedInVehicleSeat(self.vehicle, -1) == self.ped then
            return true
        end
        return false
    end,
    HudCheck = function(self)
        return GetResourceState(Config.HudResource) == 'started' and true or false
    end,
    IsSteering = function(self)
        return GetVehicleSteeringAngle(self.vehicle) > 10.0
    end,
    GetSpeed = function(self)
        if not self:DriverCheck() then return end
        local curSpeed = GetEntitySpeed(self.vehicle)
        return math.floor(curSpeed * 2.236936)
    end
}