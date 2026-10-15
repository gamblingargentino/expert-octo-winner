--!strict
--[[ Dev B. Everything you earn is spent forward, never banked.

	There is no return trip and no bank, so cargo value only matters at the
	next waypoint. That is the whole economy. Keep it that small.

	Shape is picked by Config.FORWARD_SPEND. If adding a second shape means
	touching anything outside this file, the economy has leaked — fix that
	instead of shipping the leak.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)

local EconomyService = {}

function EconomyService.start()
	assert(
		Config.FORWARD_SPEND == "WaypointTrader"
			or Config.FORWARD_SPEND == "CraftAndConsume"
			or Config.FORWARD_SPEND == "None",
		`unknown FORWARD_SPEND shape "{Config.FORWARD_SPEND}"`
	)
	-- TODO phase 2: thin version only. One trader, a flat stock table, no UI
	-- polish. The point is to find out whether spending forward feels good
	-- before building the real thing.
end

return EconomyService
