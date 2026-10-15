--!strict
-- Boot. Dev A's half.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared.Remotes)

local FirstPerson = require(script.FirstPerson)
local CarryController = require(script.CarryController)
local Hud = require(script.Hud)

FirstPerson.start()
CarryController.start()
Hud.start()

Remotes.get(Remotes.S2C.StateChanged).OnClientEvent:Connect(function(state: string)
	print("[HuntOrDie] state ->", state)
end)
