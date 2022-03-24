local NitroStart=false
local cooldown = false
local nitrocount = 0
local nitrocooldown = false
local tick
local idleTime
local driftTime
local mult = 0.2
local previous = 0
local total = 0
local curAlpha = 0
local mod
local purge = false
function LocalPed()
	return GetPlayerPed(-1)
end


Citizen.CreateThread(function()
    while true do
	Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		local playerVeh = GetVehiclePedIsIn(playerPed, false)
		local vehicleClass = GetVehicleClass(playerVeh)
		local speed1 = GetEntitySpeed(playerVeh)
		local speed = speed1*3.6  
		mod = GetVehicleMod(playerVeh,11)
		mod = GetVehicleMod(playerVeh,11)
		local nitrus = round(nitrocount,1)	
		if IsPedInAnyVehicle(playerPed,false) and GetPedInVehicleSeat(playerVeh,-1)== playerPed and nitrocooldown == false then
		if IsControlJustPressed(0,29) then
		purge = true 
		Citizen.Wait(1000)
		purge = false
		end
		end
		if vehicleClass == 1 or vehicleClass == 2 or vehicleClass == 3 or vehicleClass == 4 or vehicleClass == 5 or vehicleClass == 6 or vehicleClass == 7 or vehicleClass == 9 or vehicleClass == 12 or vehicleClass == 0   then
        if IsPedInAnyVehicle(playerPed,false) and GetPedInVehicleSeat(playerVeh,-1)== playerPed and nitrocount < 100 and nitrocount > 0 and nitrocooldown == false then 
		DrawAdvancedText(0.955,0.72,0.005, 0.0028, 0.5,"Nitro: "..nitrus.." %", 0,255,0,255,6,1)		
		elseif IsPedInAnyVehicle(playerPed,false) and GetPedInVehicleSeat(playerVeh,-1)== playerPed and nitrocount >= 100 and nitrocooldown == false then
		DrawAdvancedText(0.955,0.72,0.005, 0.0028, 0.5,"Nitro: READY", 0,255,255,255,6,1)		
		elseif IsPedInAnyVehicle(playerPed,false) and GetPedInVehicleSeat(playerVeh,-1)== playerPed and nitrocooldown == true then		
		DrawAdvancedText(0.953,0.72,0.005, 0.0028, 0.5,"Nitro: Cooldown",255,50,50,255,6,1)
		elseif IsPedInAnyVehicle(playerPed,false) and GetPedInVehicleSeat(playerVeh,-1)== playerPed and nitrocount <= 0 then
		DrawAdvancedText(0.955,0.72,0.005, 0.0028, 0.5,"Nitro: Empty",0,100,255,255,6,1)
		end
		if IsPedInAnyVehicle(playerPed,false) then
		if GetPedInVehicleSeat(playerVeh,-1)== playerPed and speed > 50 and nitrocount <= 101 and nitrocooldown == false and IsVehicleOnAllWheels(GetVehiclePedIsUsing(playerPed)) then
		nitrocount = nitrocount + speed/5000
		else 
		if nitrocount < 100 and nitrocount >= 70  then 
		nitrocount = nitrocount - 0.1
		elseif nitrocount < 70 and nitrocount >= 50 then 
		nitrocount = nitrocount - 0.05
		elseif nitrocount < 50 and nitrocount > 0 then 
		nitrocount = nitrocount - 0.025	
		end
		end
		else 
		nitrocount = 0 
		end
		end
	end
end)

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
		local playerVeh = GetVehiclePedIsIn(ped, false)
		local curspd = GetEntitySpeed(ped)*3.6
				if purge == true then 
		DrawAdvancedText(0.965,0.62,0.005, 0.0028, 0.5,"Purging", 140,255,100,255,6,1) 
		end
			if  IsControlJustPressed(0, 21) and IsControlPressed(0, 32) and IsPedInAnyVehicle(ped,false) or IsControlJustPressed(2, 226) and IsControlPressed(2, 11) and IsPedInAnyVehicle(ped,false) then
					if NitroStart == false and cooldown == false and nitrocount > 99 then
							if GetPedInVehicleSeat(playerVeh, -1) == ped then 
								NitroStart=true
								nitrocooldown = true
								nitrocount = 0
							else
							ESX.ShowNotification("You got to be on a car ~g~driver's seat")
							end
						end
				end
		if NitroStart == true then
		DisableControlAction(0,23,true)
			local playerPed = GetPlayerPed(-1)
			SetVehicleEnginePowerMultiplier(playerVeh,55.0)	
			Citizen.Wait(3000)
				SetVehicleEnginePowerMultiplier(playerVeh,1.0)
				SetVehicleMod(playerVeh,11,mod)
				NitroStart=false
				cooldown= true
				Citizen.Wait(8000)
				nitrocooldown = false
				cooldown = false
		end
    end
