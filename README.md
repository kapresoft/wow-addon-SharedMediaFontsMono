[![Release Build](https://github.com/kapresoft/wow-addon-SharedMediaFontsMono/actions/workflows/release-build.yml/badge.svg)](https://github.com/kapresoft/wow-addon-SharedMediaFontsMono/actions/workflows/release-build.yml)

# SharedMedia Fonts Mono :: Same width, every glyph, every addon

> ▶ A [World of Warcraft](https://worldofwarcraft.com/) AddOn

![download-count](https://cf.way2muchnoise.eu/full_1691454_downloads.svg?badge_style=for_the_badge) ![supported-wow-versions](https://cf.way2muchnoise.eu/versions/World%20of%20Warcraft%20Versions_1691454_all.svg?badge_style=for_the_badge)

A World of Warcraft addon that registers a curated collection of open-source monospace fonts with [LibSharedMedia-3.0](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation) (LSM). Once installed, any addon that supports custom fonts through LSM (chat frames, unit frames, nameplates, action bars, etc.) can use these fonts directly from its font picker.

<img width="200" alt="SharedMedia-Fonts-Mono-Logo" src="https://github.com/user-attachments/assets/31d4b829-72c2-4320-bc86-9ad25a23db14" />

Includes full Latin and Cyrillic (Russian) coverage, plus Noto Sans Mono fonts for Korean, Simplified Chinese, and Traditional Chinese clients. Western and Russian clients also get Noto Sans Mono for CJK text in names and chat.

## Typical Use Cases
- Viewing Lua code (in-game editors, error viewers, debug consoles)
- Consoles/chat frames where fixed-width output is required
- Aligning tabular data (damage meters, DPS/HPS logs, stat comparisons)
- Distinguishing similar characters (0/O, 1/l/I) in IDs, item links, or macros

## Usage

Fetch fonts through standard LSM calls, or iterate this addon's catalog to build your own font picker.

### Basic

Every font is registered under LSM's standard `font` media type, keyed by its LSM name (see [Available Fonts](https://github.com/kapresoft/wow-addon-SharedMediaFontsMono#available-fonts)), so a plain `LSM:Fetch()` is all it takes.

#### Fetching All Fonts

`LSM:List()` returns the registered names of a media type, sorted, and `LSM:HashTable()` maps each name to its path. Listing the standard `font` media type returns every font LSM knows about: these, LSM's built-in defaults, and those registered by other addons.

```lua
--- @type LibSharedMedia-3.0
local LSM = LibStub("LibSharedMedia-3.0")
local FONT = LSM.MediaType.FONT

--- @type string[]
local fontNames = LSM:List(FONT)
for _, name in ipairs(fontNames) do
  print(name, LSM:Fetch(FONT, name))
end

--- @type table<string, string>
local fonts = LSM:HashTable(FONT)
local jetBrainsMono = fonts["JetBrainsMono Medium"]
```

**Mono fonts only:** this addon also registers its fonts under `font-mono` (aliased as `LSM.MediaType.FONT_MONO` once it loads). It's not a standard LSM media type, so other addons won't look for it, but it lists just this addon's fonts for the client locale, keyed by display name (e.g. `JetBrains Mono`).

```lua
--- @type string[]
local monoFontNames = LSM:List("font-mono")
for _, name in ipairs(monoFontNames) do
  print(name, LSM:Fetch("font-mono", name))
end

--- @type table<string, string>
local monoFonts = LSM:HashTable("font-mono")
local jetBrainsMono = monoFonts["JetBrains Mono"]
```

#### Fetching Individual Fonts

Locale support is standard LSM behavior, so there's nothing to check on your side: each font is registered with the client locales it supports, and LSM skips any font that doesn't match the client. Fetching a skipped font returns LSM's default font, or `nil` if you pass `true` as the third argument (`noDefault`).

```lua
-- nil if not registered for this client's locale
local jetBrainsMono = LSM:Fetch(FONT, "JetBrainsMono Medium", true)

-- Western, Russian and Simplified Chinese clients
local notoSansMonoSC = LSM:Fetch(FONT, "NotoSansMonoCJKsc Regular")
```

#### Applying a Font to a FontString

A fetched font path, such as `jetBrainsMono` above, goes straight into `SetFont()` on any `FontString`.

```lua
--- @type FontString
local myFontString = UIParent:CreateFontString(nil, "OVERLAY")
myFontString:SetFont(jetBrainsMono, 12, "")
```

### Iterating the Font Catalog

For ease of iteration, this addon provides `SharedMediaFontsMono:ForEachFont()`, a convenience method outside of LSM. It walks every [`SharedMediaFontsMono_Font`](https://github.com/kapresoft/wow-addon-SharedMediaFontsMono/blob/main/Libs/Annotations/SharedMediaFontsMono-Annotations.lua) in the catalog, so you can build UI around them without hardcoding names. The catalog covers all locales, so filter with `font:supports()`. Here's an example populating a Blizzard dropdown menu:

```lua
local dropdown = CreateFrame("Frame", "MyFontDropdown", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_SetWidth(dropdown, 180)

UIDropDownMenu_Initialize(dropdown, function(_, level)
  SharedMediaFontsMono:ForEachFont(function(font)
    if not font:supports(GetLocale()) then return end

    local info = UIDropDownMenu_CreateInfo()
    info.text = font.name
    info.func = function()
      UIDropDownMenu_SetText(dropdown, font.name)
      myFontString:SetFont(font.path, 12, "")
    end
    UIDropDownMenu_AddButton(info, level)
  end)
end)
```

### Default Font

A ready-to-use `Font` object (white text; JetBrains Mono on Latin and Russian clients, the matching Noto Sans Mono on Korean and Chinese clients) is registered globally as `SharedMediaFontsMono_DefaultFont` — handy for XML template inheritance or as a fallback in Lua.

```xml
<Font name="MyBaseFont" inherits="SharedMediaFontsMono_DefaultFont"/>
```

```lua
myFontString:SetFontObject(SharedMediaFontsMono_DefaultFont)
```

## EmmyLua Annotation (For Development)
- [SharedMediaFontsMono-Annotations.lua](https://github.com/kapresoft/wow-addon-SharedMediaFontsMono/blob/main/Libs/Annotations/SharedMediaFontsMono-Annotations.lua)

## Available Fonts

The same fonts are registered under two media types, with different names for each.

### General: `font` (`LSM.MediaType.FONT`)

The standard LSM media type, shared by every addon and font picker. Since this list mixes fonts from many sources, each name follows its font file, so the exact family and weight stay visible.

| LSM Name | File Name | Clients |
|---|---|---|
| JetBrainsMono Medium | JetBrainsMono-Medium.ttf | Western, Russian |
| UbuntuSansMono Medium | UbuntuSansMono-Medium.ttf | Western, Russian |
| IBMPlexMono Medium | IBMPlexMono-Medium.ttf | Western, Russian |
| SourceCodePro Medium | SourceCodePro-Medium.ttf | Western, Russian |
| RobotoMono Medium | RobotoMono-Medium.ttf | Western, Russian |
| Inconsolata SemiCondensed Medium | Inconsolata_SemiCondensed-Medium.ttf | Western |
| NotoSansMonoCJKsc Regular | NotoSansMonoCJKsc-Regular.otf | Western, Russian, Simplified Chinese |
| NotoSansMonoCJKkr Regular | NotoSansMonoCJKkr-Regular.otf | Korean |
| NotoSansMonoCJKtc Regular | NotoSansMonoCJKtc-Regular.otf | Traditional Chinese |

### Mono only: `font-mono` (`LSM.MediaType.FONT_MONO`)

This addon's own media type, tailored for mono-only retrieval. It holds nothing but these fonts, so each one uses a plain display name.

| Display Name | File Name | Clients |
|---|---|---|
| JetBrains Mono | JetBrainsMono-Medium.ttf | Western, Russian |
| Ubuntu Sans Mono | UbuntuSansMono-Medium.ttf | Western, Russian |
| IBM Plex Mono | IBMPlexMono-Medium.ttf | Western, Russian |
| Source Code Pro | SourceCodePro-Medium.ttf | Western, Russian |
| Roboto Mono | RobotoMono-Medium.ttf | Western, Russian |
| Inconsolata | Inconsolata_SemiCondensed-Medium.ttf | Western |
| Noto Sans Mono | NotoSansMonoCJKsc-Regular.otf | Western, Russian |
| Noto Sans Mono (Korean) | NotoSansMonoCJKkr-Regular.otf | Korean |
| Noto Sans Mono (Simplified Chinese) | NotoSansMonoCJKsc-Regular.otf | Simplified Chinese |
| Noto Sans Mono (Traditional Chinese) | NotoSansMonoCJKtc-Regular.otf | Traditional Chinese |

## Requirements
- [LibSharedMedia-3.0](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation) (embedded or provided by another addon)
- An addon with LibSharedMedia font support to select the fonts from

## Links
- [CurseForge Project Page](https://www.curseforge.com/wow/addons/sharedmediafontsmono)

## Font Sources
- Noto Sans Mono (CJK) — [notofonts/noto-cjk](https://github.com/notofonts/noto-cjk/tree/main/Sans/Mono) on GitHub
- All other fonts — [Google Fonts](https://fonts.google.com/)

## License
All Rights Reserved.

The bundled fonts are not covered by this; each ships under its own license in [Assets/Fonts/Licenses](https://github.com/kapresoft/wow-addon-SharedMediaFontsMono/tree/main/Assets/Fonts/Licenses).

## Donations

If this addon has made your addon gameplay or development easier, consider supporting its development:

- **[Paypal&trade; Donation](https://www.paypal.com/donate/?hosted_button_id=AX58YP3GSGXVU)**
- **[Bitcoin Donation](https://www.blockchain.com/btc/address/3QQVAwJGkKHMM2oq6CLVWYgfx83TFVwp39)**

## Author Notes

- About the Author [(Tony Lagnada)](https://tony.resume.lagnada.com/)
- My AddOn Portfolio Can Be Found Here [Curse Forge/Kapresoft](https://www.curseforge.com/members/kapresoft/projects)
