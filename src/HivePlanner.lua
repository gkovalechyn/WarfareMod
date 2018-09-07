require ("stdlib.game");

Actions = {
  WAIT = 0
}


HivePlanner = {
  state = {}
}

--[[
  Plans the next step for the hive.
  
  Parameters:
    hive - The hive for which the next action should be generated.
]]
function HivePlanner:update(hive)
  
end

function HivePlanner:new (other)
  other = other or {}   -- create object if user does not provide one
  setmetatable(other, self)
  self.__index = self
  return other
end

Game._protect(Actions);