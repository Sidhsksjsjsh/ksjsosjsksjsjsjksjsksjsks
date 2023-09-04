repeat task.wait() until game:IsLoaded()

local RunService = game:GetService("RunService")

local VortexAPI = {}

if not getgenv().executedHi then
	getgenv().executedHi = true
else
	return
end
local httprequest = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request

local songName
local debounce = false

getgenv().stopped = false

local SSID = ""

-- local LyricsSong = Instance.new("Value")

function VortexAPI:Receive()
  ProtocolLoopSender = RunService.RenderStepped:Connect(function()
    return SSID
  end)
end

function VortexAPI:RemoteReceive(text)
	SSID = text
end

--[[function VortexAPI:Send(text)
UIButton_4.FocusLost:Connect(function(EnterScript)
   if EnterScript then
        return text
end)
end
]]
function VortexAPI:Stop()
	getgenv().stopped = true
	debounce = true
	task.wait(3)
	debounce = false
end
  
	if debounce then
		return
	end
	debounce = true


  function VortexAPI:Send(text)
    local msg = string.lower(text):gsub('"', ''):gsub(' by ','/')
    songName = string.gsub(msg, " ", ""):lower()
	local response
    local suc,er = pcall(function()
	response = httprequest({
		Url = "https://lyrist.vercel.app/api/" .. tostring(songName),
		Method = "GET",
	})
    end)
    if not suc then
	VortexAPI:RemoteReceive('Unexpected error, please retry')
	wait(0.5)
        ProtocolLoopSender:Disconnect()
	task.wait(3)
	debounce = false
	return
    end
	local lyricsData = game:GetService('HttpService'):JSONDecode(response.Body)
	local lyricsTable = {}
	if lyricsData.error and lyricsData.error == "Lyrics Not found" then
		debounce = true
		VortexAPI:RemoteReceive('Lyrics were not found')
		wait(0.5)
                ProtocolLoopSender:Disconnect()
		task.wait(3)
		debounce = false
		return
	end
	for line in string.gmatch(lyricsData.lyrics, "[^\n]+") do
		table.insert(lyricsTable, line)
	end
	VortexAPI:RemoteReceive('Fetched lyrics')
	task.wait(2)
	VortexAPI:RemoteReceive('Playing song')
	task.wait(3)
	for i, line in ipairs(lyricsTable) do
		if getgenv().stopped then
			getgenv().stopped = false
			break
		end
		VortexAPI:RemoteReceive('🎙️ | ' .. line)
		task.wait(4.7)
	end
	task.wait(3)
	debounce = false
	VortexAPI:RemoteReceive('Ended. You can request songs again.')
  wait(0.5)
  ProtocolLoopSender:Disconnect()
end