end)


local function NitroLoop(lastVehicle)
  local player = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(player)
  local driver = GetPedInVehicleSeat(vehicle, -1)

  if lastVehicle ~= 0 and lastVehicle ~= vehicle then
    SetVehicleNitroBoostEnabled(lastVehicle, false)
    SetVehicleLightTrailEnabled(lastVehicle, false)
	SetVehicleNitroPurgeEnabled(lastVehicle, false)
    TriggerServerEvent('nitro:__sync', false, false, true)
  end
  
  if not isPurging and purge == true then
        SetVehicleNitroBoostEnabled(vehicle, false)
        SetVehicleLightTrailEnabled(vehicle, false)
        SetVehicleNitroPurgeEnabled(vehicle, true)
        TriggerServerEvent('nitro:__sync', false, true, false)
      
	end

  if vehicle == 0 or driver ~= player then
    return 0
  end

  local model = GetEntityModel(vehicle)

  if not IsThisModelACar(model) then
    return 0
  end

  local isBoosting = IsVehicleNitroBoostEnabled(vehicle)
  local isPurging = IsVehicleNitroPurgeEnabled(vehicle)

  if NitroStart then
      if not isBoosting then
        SetVehicleNitroBoostEnabled(vehicle, true)
        SetVehicleLightTrailEnabled(vehicle, true)
		SetVehicleNitroPurgeEnabled(vehicle, false)
        TriggerServerEvent('nitro:__sync', true, false, false)
	end
  elseif isBoosting or isPurging then
    SetVehicleNitroBoostEnabled(vehicle, false)
    SetVehicleLightTrailEnabled(vehicle, false)
	SetVehicleNitroPurgeEnabled(vehicle, false)
    TriggerServerEvent('nitro:__sync', false, false, false)
  
 end
  return vehicle
end



Citizen.CreateThread(function ()
  local lastVehicle = 0

  while true do
    Citizen.Wait(0)
    lastVehicle = NitroLoop(lastVehicle)
  end
end)

