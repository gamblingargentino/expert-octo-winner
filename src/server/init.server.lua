--!strict
-- Boot. Order matters: remotes exist before anything else runs.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared.Remotes)

Remotes.build()

local JourneyState = require(script.JourneyState)
local DepthService = require(script.DepthService)
local CargoService = require(script.CargoService)
local SpawnDirector = require(script.SpawnDirector)
local DeathService = require(script.DeathService)
local EconomyService = require(script.EconomyService)

DepthService.start()
CargoService.start()
SpawnDirector.start()
DeathService.start()
EconomyService.start()
JourneyState.start()

print("[HuntOrDie] server up")
