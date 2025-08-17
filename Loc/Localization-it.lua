----------------------------------------------------------------------
--	Italian Localization

if GetLocale() ~= "itIT" then return end
local ADDON_NAME, private = ...

local L = private.L

L = L or {}
--@localization(locale="itIT", format="lua_additive_table", handle-subnamespaces="concat")@