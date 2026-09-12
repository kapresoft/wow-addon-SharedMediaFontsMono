local addon, xns = ...

--- @type SharedMediaFontsMono
local o = {}
SharedMediaFontsMono = o

--- @type LibSharedMedia-3.0
local LSM = LibStub('LibSharedMedia-3.0')
local FONT = LSM.MediaType.FONT
local WESTERN_AND_RU = bit.bor(LSM.LOCALE_BIT_western, LSM.LOCALE_BIT_ruRU)

--- @type table<string, number>
local LOCALE_BITS = {
  koKR = LSM.LOCALE_BIT_koKR,
  ruRU = LSM.LOCALE_BIT_ruRU,
  zhCN = LSM.LOCALE_BIT_zhCN,
  zhTW = LSM.LOCALE_BIT_zhTW,
}

local path = ([[Interface\AddOns\%s\Assets\Fonts\]]):format(addon)

--- @param fontFileName string
--- @return string @The full interface path
local function fontPath(fontFileName) return path .. fontFileName end

--- @type SharedMediaFontsMono_Catalog
local catalog = {
  {
    name = 'JetBrains Mono',
    path = fontPath('JetBrainsMono-Regular.ttf'),
    localeBit = WESTERN_AND_RU,
  },
  { name = 'PT Mono', path = fontPath('PTMono-Regular.ttf'), localeBit = WESTERN_AND_RU },
  { name = 'Ubuntu Mono', path = fontPath('UbuntuMono-Regular.ttf'), localeBit = WESTERN_AND_RU },
  {
    name = 'Noto Sans Mono (Korean)',
    path = fontPath('NotoSansMonoCJKkr-Regular.otf'),
    localeBit = LSM.LOCALE_BIT_koKR,
  },
  {
    name = 'Noto Sans Mono (Simplified Chinese)',
    path = fontPath('NotoSansMonoCJKsc-Regular.otf'),
    localeBit = LSM.LOCALE_BIT_zhCN,
  },
  {
    name = 'Noto Sans Mono (Traditional Chinese)',
    path = fontPath('NotoSansMonoCJKtc-Regular.otf'),
    localeBit = LSM.LOCALE_BIT_zhTW,
  },
}

--- @param font SharedMediaFontsMono_Font
--- @param locale string
--- @return boolean
local function CatalogFontSupports(font, locale)
  local localeBit = LOCALE_BITS[locale] or LSM.LOCALE_BIT_western
  return font.localeBit ~= nil and bit.band(font.localeBit, localeBit) ~= 0
end

--- @param sorted? boolean @Case insensitive sort of SharedMediaFontsMono_Font#name field [Optional]
--- @return SharedMediaFontsMono_Catalog
function o:GetCatalog(sorted)
  if not sorted then return catalog end

  local sortedCatalog = {}
  for i, font in ipairs(catalog) do
    sortedCatalog[i] = font
  end
  table.sort(sortedCatalog, function(a, b) return a.name:lower() < b.name:lower() end)
  return sortedCatalog
end

--- @param callback SharedMediaFontsMono_Callback
--- @param sorted boolean? @sorted is true by default
function o:ForEachFont(callback, sorted)
  local isSorted = sorted ~= false
  for _, font in ipairs(self:GetCatalog(isSorted)) do
    callback(font)
  end
end

--[[-----------------------------------------------------------------------------
Register Fonts
-------------------------------------------------------------------------------]]
--- @param str any
--- @return boolean @false if nil, not a string, empty, or just blank
local function IsValidString(str) return type(str) == 'string' and str:trim() ~= '' end

--- @param font SharedMediaFontsMono_Font
local function validateFont(font)
  assertsafe(IsValidString(font.name), 'Font is missing a name: %s', tostring(font.path))
  assertsafe(IsValidString(font.path), 'Font "%s" is missing a path', tostring(font.name))
  assertsafe(
    font.localeBit == nil or type(font.localeBit) == 'number',
    'Font "%s" has an invalid localeBit: %s',
    tostring(font.name),
    tostring(font.localeBit)
  )
end

--- Creates and registers the addon's default Font object, using the first catalog font.
--- Global name: SharedMediaFontsMono_DefaultFont
--- ## Example Usage:
--- ```
--- <Font name="MyBaseFont" inherits="SharedMediaFontsMono_DefaultFont"/>
--- ```
--- @return Font
local function RegisterDefaultFont()
  local defaultFont = CreateFont(addon .. '_DefaultFont')
  defaultFont:SetFont(catalog[1].path, 12, '')
  defaultFont:SetTextColor(WHITE_FONT_COLOR:GetRGB())
  return defaultFont
end

local function RegisterCatalog()
  for _, font in ipairs(catalog) do
    font.supports = CatalogFontSupports
    validateFont(font)
    LSM:Register(FONT, font.name, font.path, font.localeBit)
  end
  RegisterDefaultFont()
end

RegisterCatalog()
