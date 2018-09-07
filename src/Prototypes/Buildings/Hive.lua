data:extend({
  {
    --Prototype
    type = "simple-entity-with-force",
    name = "warfare-hive",

    --Entity
    order = "w-h",
    flags = {"player-creation", "not-repairable", "not-deconstructable", "hide-alt-info", "breaths-air"},

    collision_box = {{-8, -8}, {8, 8}},
    collision_mask = {"item-layer", "object-layer", "player-layer", "water-tile"},

    drawing_box = {{-8, -8}, {8, 8}},
    
    --minable = {} Default is false

    --subgroup = "warfare", --Editor building subgroup

    shooting_cursor_size = 1,
    selection_box = {{-8, -8}, {8, 8}},

    --autoplace = {},

    --created_smoke = {} Default smoke, uncomment to replace
    --working_soud = nil - Default value: nil
    --created_effect = nil - Default value: nil

    build_sound = nil,
    mined_sound = nil,

    --vehicle_impact_sound = {
    --  filename = "",
    -- volume = 1
    --},

    open_sound = nil,
    close_sound = nil,

    build_base_evolution_requirement = 0, -- Default: 0

    --alert_icon_shift = 0,
    --alert_icon_scale = 1,

    fast_replaceable_group = "",

    --remains_when_mined = false,

    tile_width = 16,
    tile_height = 16,

    map_color = {
      r = 1,
      g = 0,
      b = 1
    },

    friendly_map_color = {
      r = 0,
      g = 1,
      b = 0
    },

    enemy_map_color = {
      r = 1,
      g = 0, 
      b = 0
    },

    --Taken from entity-spawner
    working_sound = {
      sound ={
        {
          filename = "__base__/sound/creatures/spawner.ogg",
          volume = 1.0
        }
      },
      apparent_volume = 2
    },

    dying_sound ={
      {
        filename = "__base__/sound/creatures/spawner-death-1.ogg",
        volume = 1.0
      },
      {
        filename = "__base__/sound/creatures/spawner-death-2.ogg",
        volume = 1.0
      }
    },

    dying_explosion = "blood-explosion-huge",
    
    picture = {
      filename = "__Warfare__/graphics/Buildings/Hive/picture.png",
      priority = "medium",
      width = 512,
      height = 512,
      shift = {0, 0},
      scale = 1
    },
    
    --[[
    animations ={
      spawner_idle_animation(0, spitter_spawner_tint),
      spawner_idle_animation(1, spitter_spawner_tint),
      spawner_idle_animation(2, spitter_spawner_tint),
      spawner_idle_animation(3, spitter_spawner_tint)
    },
    --]]

    --EntityWithHealth
    max_health = 50000,
    healing_per_tick = 0.005,

    flammability = 0.1,

    dying_explosion = nil, --TODO

    loot = {},
    
    resistances = {

    },

    alert_when_damaged = false,
  }
});