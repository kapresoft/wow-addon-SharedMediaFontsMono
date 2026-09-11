
local addon, xns = ...

C_Timer.After(1, function()
  print(addon, 'loaded...')
end)