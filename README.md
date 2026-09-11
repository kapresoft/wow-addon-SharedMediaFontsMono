# SharedMedia Fonts Mono (Includes CJK)

A World of Warcraft addon that registers a curated collection of open-source monospace fonts with LibSharedMedia-3.0 (LSM). Once installed, any addon that supports custom fonts through LSM (chat frames, unit frames, nameplates, action bars, etc.) can use these fonts directly from its font picker.

<img width="200" alt="SharedMedia-Fonts-Mono-Logo" src="https://github.com/user-attachments/assets/31d4b829-72c2-4320-bc86-9ad25a23db14" />

Includes full Latin and Cyrillic (Russian) coverage, plus Noto Sans Mono fonts for Korean, Simplified Chinese, and Traditional Chinese clients.

## Typical Use Cases
- Viewing Lua code (in-game editors, error viewers, debug consoles)
- Consoles/chat frames where fixed-width output is required
- Aligning tabular data (damage meters, DPS/HPS logs, stat comparisons)
- Distinguishing similar characters (0/O, 1/l/I) in IDs, item links, or macros

## Usage

Two ways to consume registered fonts: fetch one directly by name, or iterate the full catalog to build your own font picker.

### Basic

Fetch a registered font by name and apply it to a `FontString`.

```lua
--- @type LibSharedMedia-3.0
local LSM = LibStub("LibSharedMedia-3.0")

--- @type string
local jetBrainsMono = LSM:Fetch(LSM.MediaType.FONT, "JetBrains Mono")
--- @type string
local ubuntuMono = LSM:Fetch(LSM.MediaType.FONT, "Ubuntu Mono")

--- @type FontString
local myFontString = UIParent:CreateFontString(nil, "OVERLAY")
myFontString:SetFont(jetBrainsMono, 12, "")

--- @type FontString
local myOtherFontString = UIParent:CreateFontString(nil, "OVERLAY")
myOtherFontString:SetFont(ubuntuMono, 14, "")
```

### Iterating the Font Catalog

An easier way to pull fonts is via `ForEachFont()`, which iterates every registered `SharedMediaFontsMono_Font` entry so you can build UI around them without hardcoding names. Here's an example populating a Blizzard dropdown menu:

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

## EmmyLua Annotation (For Development)
- [Annotations.lua](https://github.com/kapresoft/wow-addon-SharedMediaFontsMono/blob/main/Libs/Developer/Annotations.lua)

## Available Fonts
| Name | File Name | Size |
|---|---|---|
| JetBrains Mono | JetBrainsMono-Regular.ttf | 112 KB |
| PT Mono | PTMono-Regular.ttf | 165 KB |
| Ubuntu Mono | UbuntuMono-Regular.ttf | 185 KB |
| Noto Sans Mono (Korean) | NotoSansMonoCJKkr-Regular.otf | 15.6 MB |
| Noto Sans Mono (Traditional Chinese) | NotoSansMonoCJKtc-Regular.otf | 15.6 MB |
| Noto Sans Mono (Simplified Chinese) | NotoSansMonoCJKsc-Regular.otf | 15.6 MB |

## Requirements
- [LibSharedMedia-3.0]([https://www.wowace.com/projects/libsharedmedia-3-0](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation)) (embedded or provided by another addon)
- An addon with LibSharedMedia font support to select the fonts from

All fonts are distributed under their respective open-source licenses.

## Links
- [CurseForge Project Page](https://www.curseforge.com/wow/addons/sharedmediafontsmono)

## Font Sources
- Noto Sans Mono (CJK) — [notofonts/noto-cjk](https://github.com/notofonts/noto-cjk/tree/main/Sans/Mono) on GitHub
- All other fonts — [Google Fonts](https://fonts.google.com/)

## License
All Rights Reserved.

## Donations

If this addon has made your addon gameplay or development easier, consider supporting its development:

- **[Paypal&trade; Donation](https://www.paypal.com/donate/?hosted_button_id=AX58YP3GSGXVU)**
- **[Bitcoin Donation](https://www.blockchain.com/btc/address/3QQVAwJGkKHMM2oq6CLVWYgfx83TFVwp39)**

## Author Notes

- About the Author [(Tony Lagnada)](https://tony.resume.lagnada.com/)
- My AddOn Portfolio Can Be Found Here [Curse Forge/Kapresoft](https://www.curseforge.com/members/kapresoft/projects)
