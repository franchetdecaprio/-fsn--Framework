Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local currentChannel = -1
local expt = exports["tokovoip_script"]
local name = GetPlayerName(PlayerId())
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if exports["fsn_police"]:fsn_PDDuty() or exports["fsn_ems"]:fsn_EMSDuty() then
			if(not IsControlPressed(0, Keys["LEFTSHIFT"]) and IsControlJustPressed(0, Keys["F9"]))then
				if expt:isPlayerInChannel(1) then
					expt:addPlayerToRadio(2, name)
					TriggerEvent('fsn_notify:displayNotification', 'Joined channel: <b>EMS', 'centerLeft', 2000, 'info')
				elseif expt:isPlayerInChannel(2) then
					expt:addPlayerToRadio(1, name)
					TriggerEvent('fsn_notify:displayNotification', 'Joined channel: <b>LEO', 'centerLeft', 2000, 'info')
				else
					expt:addPlayerToRadio(1, name)
					TriggerEvent('fsn_notify:displayNotification', 'Joined channel: <b>LEO', 'centerLeft', 2000, 'info')
				end
			elseif(IsControlPressed(0, Keys["LEFTSHIFT"]) and IsControlJustPressed(0, Keys["F9"])) then
				--if expt:isPlayerInChannel(1) then
				--	TriggerEvent('TokoVoip:removePlayerFromRadio', 1)
				--	expt:refreshAllPlayerData()
				--elseif expt:isPlayerInChannel(2) then
				--	TriggerEvent('TokoVoip:removePlayerFromRadio', 2)
				--	expt:refreshAllPlayerData()
				--else
					TriggerEvent('TokoVoip:removePlayerFromRadio', 1)
					TriggerEvent('TokoVoip:removePlayerFromRadio', 2)
					TriggerEvent('fsn_notify:displayNotification', 'You left all your current VOIP channels', 'centerLeft', 2000, 'info')
					expt:refreshAllPlayerData()
				--end
			end
		end 
	end
end)