RegisterNetEvent('nitro:__update')
AddEventHandler('nitro:__update', function (playerServerId, boostEnabled, lastVehicle)
  local playerId = GetPlayerFromServerId(playerServerId)

  if not NetworkIsPlayerConnected(playerId) then
    return
  end

  local player = GetPlayerPed(playerId)
  local vehicle = GetVehiclePedIsIn(player, lastVehicle)
  local driver = GetPedInVehicleSeat(vehicle, -1)

  SetVehicleNitroBoostEnabled(vehicle, boostEnabled)
  SetVehicleLightTrailEnabled(vehicle, boostEnabled)
  SetVehicleNitroPurgeEnabled(vehicle, purgeEnabled)
end)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
		SetTextFont(font)
		SetTextProportional(0)
		SetTextScale(sc, sc)
		N_0x4e096588b13ffeca(jus)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - 0.1+w, y - 0.02+h)
	end
	
	
		Citizen.CreateThread(function()
		score = 0
	function round(number)
		number = tonumber(number)
		number = math.floor(number)
		if number < 0.01 then
			number = 0
		elseif number > 999999999 then
			number = 999999999
		end
		return number
	end
	
	function calculateBonus(previous)
		local points = previous
		local points = round(points)
		return points or 0
	end
	function math.precentage(a,b)
		return (a*100)/b
	end
	
	function angle(veh)
		if not veh then return false end
		local vx,vy,vz = table.unpack(GetEntityVelocity(veh))
		local modV = math.sqrt(vx*vx + vy*vy)
		local rx,ry,rz = table.unpack(GetEntityRotation(veh,0))
		local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
			if GetEntitySpeed(veh)* 3.6 < 50 or GetVehicleCurrentGear(veh) == 0 then return 0,modV end --speed over 50 km/h
			local cosX = (sn*vx + cs*vy)/modV
				if cosX > 0.966 or cosX < 0 then return 0,modV end
				return math.deg(math.acos(cosX))*0.5, modV
				end
        while true do
            Citizen.Wait(5)
			tick = GetGameTimer() 
			if not IsPedDeadOrDying(LocalPed(), 1) 
			and GetVehiclePedIsUsing(LocalPed()) 
			and GetPedInVehicleSeat(GetVehiclePedIsUsing(LocalPed()), -1) == LocalPed()
			and IsVehicleOnAllWheels(GetVehiclePedIsUsing(LocalPed())) 
			and not IsPedInFlyingVehicle(LocalPed()) then
			PlayerVeh = GetVehiclePedIsIn(LocalPed(),false)
			local angle,velocity = angle(PlayerVeh)
			local tempBool = tick - (idleTime or 0) < 4000
			if not tempBool and score ~= 0 then
				previous = score
				previous = calculateBonus(previous)
				
				total = total+previous
				TriggerEvent("driftcounter:DriftFinished", previous)
				_,oldScore = StatGetInt("MP0_DRIFT_SCORE",-1)
				StatSetInt("MP0_DRIFT_SCORE", oldScore+previous, true)
				_,newScore = StatGetInt("MP0_DRIFT_SCORE",-1)
				local data = {score = newScore} 
				score = 0
			end
			if angle >=10 then
				if score == 0 then
					drifting = true
					driftTime = tick
			end
				if tempBool then
					score = score + math.floor(angle*velocity)*mult
				else
					score = math.floor(angle*velocity)*mult
				end
				screenScore = calculateBonus(score)
				
				idleTime = tick
			end
		end
		
		if tick - (idleTime or 0) < 2000 then
			if curAlpha < 255 and curAlpha+10 < 255 then
				curAlpha = curAlpha+10
			elseif curAlpha > 255 then
				curAlpha = 255
			elseif curAlpha == 255 then
				curAlpha = 255
			elseif curAlpha == 250 then
				curAlpha = 255
			end
		else
			if curAlpha > 0 and curAlpha-10 > 0 then
				curAlpha = curAlpha-10			
				elseif curAlpha < 0 then
				curAlpha = 0

			elseif curAlpha == 5 then
				curAlpha = 0
			end
		end
		if not screenScore then 
		screenScore = 0 
		end
		DrawHudText(string.format("\n+%s",tostring(screenScore)), {153, 204, 255,curAlpha},0.9,0.575,0.6,0.6)
		if score > 1 and IsPedInAnyVehicle(GetPlayerPed(-1)) then 
		DrawHudText("Drift is active", {200, 150, 180,255},0.91,0.60,0.25,0.25)
		end
	end
end)

function DrawHudText(text,colour,coordsx,coordsy,scalex,scaley)
    SetTextFont(7)
    SetTextProportional(7)
    SetTextScale(scalex, scaley)
    local colourr,colourg,colourb,coloura = table.unpack(colour)
    SetTextColour(colourr,colourg,colourb, coloura)
    SetTextDropshadow(0, 0, 0, 0, coloura)
    SetTextEdge(1, 0, 0, 0, coloura)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(coordsx,coordsy)
end
local nitrobonus = false
local bonus = 0
RegisterNetEvent("driftcounter:DriftFinished")
AddEventHandler("driftcounter:DriftFinished",function(bonusnitro)
	bonus = bonusnitro / 2000
nitrocount = nitrocount + bonus
	nitrobonus = true
	Citizen.Wait(2000)
	nitrobonus = false
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
	if nitrobonus == true then 
	local showbonus = round(bonus,1)
	DrawHudText("Gained "..showbonus.." % nitro", {200, 255, 0,255},0.91,0.55,0.3,0.3)
	end
	end
end)
