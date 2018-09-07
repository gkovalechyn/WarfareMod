HiveChunkData = {};
HiveChunkData.__index = HiveChunkData;

function HiveChunkData:new (params)
  params = params or {};

  return setmetatable({
    owner = params.owner, -- Hive
    ownerForce = params.ownerForce -- The force of whoever owns the chunk
  }, HiveChunkData)
end

