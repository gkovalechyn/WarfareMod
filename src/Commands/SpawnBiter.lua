local function handle(table)
  force1 = game.create_force("force1");
  force2 = game.create_force("force2");

  --table = {name, tick, player_index, parameter}
  local player = game.players[table.player_index];
  local spawnPos = player.position;

  spawnPos.x = spawnPos.x + 50;
  spawnPos.y = spawnPos.y + 5;

  player.surface.create_entity({
    name = "small-biter",
    position = spawnPos,

    force = force1
  }); 


  spawnPos.y = spawnPos.y - 10;

  player.surface.create_entity({
    name = "small-biter",
    position = spawnPos,

    force = "enemy"
  }); 
end

return handle;