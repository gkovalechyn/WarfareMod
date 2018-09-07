require ("src.Warfare");
require ("src.Constants");

local biterBaseBuiltEH = require("src/EventHandlers.BiterBuildingBuilt");
local entityDiedEH = require("src.EventHandlers.EntityDied");

local spawnBiterCommand = require("src.Commands.SpawnBiter");
local spawnHiveCommand = require("src.Commands.SpawnHive");
local showHivesStatsCommand = require("src.Commands.ShowHiveStats");

script.on_init(
  function()
    global.warfareState = nil;
  end
);

script.on_load(
  function(loadEvent)
    if (global.warfareState ~= nil) then
      Warfare.state = global.warfareState;
    else
      global.warfareState = nil;
    end 
  end
);

script.on_nth_tick(UPDATE_INTERVAL, 
  function()
    Warfare.update();
  end
);

script.on_event(defines.events.on_biter_base_built, biterBaseBuiltEH);
script.on_event(defines.events.on_entity_died, entityDiedEH);

commands.add_command("spawnBiter", "Spawns a biter near you", spawnBiterCommand);
commands.add_command("spawnHive", "Spawns a hive near you", spawnHiveCommand);
commands.add_command("showHiveStats", "Prints the hives stats", showHivesStatsCommand);

