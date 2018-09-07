require("stdlib.area.chunk");
require ("src.Actions.SendScoutingPartyAction");

ExpansionPlanner = {};
ExpansionPlanner.__index = ExpansionPlanner;

function ExpansionPlanner:new (params)
  params = params or {};

  return setmetatable({
    state = {
      boundary = {}, -- ChunkIndex -> ChunkPosition
  
      activeActions = {}
    }
  }, self);
end

function ExpansionPlanner:initialize(hive)
  self.hive = hive;

  for index, chunkPos in pairs(hive.knownChunks) do
    local up = {
      x = chunkPos.x,
      y = chunkPos.y - 1
    }

    local down = {
      x = chunkPos.x,
      y = chunkPos.y + 1
    }

    local left = {
      x = chunkPos.x - 1,
      y = chunkPos.y
    }

    local right = {
      x = chunkPos.x + 1,
      y = chunkPos.y
    }

    if (hive.knownChunks[Chunk.get_index(hive.hiveBuilding.surface, up)] == nil) then
      self:addChunkToBoundary(Chunk.get_index(hive.hiveBuilding.surface, up), up);
    end
    if (hive.knownChunks[Chunk.get_index(hive.hiveBuilding.surface, down)] == nil)then
      self:addChunkToBoundary(Chunk.get_index(hive.hiveBuilding.surface, down), down);
    end
    if (hive.knownChunks[Chunk.get_index(hive.hiveBuilding.surface, left)] == nil) then
      self:addChunkToBoundary(Chunk.get_index(hive.hiveBuilding.surface, left), left);
    end
    if (hive.knownChunks[Chunk.get_index(hive.hiveBuilding.surface, right)] == nil)  then
      self:addChunkToBoundary(Chunk.get_index(hive.hiveBuilding.surface, right), right);
    end
  end
end

function ExpansionPlanner:addChunkToBoundary(chunkIndex, chunkPosition)
  --Debug.log("ExpansionPlanner::addChunkToBoundary - Request to add " .. serpent.line(chunkPosition) .. " with index " .. serpent.line(chunkIndex));

  if (self.state.boundary[chunkIndex] == nil) then
    self.state.boundary[chunkIndex] = chunkPosition;
  end
    --Debug.log("ExpansionPlanner::addChunkToBoundary - Chunk is already in the boundary"); 
end

function ExpansionPlanner:update(hive)
  for i = #self.state.activeActions, 1, -1 do
    local action = self.state.activeActions[i];

    action:update(hive);

    if (action:isDone()) then
      table.remove(self.state.activeActions, i);
      action:applyResult(self, hive);

      Debug.log("ExpansionPlanner::update - Action complete, action table size: " .. serpent.line(#self.state.activeActions));
    end
  end

  

  if (#hive.knownChunks > 30) then
    --Debug.log("ExpansionPlanner:update - Hive knows chunks count was greater than 30");
    return;
  end

  if (#(self.state.boundary) > 0) then
    if (#self.state.activeActions == 0) then
      Debug.log("ExpansionPlanner::update - Creating scouting party action");
      Debug.log("ExpansionPlanner::update - Boundary size: " .. serpent.line(#self.state.boundary));

      local chunkToExplore = nil;

      for key, value in pairs(self.state.boundary) do
        chunkToExplore = value;
        break;
      end

      Debug.log("Selected chunk to explore: " .. serpent.line(chunkToExplore));

      local scoutingPartyAction = SendScoutingPartyAction:new({
        chunkTo = chunkToExplore
      });

      table.insert(self.state.activeActions, scoutingPartyAction);
    end
  end

end