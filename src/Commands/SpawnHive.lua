require ("src.Warfare");
require ("src.ExpansionPlanner")
local function handle(table)
  --table = {name, tick, player_index, parameter}
  local player = game.players[table.player_index];
  local spawnPos = player.position;

  spawnPos.x = spawnPos.x + 40;
  spawnPos.y = spawnPos.y + 5;

  --No force specification so the controller creates a new force.
  local hive = Warfare.spawnHive(spawnPos);
  local expansionPlanner = ExpansionPlanner:new();

  expansionPlanner:initialize(hive);

  hive.planner = expansionPlanner;
  
  hive.force.set_friend("player", true);
end

return handle;