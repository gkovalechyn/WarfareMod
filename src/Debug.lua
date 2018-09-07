Debug = {
  enabled = true,
  logToPlayers = true
};

function Debug.log(text)
  if (Debug.enabled) then
    log(text);

    if (Debug.logToPlayers) then
      for name, player in pairs(game.players) do
        player.print(text);
      end
    end
  end 
end