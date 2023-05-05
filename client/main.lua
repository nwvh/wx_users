ESX = exports["es_extended"]:getSharedObject()

local draw = false
local visiblePlayers = {}

RegisterNetEvent('wx_users:drawText')
AddEventHandler('wx_users:drawText',function()
    if draw then
        draw = false
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.4vw; background-color: rgba(24, 26, 32, 0.45); border-radius: 3px;"><font style="padding: 0.22vw; margin: 0.22vw; background-color: rgb(190, 80, 80); border-radius: 5px; font-size: 15px;"> <b>USERS</b></font><font style="background-color:rgba(20, 20, 20, 0); font-size: 17px; margin-left: 0px; padding-bottom: 2.5px; padding-left: 3.5px; padding-top: 2.5px; padding-right: 3.5px;border-radius: 0px;"></font>   <font style=" font-weight: 800; font-size: 15px; margin-left: 5px; padding-bottom: 3px; border-radius: 0px;"><b></b></font><font style=" font-weight: 200; font-size: 14px; border-radius: 0px;">Player names and IDs have been <b>disabled</b>!</font></div>',
            args = {}
          })
        else
        draw = true
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.4vw; background-color: rgba(24, 26, 32, 0.45); border-radius: 3px;"><font style="padding: 0.22vw; margin: 0.22vw; background-color: rgb(190, 80, 80); border-radius: 5px; font-size: 15px;"> <b>USERS</b></font><font style="background-color:rgba(20, 20, 20, 0); font-size: 17px; margin-left: 0px; padding-bottom: 2.5px; padding-left: 3.5px; padding-top: 2.5px; padding-right: 3.5px;border-radius: 0px;"></font>   <font style=" font-weight: 800; font-size: 15px; margin-left: 5px; padding-bottom: 3px; border-radius: 0px;"><b></b></font><font style=" font-weight: 200; font-size: 14px; border-radius: 0px;">Player names and IDs have been <b>enabled</b>!</font></div>',
            args = {}
          })
    end
end)

function DrawTxt(text, x, y, scale, size)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(scale, size)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end


local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 750 -- Edit this number if you want faster flashing

	result.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
	result.a = 234

	return result
end

local function draw3DText(pos, text, options)
    local rgb = RGBRainbow(1)
    options = options or { }
    local color = options.color or {r = 255, g = 255, b = 255, a = 255}
    local scaleOption = options.size or 0.8
    local camCoords      = GetGameplayCamCoords()
    local dist           = #(vector3(camCoords.x, camCoords.y, camCoords.z)-vector3(pos.x, pos.y, pos.z))
    local scale = (scaleOption / dist) * 2
    local fov   = (1 / GetGameplayCamFov()) * 100
    -- local scaleMultiplier = scale * fov
    SetDrawOrigin(pos.x, pos.y, pos.z, 0);
    SetTextProportional(0)
    SetTextScale(0.0, 0.28)
    SetTextColour(rgb.r,rgb.g,rgb.b,rgb.a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextFont(0)
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local allPlayers = GetActivePlayers()
        for _, v in pairs(allPlayers) do
            local targetPed = GetPlayerPed(v)
            local targetCoords = GetEntityCoords(targetPed)
            if #(coords-targetCoords) < Config.DrawDistance then
                visiblePlayers[v] = v
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if draw then
            local currentCoords = GetEntityCoords(GetPlayerPed(PlayerId()))
            for _, v in pairs(visiblePlayers) do
                local ped = GetPlayerPed(v)
                local cords = GetEntityCoords(ped)
                local health = GetEntityHealth(GetPlayerPed(v))
                local armor = GetPedArmour(GetPlayerPed(v))
                if health >= 101 then health=health-100
                elseif health <= 1 then armor = "~r~DEAD"
                else health=health end
                if #(cords-currentCoords) < Config.DrawDistance then
                    draw3DText(cords, '['..GetPlayerServerId(v)..'] '..GetPlayerName(v)..'\n~r~'..health..' ~s~| ~b~'..armor, {
                        size = Config.TextSize
                    })
                end
            end
        end
    end
end)
