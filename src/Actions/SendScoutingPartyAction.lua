require ("src.Actions.ActionResult");
require ("stdlib.area.chunk");
require ("src.Debug");

PartyState = {
  NOT_STARTED = 0,
  GOING_TO_CHUNK = 1,
  GOING_BACK = 2,
  RETREATING = 3
};

SendScoutingPartyAction = {};
SendScoutingPartyAction.__index = SendScoutingPartyAction;



function SendScoutingPartyAction:new (params)
  params = params or {};

  return setmetatable({
    chunkTo = params.chunkTo or nil,

    cost = 200, -- Cost required to send a scouting party

    --internal
    state = PartyState.NOT_STARTED,
    result = ActionResult.NOT_FINISHED,
    done = false,
    unitGroup = nil --The group that went to scout
  }, SendScoutingPartyAction);
end

function SendScoutingPartyAction:getResult()
  return self.result;
end

function SendScoutingPartyAction:isDone()
  return self.done;
end

function SendScoutingPartyAction:update(hive)
  if (self.state == PartyState.NOT_STARTED) then
    Debug.log("SendScoutingPartyAction::update - Initializing units");
    Debug.log("SendScoutingPartyAction::update - Chunk to: " .. serpent.line(self.chunkTo));

    local group = hive:spawnUnitGroup(hive.unitGroupCompositions[1]);
    local destination = { -- Go to the middle of the chunk
      x = self.chunkTo.x * 32 + 16,
      y = self.chunkTo.y * 32 + 16,
    };

    Debug.log("Destination: " .. serpent.line(destination));

    local command = {
      type = defines.command.go_to_location,
      destination = destination,
      distraction = defines.distraction.by_damage --only attack if attacked
    };

    group:setCommand(command);

    self.unitGroup = group;
    self.state = PartyState.GOING_TO_CHUNK;

  end
  
  if (not self.unitGroup:isValid()) then
    Debug.log("SendScoutingPartyAction::update - Group became invalid");

    self.done = true;
    self.result = ActionResult.FAIL;
    return;
  end
    
  if(self.state == PartyState.GOING_TO_CHUNK) then
    local group = self.unitGroup;
    local groupChunk = Chunk.from_position(group:getPosition());

    --Debug.log("Group chunk: " .. serpent.line(groupChunk) .. " | Chunk to = " .. serpent.line(self.chunkTo) .. " == " .. serpent.line(groupChunk == self.chunkTo));

    if (Chunk.xyEquals(groupChunk, self.chunkTo)) then
      Debug.log("SendScoutingPartyAction::update - Group reached the target destination");
      self.state = PartyState.GOING_BACK;
      local destination = {
        x = hive.position.x,
        y = hive.position.y - 10
      };

      local command = {
        type = defines.command.go_to_location,
        destination = destination,
        distraction = defines.distraction.by_damage 
      }

      Debug.log("SendScoutingPartyAction::update - Sending group to " .. serpent.line(destination));
      group:setCommand(command);
      self.state = PartyState.GOING_BACK;
    end
    --[[
    if (group.getState() == defines.group_state.finished) then
      local destination = hive.position;

      local command = {
        type = defines.command.go_to_location,
        destination = destination,
        distraction = defines.distraction.by_damage 
      }

      group:setCommand(command);
      self.state = PartyState.GOING_BACK;
    end
    --]]
  elseif(self.state == PartyState.GOING_BACK) then
    local destination = Chunk.from_position({
      x = hive.position.x,
      y = hive.position.y - 10
    });
    local groupChunk = Chunk.from_position(self.unitGroup:getPosition());
    
    --Debug.log("Group chunk: " .. serpent.line(groupChunk) .. " | Chunk to = " .. serpent.line(destination) .. " == " .. serpent.line(Chunk.xyEquals(destination, groupChunk)));

    if (Chunk.xyEquals(destination, groupChunk)) then
      Debug.log("SendScoutingPartyAction::update - Group got back to base.");
      self.done = true;
      self.result = ActionResult.SUCCESS;
    end
  elseif(self.state == PartyState.RETREATING) then
    local destination = Chunk.from_position(hive.position);
    local groupPosition = Chunk.from_position(self.unitGroup:getPosition());

    if (destination == groupPosition) then
      self.done = true;
      self.result = ActionResult.SUCCESS;
    end
  end
end

function SendScoutingPartyAction:applyResult(planner, hive)
  if (action.result == ActionResult.SUCCESS) then
    local chunkToIndex = Chunk.get_index(hive.hiveBuilding.surface, self.chunkTo);
    --Add the chunk we just explored to the known chunks
    hive.knownChunks[chunkToIndex] = self.chunkTo;

    hive:returnGroup(self.unitGroup);

    --Remove the chunk we just explored from the boundary
    planner.state.boundary[chunkToIndex] = nil;

    local up = {
      x = self.chunkTo.x,
      y = self.chunkTo.y - 1
    }
    local upIndex = Chunk.get_index(hive.hiveBuilding.surface, up);

    local down = {
      x = self.chunkTo.x,
      y = self.chunkTo.y + 1
    }
    local downIndex = Chunk.get_index(hive.hiveBuilding.surface, down);

    local left = {
      x = self.chunkTo.x - 1,
      y = self.chunkTo.y
    }
    local leftIndex = Chunk.get_index(hive.hiveBuilding.surface, left);

    local right = {
      x = self.chunkTo.x + 1,
      y = self.chunkTo.y
    }
    local rightIndex = Chunk.get_index(hive.hiveBuilding.surface, right);

    --Add the chunks that are around the one we just explored to the boundary
    if (hive.knownChunks[upIndex] == nil) then
      Debug.log("SendScoutingPartyAction::applyAction - Adding up chunk to the boundary - " .. serpent.line(up));
      planner:addChunkToBoundary(upIndex, up);
    end

    if (hive.knownChunks[downIndex] == nil) then
      Debug.log("SendScoutingPartyAction::applyAction - Adding up chunk to the boundary - " .. serpent.line(down));
      planner:addChunkToBoundary(downIndex, down);
    end

    if (hive.knownChunks[leftIndex] == nil) then
      Debug.log("SendScoutingPartyAction::applyAction - Adding up chunk to the boundary - " .. serpent.line(left));
      planner:addChunkToBoundary(leftIndex, left);
    end

    if (hive.knownChunks[rightIndex] == nil) then
      Debug.log("SendScoutingPartyAction::applyAction - Adding up chunk to the boundary - " .. serpent.line(right));
      planner:addChunkToBoundary(rightIndex, right);
    end
  end -- "result == success"
end