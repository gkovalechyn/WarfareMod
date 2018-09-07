require("src.UnitGroupType");
require("src.Debug");

UnitGroup = {};
UnitGroup.__index = UnitGroup;

function UnitGroup:new (params)
  params = params or {};

  return setmetatable({
    type = params.type or UnitGroupType.ATTACK,
    force = params.force or "neutral",
    units = params.units or {},
    position = params.position or {x = 0, y = 0},

    --Internal
    lastCommand = nil,
    groupHandle = nil
  }, UnitGroup);
end

function UnitGroup:addUnit(entity)
  if (entity and entity.valid) then
    table.insert(self.units, entity);

    if (self:isHandleValid()) then
      self.groupHandle.add_member(entity);
    end
  end
end

function UnitGroup:getUnits()
  return self.units;
end

function UnitGroup:setCommand(command)
  self:updateHandleIfNotValid();

  self.groupHandle.set_command(command);
end

function UnitGroup:isHandleValid()
  return (self.groupHandle ~= nil and self.groupHandle.valid);
end

function UnitGroup:updateHandleIfNotValid()
  if (not self:isHandleValid()) then
    if (self.groupHandle) then
      self.groupHandle.delete();
    end

    self.groupHandle = game.surfaces[1].create_unit_group({
      position = self.position,
      force = self.force
    });

    for i = 1, #self.units, 1 do
      self.groupHandle.add_member(self.units[i]);
    end
  end 
end

function UnitGroup:getPosition()
  if (not self:isValid()) then
    error("Cannot return the position of an invalid group");
  end

  local pos = {
    x = 0,
    y = 0
  };

  for i = 1, #self.units, 1 do
    local entity = self.units[i];

    pos.x = pos.x + entity.position.x;
    pos.y = pos.y + entity.position.y;
  end

  pos.x = math.floor(pos.x / #self.units);
  pos.y = math.floor(pos.y / #self.units);

  return pos;
end

function UnitGroup:getState()
  if (not self:isValid()) then
    error("Cannot get the state of an invalid group.");
  end

  self:updateHandleIfNotValid();
  return self.groupHandle.state;
end

function UnitGroup:isValid()
  if (#self.units == 0) then
    return false;
  end

  for i = 1, #self.units, 1 do
    if (not self.units[i].valid) then
      return false
    end
  end

  return true;
end

function UnitGroup:destroy()
  if (self:isHandleValid()) then
    self.groupHandle.destroy();
  end
end

return UnitGroup;