-- test 1
local function t1()
  local addon = 'SharedMediaFontsMono'
  --- Loads SharedMediaFontsMono (LoadOnDemand); safe to call repeatedly.
  --- @return boolean? @false if the client refused to load it
  local function LoadSharedMediaFontsMono()
    if C_AddOns.IsAddOnLoaded(addon) then return true end

    local loaded, reason = C_AddOns.LoadAddOn(addon)
    if not loaded then
      local why = _G['ADDON_' .. tostring(reason)] or tostring(reason)
      print(addon, 'failed to load:', why)
    end
    return loaded
  end

  -- Example: fonts are registered with LSM as soon as it loads
  if LoadSharedMediaFontsMono() then
    local LSM = LibStub('LibSharedMedia-3.0')
    local fontN = 'PT Mono'
    local path = LSM:Fetch('font-mono', fontN)
    print(addon, 'name=', fontN, 'path=', path)
    local fontND = LSM:GetDefault('font-mono')
    print(addon, 'default, name=', fontND, 'path=', LSM:Fetch('font-mono', fontND))
  end
end; t1()
