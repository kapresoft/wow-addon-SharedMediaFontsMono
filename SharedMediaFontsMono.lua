
local addon, xns = ...

--- @type LibSharedMedia-3.0
local LSM = LibStub("LibSharedMedia-3.0")
local FONT = LSM.MediaType.FONT

local path = "Interface\\AddOns\\" .. addon .. "\\Assets\\Fonts\\"

LSM:Register(FONT, "JetBrains Mono", path .. "JetBrainsMono-Regular.ttf")
LSM:Register(FONT, "PT Mono", path .. "PTMono-Regular.ttf")
LSM:Register(FONT, "Ubuntu Mono", path .. "UbuntuMono-Regular.ttf")
LSM:Register(FONT, "Noto Sans Mono (Korean)", path .. "NotoSansMonoCJKkr-Regular.otf", LSM.LOCALE_BIT_koKR)
LSM:Register(FONT, "Noto Sans Mono (Simplified Chinese)", path .. "NotoSansMonoCJKsc-Regular.otf", LSM.LOCALE_BIT_zhCN)
LSM:Register(FONT, "Noto Sans Mono (Traditional Chinese)", path .. "NotoSansMonoCJKtc-Regular.otf", LSM.LOCALE_BIT_zhTW)