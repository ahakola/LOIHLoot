----------------------------------------------------------------------
--	English Localization

local ADDON_NAME, private = ...

local L = {}
private.L = L

L.TOOLTIP_WISHLIST_ADD = "Add to wishlist."
L.TOOLTIP_WISHLIST_HIGHER = "Downgrade to this difficulty.\nAlready on wishlist from higher difficulty."
L.TOOLTIP_WISHLIST_LOWER = "Upgrade to this difficulty.\nAlready on wishlist from lower difficulty."
L.TOOLTIP_WISHLIST_REM = "Remove from wishlist."
L.MAINTOOLTIP = "Mainspec items"
L.OFFTOOLTIP = "Offspec items"
L.VANITYTOOLTIP = "Vanity items"

L.PRT_DEBUG_FALSE = "%s debugging is OFF." -- ADDON_NAME
L.PRT_DEBUG_TRUE = "%s debugging is ON." -- ADDON_NAME
L.PRT_RESET_DONE = "Character wishlist reseted."
L.PRT_STATUS = "%s is using %.0fkB of memory." -- ADDON_NAME, GetAddOnMemoryUsage
L.PRT_UNKOWN_DIFFICULTY = "ERROR - Unknown raid difficulty! Not sending SyncRequest"

L.BUTTON_SYNC = "Sync"
L.SENDING_SYNC = "Sending sync request...\nDisabling Sync-button for 15 seconds."
L.SYNC_LINE = "Last sync (%s): %s (%d/%d in raid replied)" -- difficultyName, _lastSync, _syncReplies, _raidCount
L.TAB_WISHLIST = "Wishlist"
L.UNKNOWN = "Unknown"

L.SYNCSTATUS_OK = "Sync OK"
L.SYNCSTATUS_MISSING = "NO Sync!"
L.SYNCSTATUS_INCOMPLETE = "Roster changed since last sync!"

L.LONG_MAINSPEC = "Mainspec"
L.LONG_OFFSPEC = "Offspec"
L.LONG_VANITY = "Vanity"
L.SHORT_MAINSPEC = "M"
L.SHORT_OFFSPEC = "O"
L.SHORT_VANITY = "V"

-- private.SLASH_COMMAND
L.CMD_LIST = "/loihloot ( %s | %s | %s | %s | %s )"
L.CMD_SHOW = "show"
L.CMD_HIDE = "hide"
L.CMD_RESET = "reset"
L.CMD_STATUS = "status"
L.CMD_HELP = "help"
L.CMD_DEBUGON = "debugon"
L.CMD_DEBUGOFF = "debugoff"
L.CMD_DUMP = "bossdump"

L.HELP_TEXT = {
	"Use /loihloot or /lloot with the following commands:",
	"   " .. L.CMD_SHOW    .. " - show LOIHLoot window",
	"   " .. L.CMD_HIDE    .. " - hide LOIHLoot window",
	"   " .. L.CMD_RESET    .. " - reset current character's wishlist",
	"   " .. L.CMD_STATUS  .. " - report the status of LOIHLoot",
	"   " .. L.CMD_HELP .. " - show this help message",
	"Use the slash command without any additional commands to toggle the LOIHLoot window.",
}
L.REMINDER = "Remember to fill your character's wishlist at Encounter Journal (Check the Loot-tab for wishlist-buttons)."
