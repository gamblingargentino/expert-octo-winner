--!strict
--[[
	THE CONTRACT.

	Both devs code against this file and nothing else across the seam.
	Change it only by agreement — a silent change here breaks the other dev.

	Direction is in the name:
		C2S = client asks server to do a thing. Server validates. Server decides.
		S2C = server tells clients what happened. Clients never argue.

	Nothing here trusts the client. Positions, hit results, cargo value and
	depth are all re-derived server-side. See 05 Technical/Server Authority.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FOLDER_NAME = "Remotes"

export type JourneyState = "Outfit" | "Journey" | "Wipe"

--[[
	C2S — requests. Server may refuse any of these.

	Harvest(corpseId)        -> start/stop harvesting a corpse. Server holds the lock.
	PickupCargo(cargoId)     -> try to take a cargo bundle off the ground.
	SpendForward(offerId, n) -> spend at a frontier waypoint. Shape depends on the
	                            forward-spend decision; see 01 Design/Run Economy.
	LeaveSpectate()          -> spectator asks to stop following a player.
]]
local C2S = {
	Harvest = "Harvest",
	PickupCargo = "PickupCargo",
	SpendForward = "SpendForward",
	LeaveSpectate = "LeaveSpectate",
}

--[[
	S2C — announcements. Server is the only sender.

	DepthChanged(depth, bandId)   -> depth is a number; band is derived from it.
	                                 Crossing a band is NOT a state transition.
	PlayerDied(userId, cargoId)   -> cargo dropped at the death site, if any.
	StateChanged(state, payload)  -> JourneyState above. Three states, no more.
	HarvestProgress(corpseId, a)  -> a in [0, 1]. Server-driven, for the UI bar.
	CargoUpdated(userId, weight)  -> carried weight, for encumbrance feedback.
	JourneySummary(summary)       -> sent once on wipe, before restart.
]]
local S2C = {
	DepthChanged = "DepthChanged",
	PlayerDied = "PlayerDied",
	StateChanged = "StateChanged",
	HarvestProgress = "HarvestProgress",
	CargoUpdated = "CargoUpdated",
	JourneySummary = "JourneySummary",
}

local Remotes = {
	C2S = C2S,
	S2C = S2C,
}

local folder: Folder? = nil

local function container(): Folder
	if folder then
		return folder
	end

	local existing = ReplicatedStorage:FindFirstChild(FOLDER_NAME)
	if existing then
		folder = existing :: Folder
		return existing :: Folder
	end

	assert(RunService:IsServer(), "Remotes folder missing — server must build it first")

	local created = Instance.new("Folder")
	created.Name = FOLDER_NAME
	created.Parent = ReplicatedStorage
	folder = created
	return created
end

-- Server calls this once at boot, before any other module touches Remotes.
function Remotes.build()
	assert(RunService:IsServer(), "Remotes.build is server-only")

	local parent = container()
	for _, name in C2S do
		if not parent:FindFirstChild(name) then
			local event = Instance.new("RemoteEvent")
			event.Name = name
			event.Parent = parent
		end
	end
	for _, name in S2C do
		if not parent:FindFirstChild(name) then
			local event = Instance.new("RemoteEvent")
			event.Name = name
			event.Parent = parent
		end
	end
end

-- Both sides use this. Clients yield until the server has built the folder.
function Remotes.get(name: string): RemoteEvent
	local parent = container()
	local event = parent:FindFirstChild(name)
	if not event then
		assert(not RunService:IsServer(), `unknown remote "{name}"`)
		event = parent:WaitForChild(name, 10)
	end
	return assert(event, `remote "{name}" never appeared`) :: RemoteEvent
end

return Remotes
