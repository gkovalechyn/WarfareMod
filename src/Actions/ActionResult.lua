require ("stdlib.game");

ActionResult = {
  SUCCESS = 0, --The action succeeeded
  FAIL = 1, -- The action failed

  WAS_ATTACKED = 2, -- The group/unit performing the action was attacked, this means the the units survived and came back to base

  UNITS_DIED = 3, -- The units performing the action died

  NOT_FINISHED = 999 -- The action still hasn't finished
};


Game._protect(ActionResult);
