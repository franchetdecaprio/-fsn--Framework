Util = {}

--[[
	Util.Tick(f: function, ms=0: number)
		A simple wrapper for CreateThread + while
]]
function Util.Tick(f, ms)
	Citizen.CreateThread(function()
		while true do
			f()
			Citizen.Wait(ms or 0)
		end
	end)
end

--[[
	Util.Repeat(f: function, s=0: number)
		Easy way to repeat something for x amount of seconds, good for locking animations
]]
function Util.Repeat(f, s)
	Citizen.CreateThread(function()
		local start = GetGameTimer()
		local ms = s * 1000
		while true do
			Citizen.Wait(0)
			if start+ms <= GetGameTimer() then
				f()
			else
				break;		
			end
		end
	end)
end

--[[
	struct Color
		{r: number, g: number, b: number, a: number}
]]
Color = {}
Color.White = {255,255,255,255}

--[[
	Util.DrawText(text: string, font: number, center: bool,
	              x: number, y: number, scale: number, col: Color)
]]
function Util.DrawText(text, font, center, x,y, scale, col)
	SetTextFont(font)
	SetTextScale(scale, scale)
	SetTextColour(col[1],col[2],col[3],col[4])
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow() -- Probably don't need both of these
	SetTextOutline()
	SetTextCentre(center)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

--[[
	Util.DrawText3D(x: number, y: number, z: number, text: string, col: Color, scale: number)
]]
function Util.DrawText3D(x, y, z, text, col, scale)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if onScreen then
        SetTextScale(scale,scale)--(0.3, 0.3)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(col[1],col[2],col[3],col[4])--(255, 255, 255, 140)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

--[[
	Util.GetPlayers()
		Stolen from Frazzle in #scripting-gated, returns a table of players
]]
function Util.GetPlayers()
    local Players = {}
    for Index = 0, 256 do
        if NetworkIsPlayerActive(Index) then
            table.insert(Players, Index)
        end
    end

    return Players
end
	
--[[
	Util.PrependTable(t: table, v: any)
		Add the value to position one of the original table and return it
]]--
function Util.PrependTable(t, v)
	if not t then print('fsn_main (cl_utils.lua) [Util.PrependTable] - You need to provide a table in argument position 1') return end
	if not v then print('fsn_main (cl_utils.lua) [Util.PrependTable] - You need to provide a value in argument position 2') return end
	if #t > 0 and not t[1] then print('fsn_main (cl_utils.lua) [Util.PrependTable] - Table provided is not using numbers for keys.') return end
	
	local newt = {}
	table.insert(newt, 1, v)
	for i=1,#t do 
		table.insert(newt, i+1, t[i])
	end
	
	return newt
end
--[[
	Util.GetClosestPlayer()
		Stolen from Frazzle in #scripting-gated, returns the closest player + how far away they are 
]]
function Util.GetClosestPlayer()
    local Players = self:GetPlayers()
    local ClosestDistance = -1
    local ClosestPlayer = -1
    local PlayerPed = PlayerPedId()
    local PlayerPosition = GetEntityCoords(PlayerPed, false)
    
    for Index = 1, #Players do
        local TargetPed = GetPlayerPed(Players[Index])
        if PlayerPed ~= TargetPed then
            local TargetCoords = GetEntityCoords(TargetPed, false)
            local Distance = #(PlayerPosition - TargetCoords)

            if ClosestDistance == -1 or ClosestDistance > Distance then
                ClosestPlayer = Players[Index]
                ClosestDistance = Distance
            end
        end
    end
    
    return ClosestPlayer, ClosestDistance
end

--[[
	Iterators
		Util.FindObjects()
		Util.FindVehicles()
		Util.FindPickups()

		Usage:
		for ped in Util.FindPeds() do
			<do something with 'ped'>
		end
		Recommend using https://luafun.github.io/intro.html to filter etc

	https://gist.github.com/IllidanS4/9865ed17f60576425369fc1da70259b2
]]
do
	local gc = {}
	function gc.__gc(p)
		if p.h then p.d(p.h) end
		p.h, p.n, p.d = nil
	end
	local function gen(p, ent)
		ent = ent ~= -1 and ent or nil
		return ent, ent and select(2, p.n(p.h)) or gc.__gc(p)
	end
	local function iterator(init, next, drop)
		local handle, ent = init()
		local param = setmetatable({ha=handle, next=next, drop=drop}, gc)
		return gen, param, ent
	end

	function Util.FindObjects()
		return iterator(FindFirstObject, FindNextObject, EndFindObject)
	end

	function Util.FindVehicles()
		return iterator(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
	end

	function Util.FindPickups()
		return iterator(FindFirstPickup, FindNextPickup, EndFindPickup)
	end
end

function Util.GetKeyNumber(key)
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
	return Keys[key]
end

--[[
local function iterator(init, next, drop)
	return coroutine.wrap(function()
		local iter, ent = init()
		if iter == -1 then return end
		
		local enum = setmetatable({i=iter, d=drop}, {__gc=gc})
		
		while ent ~= -1 do
			coroutine.yield(ent)
			_, ent = next(iter)
		end
		gc(enum)
	end)
end]]
