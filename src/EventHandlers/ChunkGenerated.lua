require("stdlib.area.chunk");
require("src.HiveChunkData");

local function handler(chunkGeneratedEvent)
  local chunkData = HiveChunkData:new();

  local hive = chunkGeneratedEvent.find_entities_filtered({
    area = chunkGeneratedEvent.area,
    limit = 1,
    type = "warfare-hive"
  });

  --If a hive was generated there by the map generation we need to make sure that if
  --there are any other biter buildings nearby they should be owned by the hive.
  if (hive ~= nil) then

  else
    local entities = chunkGeneratedEvent.find_entities_filtered({
      area = chunkGeneratedEvent.area,
      limit = 1, -- Just need to find 1 to make it owned by that force
      force = "enemy"
    });

    if (#entities > 0) then
      chunkData.owner = "enemy";
    end
  end

  local chunkPosition = Chunk.from_position(chunkGeneratedEvent.area.left_top);
  Chunk.set_data(chunkGeneratedEvent.surface, chunkPosition, chunkData);
end

return handler;