--!strict
-- Depth is a number. Bands are a read of that number, nothing more.
-- Shared so the client can label the HUD without asking the server.

local Config = require(script.Parent.Config)

local Bands = {}

function Bands.fromDepth(depth: number): string
	for _, band in Config.BANDS do
		if depth >= band.minDepth and depth < band.maxDepth then
			return band.id
		end
	end
	return Config.BANDS[1].id
end

function Bands.indexFromDepth(depth: number): number
	for index, band in Config.BANDS do
		if depth >= band.minDepth and depth < band.maxDepth then
			return index
		end
	end
	return 1
end

return Bands
