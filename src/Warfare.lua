require("src.Hive");
require("src.Debug");

Warfare = {
  state = {
    hives = {},

    nextHiveToUpdate = 1,
  }
};



--[[
  Spawns a hive at the given position with that belongs to the given force.

  Parameters:
    position: {x: x, y: y}, - The position where the hive should be placed
    force: <any force>      - (Optional) Whose hive should be placed there. If no value is supplied a new force is created.

  Returns:
    Hive - The hive that was just created.
--]]
function Warfare.spawnHive(position, force)
  if (force == nil) then
    local hives = Warfare.state.hives;
    local forces = game.forces;
    local currentIndex = #hives;

    while (forces["hive-" .. currentIndex] ~= nil) do
      currentIndex = currentIndex + 1;
    end

    Debug.log("Warfare::spawnHive - Found free hive index " .. currentIndex);

    force = game.create_force("hive-" .. currentIndex);
  end

  Debug.log("Warfare::spawnHive - Creating hive at " .. serpent.line(position) .. " belonging to force " .. force.name);

  local hive = Hive:new({
    force = force
  });

  table.insert(Warfare.state.hives, hive);

  if (hive:tryToPlaceAt(position)) then
    Debug.log("Warfare::spawnHive - Hive placed at " .. serpent.line(position));
  else
    Debug.log("Warfare::spawnHive - Was not able to place hive at " .. serpent.line(position));
  end

  return hive;
end

function Warfare.update()
  if (Warfare.state.nextHiveToUpdate > #Warfare.state.hives) then
    Warfare.state.nextHiveToUpdate = 1;
  end

  local hive = Warfare.state.hives[Warfare.state.nextHiveToUpdate];

  if (hive ~= nil) then
    hive:update();
    Warfare.state.nextHiveToUpdate = Warfare.state.nextHiveToUpdate + 1;
  end
end



--[[
function Warfare:new (other)
  other = other or {}   -- create object if user does not provide one
  setmetatable(other, self)
  self.__index = self
  return other
end
--]]