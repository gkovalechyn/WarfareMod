require("stdlib.area.chunk");
require("src.HiveChunkData");
require("src.ExpansionPlanner");
require("src.UnitGroup");

HiveType = {
  NORMAL = 0,
  AGGRESSIVE = 1,
  TURTLE = 2
};

DefaultGroupCompositions = {};
groupComposition1 = {};
groupComposition1["small-biter"] = 2;
groupComposition1["medium-biter"] = 1;

table.insert(DefaultGroupCompositions, groupComposition1);

Hive = {};
Hive.__index = Hive;

function Hive:new (params)
  params = params or {};

  return setmetatable({
    hiveBuilding = nil,
    position = {
      x = 0,
      y = 0
    },

    force = params.force or "neutral",
    resource = params.resource or 0,

    type = params.type or HiveType.NORMAL,

    ownedChunks = {}, -- chunkIndex -> ChunkPosition
    knownChunks = {}, -- chunkIndex -> ChunkPosition

    buildings = {},

    unitCount = 0,
    units = {},

    unitGroupCompositions = DefaultGroupCompositions,

    planner = nil
  }, Hive);
end

--[[
  Tries to place the hive at the given position.

  Parameters:
    position - Where to place the hive.

  Returns:
    True if was able to place the hive at the given position;
    False otherwise.
--]]
function Hive:tryToPlaceAt(position)
  if (not self:isPlaced()) then
    --The size of the hive is 16x16
    local goodPosition = game.surfaces[1].find_non_colliding_position("warfare-hive", position, 8, 1);

    if (goodPosition ~= nil) then
      self.position = goodPosition;
      self.hiveBuilding = game.surfaces[1].create_entity({
        name = "warfare-hive",
        position = self.position,
        force = self.force
      });

      log("Hive::tryToPlaceAt - Found good hive position at: " .. serpent.line(self.position));

      local chunkData = HiveChunkData:new();
      chunkData.owner = self;
      chunkData.ownerForce = self.force;

      local chunkPosition = Chunk.from_position(goodPosition);
      Chunk.set_data(self.hiveBuilding.surface, chunkPosition, chunkData);

      local chunkIndex = Chunk.get_index(self.hiveBuilding.surface, chunkPosition);
      
      --table.insert(self.knownChunks, chunkPosition);
      --table.insert(self.ownedChunks, chunkPosition);
      self.knownChunks[chunkIndex] = chunkPosition;
      self.ownedChunks[chunkIndex] = chunkPosition;

      return true;
    end
  else
    log("Hive:tryToPlaceAt - Tried to place an hive that has already been placed (" .. serpent.line(self.force) .. ")");
  end

  return false;
end

function Hive:spawnUnitGroup(composition, position)
  if (not position) then
    position = game.surfaces[1].find_non_colliding_position("medium-biter", self.position, 16, 1);
  end

  local group = UnitGroup:new({
    position = position,
    force = self.force
  });

  for entityName, count in pairs(composition) do
    for i = 1, count, 1 do 
      local unit = self.hiveBuilding.surface.create_entity({
        name = entityName,
        position = position,
        force = self.force
      });

      group:addUnit(unit);
      position.x = position.x - 0.5;
    end 
  end

  return group;
end

function Hive:returnGroup(group)
  if (group:isValid()) then
    for i = 1, #group.units, 1 do
      group.units[i].destroy();
    end

    group:destroy();
  else
    log("Hive::returnGroup - Group was not valid");
  end
end

--[[
  Checks if this hive has already been placed.
  Parameters:
    None
  Return:
    True if has been placed, false otherwise.
--]]
function Hive:isPlaced()
  return self.hiveBuilding ~= nil;
end

function Hive:update()
  if (not self:isPlaced()) then
    return;
  end

  if (self.planner) then
    self.planner:update(self);
  end
end

function Hive:delete()
  
end