HiveChunkClaimedEvent = {};

local DEFAULT = {

};

HiveChunkClaimedEvent.new = function(other){
  if (other){

  }else{
    return table.deepCopy(DEFAULT);
  }
}