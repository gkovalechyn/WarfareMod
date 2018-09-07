require ("src.Warfare");

local function handler(table)
  local player = game.players[table.player_index];

  for i = 1, #Warfare.state.hives, 1 do
    local hive = Warfare.state.hives[i];

    player.print("Hive name/force: " .. hive.force.name);
    player.print("Supply: " .. serpent.line(hive.supply));
    player.print("Known chunk count: " .. serpent.line(#hive.knownChunks) .. " | Owned chunk count: " .. serpent.line(#hive.ownedChunks));
    player.print("Building count: ".. serpent.line(#hive.buildings) .." | Unit count: " .. serpent.line(#hive.units));
    player.print("Planner active actions: " .. serpent.line(#hive.planner.state.activeActions) .. " | Boundary size: " .. serpent.line(#hive.planner.state.boundary));

  end 
end

return handler;