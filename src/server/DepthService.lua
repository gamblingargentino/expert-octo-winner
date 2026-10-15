--!strict
-- Dev B owns writes. Everyone else reads. Server-derived from party position,
-- never sent by the client.

local DepthService = {}

local depth: number = 0

function DepthService.get(): number
	return depth
end

function DepthService.start()
	-- TODO phase 1: recompute each heartbeat, fire DepthChanged on band cross.
end

return DepthService
