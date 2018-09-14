HiveChunkData = {};
HiveChunkData.__index = HiveChunkData;

function HiveChunkData:new (params)
  params = params or {};

  return setmetatable({
    owner = params.owner or nil, -- Hive
    ownerForce = params.ownerForce or "neutral" -- The force of whoever owns the chunk
  }, HiveChunkData)
end

