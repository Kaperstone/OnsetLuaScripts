--[[
Copyright (C) 2019 Blue Mountains GmbH

This program is free software: you can redistribute it and/or modify it under the terms of the Onset
Open Source License as published by Blue Mountains GmbH.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the Onset Open Source License for more details.

You should have received a copy of the Onset Open Source License along with this program. If not,
see https://bluemountains.io/Onset_OpenSourceSoftware_License.txt
]]--

webgui = ImportPackage("webgui")

local CashText = 0
local SkydiveText = 0
local DrunkOn = false
local LastSoundPlayed = 0
local UIVisible = true

function OnPackageStart()

end
AddEvent("OnPackageStart", OnPackageStart)

function OnPackageStop()

end
AddEvent("OnPackageStop", OnPackageStop)

function ToggleUI()
	UIVisible = not UIVisible

	ShowHealthHUD(UIVisible)
	ShowWeaponHUD(UIVisible)
	ShowChat(UIVisible)
	webgui.SetVisibility(UIVisible)
end

function OnKeyPress(key)
	if key == "Right Ctrl" then
		ToggleUI()
	end

	if key == "V" then
		local distance = GetPlayerCameraViewDistance()

		distance = distance * 1.1

		if IsPlayerInVehicle() then
			if distance > 1000 then
				distance = 450
			end
		else
			if distance > 450 then
				distance = 250
			end
		end
		SetPlayerCameraViewDistance(distance)
	end
end
AddEvent("OnKeyPress", OnKeyPress)

function ClientSetTime(time)
	SetTime(time)
end
AddRemoteEvent("ClientSetTime", ClientSetTime)

function ClientSetFog(level)
	SetFogDensity(level)
end
AddRemoteEvent("ClientSetFog", ClientSetFog)

function ClientSetWeather(weather)
	SetWeather(weather)
end
AddRemoteEvent("ClientSetWeather", ClientSetWeather)

function PlayAudioFile(file)
	DestroySound(LastSoundPlayed)

	LastSoundPlayed = CreateSound("client/files/"..file)
	SetSoundVolume(LastSoundPlayed, 1.1)
end
AddRemoteEvent("PlayAudioFile", PlayAudioFile)

function OnSoundFinished(sound)
	--AddPlayerChat("SoundID("..sound..") finished playing!")
end
AddEvent("OnSoundFinished", OnSoundFinished)

function ClientSetCash(cash)
	webgui.SetText(CashText, "<span style=\"color: green; font-weight: bold;\">$"..tostring(cash).."</span>")
end
AddRemoteEvent("ClientSetCash", ClientSetCash)

function OnClientWebGuiLoaded()
	CashText = webgui.CreateText("<span style=\"color: green;\">$0</span>", 10, 86, 2)

	SkydiveText = webgui.CreateText("<span style=\"color: white;\">SKYDIVE<br></span>", 20, 86, 2)
	webgui.SetTextVisible(SkydiveText, false)
end
AddEvent("OnClientWebGuiLoaded", OnClientWebGuiLoaded)

function OnPlayerSkydive()
	AddPlayerChat("OnPlayerSkydive")

	webgui.SetTextVisible(SkydiveText, true)
end
AddEvent("OnPlayerSkydive", OnPlayerSkydive)

function OnPlayerCancelSkydive()
	AddPlayerChat("OnPlayerCancelSkydive")

	webgui.SetTextVisible(SkydiveText, false)
end
AddEvent("OnPlayerCancelSkydive", OnPlayerCancelSkydive)

function OnPlayerParachuteOpen()
	AddPlayerChat("OnPlayerParachuteOpen")
end
AddEvent("OnPlayerParachuteOpen", OnPlayerParachuteOpen)

function OnPlayerParachuteClose()
	AddPlayerChat("OnPlayerParachuteClose")
end
AddEvent("OnPlayerParachuteClose", OnPlayerParachuteClose)

function OnPlayerParachuteLand()
	AddPlayerChat("OnPlayerParachuteLand")
end
AddEvent("OnPlayerParachuteLand", OnPlayerParachuteLand)

function OnPlayerSkydiveCrash()
	AddPlayerChat("OnPlayerSkydiveCrash")
end
AddEvent("OnPlayerSkydiveCrash", OnPlayerSkydiveCrash)

function ToggleDrunkEffect()
	if (not DrunkOn) then
		DrunkOn = true
		SetPostEffect("ImageEffects", "VignetteIntensity", 1.0)
		SetPostEffect("Chromatic", "Intensity", 5.0)
		SetPostEffect("Chromatic", "StartOffset", 0.1)
		SetPostEffect("MotionBlur", "Amount", 0.05)
		SetPostEffect("MotionWhiteBalanceBlur", "Temp", 7000)
		SetCameraShakeRotation(0.0, 0.0, 1.0, 10.0, 0.0, 0.0)
		SetCameraShakeFOV(5.0, 5.0)
		PlayCameraShake(100000.0, 2.0, 1.0, 1.1)
	else
		DrunkOn = false
		SetPostEffect("ImageEffects", "VignetteIntensity", 0.25)
		SetPostEffect("Chromatic", "Intensity", 0.0)
		SetPostEffect("Chromatic", "StartOffset", 0.0)
		SetPostEffect("MotionBlur", "Amount", 0.0)
		SetPostEffect("MotionWhiteBalanceBlur", "Temp", 6500)
		StopCameraShake(false)
	end
end
AddRemoteEvent("ToggleDrunkEffect", ToggleDrunkEffect)
