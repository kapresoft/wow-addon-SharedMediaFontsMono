--- @type Name, table
local addon, xns = ...

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
local DEFAULT_FONT_SIZE = 12
local FONT_DIR = ([[Interface\AddOns\%s\Assets\Fonts\]]):format(addon)

--- @type LibSharedMedia-3.0
local LSM = LibStub('LibSharedMedia-3.0', true)
assert(type(LSM) == 'table', ('%s:: Unexpected. LibSharedMedia-3.0 missing.'):format(addon))

LSM.MediaType.FONT_MONO = LSM.MediaType.FONT .. '-mono'
local FONT, FONT_MONO = LSM.MediaType.FONT, LSM.MediaType.FONT_MONO

local WESTERN_AND_RU = bit.bor(LSM.LOCALE_BIT_western, LSM.LOCALE_BIT_ruRU)

--- @type table<string, number>
local LOCALE_BITS = {
  koKR = LSM.LOCALE_BIT_koKR,
  ruRU = LSM.LOCALE_BIT_ruRU,
  zhCN = LSM.LOCALE_BIT_zhCN,
  zhTW = LSM.LOCALE_BIT_zhTW,
}

--- @param fontFileName string
--- @return string @The full interface path
local function fontPath(fontFileName) return FONT_DIR .. fontFileName end

--- @param filePath string
--- @return string @File name without extension; '_' and '-' become spaces
local function baseName(filePath) return (filePath:match('([^\\]+)%.%w+$'):gsub('[_%-]', ' ')) end

--- @type SharedMediaFontsMono_Catalog
local catalog = {
  {
    name = 'JetBrains Mono',
    path = fontPath('JetBrainsMono-Medium.ttf'),
    localeBit = WESTERN_AND_RU,
  },
  {
    name = 'Ubuntu Sans Mono',
    path = fontPath('UbuntuSansMono-Medium.ttf'),
    localeBit = WESTERN_AND_RU,
  },
  {
    name = 'IBM Plex Mono',
    path = fontPath('IBMPlexMono-Medium.ttf'),
    localeBit = WESTERN_AND_RU,
  },
  {
    name = 'Source Code Pro',
    path = fontPath('SourceCodePro-Medium.ttf'),
    localeBit = WESTERN_AND_RU,
  },
  {
    name = 'Roboto Mono',
    path = fontPath('RobotoMono-Medium.ttf'),
    localeBit = WESTERN_AND_RU,
  },
  {
    name = 'Inconsolata',
    path = fontPath('Inconsolata_SemiCondensed-Medium.ttf'),
    localeBit = LSM.LOCALE_BIT_western,
  },
  {
    name = 'Noto Sans Mono',
    path = fontPath('NotoSansMonoCJKsc-Regular.otf'),
    localeBit = WESTERN_AND_RU,
  },
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

--[[-----------------------------------------------------------------------------
Type: SharedMediaFontsMono
-------------------------------------------------------------------------------]]

--- @type SharedMediaFontsMono
local o = {}
SharedMediaFontsMono = o

--- @param sorted? boolean @Case insensitive sort of SharedMediaFontsMono_Font#name field
--- @return SharedMediaFontsMono_Catalog
function o:GetCatalog(sorted)
  local copy = {}
  for i, font in ipairs(catalog) do
    copy[i] = font
  end
  if sorted then table.sort(copy, function(a, b) return a.name:lower() < b.name:lower() end) end
  return copy
end

--- @param callback SharedMediaFontsMono_Callback
--- @param sorted? boolean @Defaults to true
function o:ForEachFont(callback, sorted)
  local isSorted = sorted ~= false
  for _, font in ipairs(self:GetCatalog(isSorted)) do
    callback(font)
  end
end

--[[-----------------------------------------------------------------------------
FontMixin
-------------------------------------------------------------------------------]]

--- @type SharedMediaFontsMono_FontMixin
local FontMixin = {}

--- Locale check also used to filter 'font-mono' registration:
--- LSM only applies localeBit to the 'font' media type.
--- @param locale string
--- @return boolean
function FontMixin:supports(locale)
  local localeBit = LOCALE_BITS[locale] or LSM.LOCALE_BIT_western
  return self.localeBit ~= nil and bit.band(self.localeBit, localeBit) ~= 0
end

--[[-----------------------------------------------------------------------------
Register Fonts
-------------------------------------------------------------------------------]]
--- @param str any
--- @return boolean @false if nil, not a string, empty, or just blank
local function IsValidString(str) return type(str) == 'string' and str:trim() ~= '' end

--- @param font SharedMediaFontsMono_Font
local function ValidateFont(font)
  assertsafe(IsValidString(font.name), 'Font is missing a name: %s', tostring(font.path))
  assertsafe(IsValidString(font.path), 'Font "%s" is missing a path', tostring(font.name))
  assertsafe(
    font.localeBit == nil or type(font.localeBit) == 'number',
    'Font "%s" has an invalid localeBit: %s',
    tostring(font.name),
    tostring(font.localeBit)
  )
end

--- Sets the 'font-mono' default and creates the global Font object.
--- Global name: SharedMediaFontsMono_DefaultFont
--- ## Example Usage:
--- ```
--- <Font name="MyBaseFont" inherits="SharedMediaFontsMono_DefaultFont"/>
--- ```
--- @param firstMono SharedMediaFontsMono_Font? @nil falls back to the first catalog font
--- @return Font
local function RegisterDefaultFont(firstMono)
  local font = firstMono or catalog[1]
  LSM:SetDefault(FONT_MONO, font.name)
  local defaultFont = CreateFont(addon .. '_DefaultFont')
  defaultFont:SetFont(font.path, DEFAULT_FONT_SIZE, '')
  defaultFont:SetTextColor(WHITE_FONT_COLOR:GetRGB())
  return defaultFont
end

--- Also registers under 'font-mono' if the locale supports it.
--- @param font SharedMediaFontsMono_Font
--- @param locale string
--- @return boolean @true if registered under 'font-mono'
local function RegisterFont(font, locale)
  Mixin(font, FontMixin)
  ValidateFont(font)
  LSM:Register(FONT, baseName(font.path), font.path, font.localeBit)
  if not font:supports(locale) then return false end

  LSM:Register(FONT_MONO, font.name, font.path)
  return true
end

local function RegisterCatalog()
  local locale = GetLocale()
  --- @type SharedMediaFontsMono_Font?
  local firstMono
  for _, font in ipairs(catalog) do
    if RegisterFont(font, locale) then firstMono = firstMono or font end
  end
  RegisterDefaultFont(firstMono)
end

RegisterCatalog()
