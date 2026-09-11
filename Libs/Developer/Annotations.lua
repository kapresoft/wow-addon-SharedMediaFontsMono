--- Global set by the SharedMediaFontsMono addon; add it as a Dependency/OptionalDep
--- in your .toc, then access it directly as `SharedMediaFontsMono` (no LibStub).
--- @class SharedMediaFontsMono
local o = {}

--- @class SharedMediaFontsMono_Font
--- @field name string
--- @field path string
--- @field localeBit number?
--- @field supports fun(self:SharedMediaFontsMono_Font, locale:string):boolean  @ Ex: font:supports(GetLocale())

--- @class SharedMediaFontsMono_Catalog: SharedMediaFontsMono_Font[]

--- ```
--- ### Usage:
--- local catalog = SharedMediaFontsMono:GetCatalog()
--- local sortedCatalog = SharedMediaFontsMono:GetCatalog(true)
--- ```
--- @param sorted? boolean @Case insensitive sort of SharedMediaFontsMono_Font#name field [Optional]
--- @return SharedMediaFontsMono_Catalog
function o:GetCatalog(sorted) return {} end

--- @alias SharedMediaFontsMono_Callback fun(font: SharedMediaFontsMono_Font)

--- ```
--- ### Usage:
--- SharedMediaFontsMono:ForEachFont(function(font) end)
--- SharedMediaFontsMono:ForEachFont(function(font) end, true)
--- SharedMediaFontsMono:ForEachFont(function(font) end, false)
--- ```
--- @param callback SharedMediaFontsMono_Callback
--- @param sorted boolean? @sorted is true by default
--- @overload fun(callback: SharedMediaFontsMono_Callback)
function o:ForEachFont(callback, sorted) end

