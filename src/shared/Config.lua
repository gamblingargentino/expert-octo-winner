--!strict
--[[
	Every tuning knob in the game. One file, on purpose.

	The two numbers that decide whether the game works are in here:
	DEPTH_SPAWN_BUDGET and BAND_1_YIELD. Expect to spend more time on those
	two than on any feature. See 06 Production/Development Roadmap, phase 2.
]]

local Config = {}

-- Depth → how much threat the server is allowed to spawn.
-- Too flat and there is no reason to go deeper. Too steep and nobody survives
-- band 2. Tune this live, in playtests, with the other devs watching.
Config.DEPTH_SPAWN_BUDGET = {
	curve = 1.6, -- exponent on normalised depth
	base = 1.0,
	max = 12.0,
}

-- Band 1 must run dry. If a party can camp the outskirts and still fill cargo,
-- the game never asks "deeper?" and the whole design collapses into farming.
Config.BAND_1_YIELD = {
	initialMultiplier = 1.0,
	decayPerMinute = 0.25,
	floor = 0.15,
}

Config.BANDS = {
	{ id = "Outskirts", minDepth = 0, maxDepth = 1000 },
	{ id = "Overgrowth", minDepth = 1000, maxDepth = 2500 },
	{ id = "Deepworks", minDepth = 2500, maxDepth = 4500 },
	{ id = "OriginZone", minDepth = 4500, maxDepth = math.huge },
}

Config.CARGO = {
	maxWeight = 100,
	encumbranceStart = 0.5, -- fraction of maxWeight where slowdown begins
	minSpeedMultiplier = 0.45,
}

Config.HARVEST = {
	baseSeconds = 4.0,
	exclusive = true, -- one harvester per corpse, server-enforced
}

return Config
