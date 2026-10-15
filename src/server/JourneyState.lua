--!strict
--[[ Dev B. Three states. Outfit -> Journey -> Wipe -> Outfit.

	Depth is state, not a state. Crossing a band changes a variable; it does
	not transition the machine. If you find yourself adding a fourth state,
	the thing you want is probably a variable.
]]

local JourneyState = {}

local current: string = "Outfit"

function JourneyState.get(): string
	return current
end

function JourneyState.start()
	-- TODO phase 1: transition on all-ready, drive Wipe from DeathService.
end

return JourneyState
