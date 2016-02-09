gw2_nav_manager = {}

function gw2_nav_manager.ModuleInit()
	ml_node.DistanceTo = gw2_nav_manager.NodeDistanceTo
end

function gw2_nav_manager.NodeDistanceTo(self,id)
	local neighbor = self:GetNeighbor(id)
	local neighborNode = ml_nav_manager.GetNode(id)
	
	if(ValidTable(neighbor) and ValidTable(neighborNode)) then
		local nodeEntry = neighborNode:GetNeighbor(self.id)
		if(ValidTable(nodeEntry)) then
			local lowestCost = math.huge
			for id, exitPos in pairs(neighbor) do
				if (ValidTable(exitPos)) then
					for _,entryPos in pairs(nodeEntry) do
						local cost = Distance3DT(entryPos,exitPos)
						if (cost < lowestCost) then
							lowestCost = cost
						end
					end
				end
			end
			return lowestCost
		end
	end
	
	return 1
end

RegisterEventHandler("Module.Initalize",gw2_nav_manager.ModuleInit)