----------------------------------------------------------------------
--	Portuguese Localization

if GetLocale() ~= "ptBR" then return end
local ADDON_NAME, private = ...

local L = private.L

L = L or {}
--@localization(locale="ptBR", format="lua_additive_table", handle-subnamespaces="concat")@