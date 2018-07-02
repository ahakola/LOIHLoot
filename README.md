# WIP

# LOIHLoot

This addon only tries to give you guesstimate on what loot method benefits your raid the most. It doesn't take any unbalances in the composition or already loot saved players into account. With out the real drop chances from Blizzard I can't give you accurate answer what loot system is the best and even with correct numbers you'd still have to beat the RNGesus.

---

### Usage
#### Average raider: Filling your wishlist

Remember to fill your character's wishlist at Encounter Journal (Check the Loot-tab for wishlist-buttons). Wishlist-buttons:

* Green plus (Green for LUI): Item is on Wishlist from higher difficulty
* Red plus (Red for LUI): Item is on Wishlist from this difficulty
* Red minus (Blue for LUI): Item is on Wishlist from lower difficulty
* Gray minus (White for LUI): Item isn't on Wishlist

Even though at current version (1.3) you can see Wishlist-buttons on all EncounterJournal Loot-tabs, only WoD raids (Highmaul and Blackrock Foundry at the time of LOIHLoot 1.3) are supported by the Sync at the moment.

LOIHLoot should automaticly remove items from your wishlist when you receive them and any Essences on your wishlist should be removed when you have at least 5 Tier-items, -tokens or Essences.

**NB:** Sync sends the wishlist data of **items that are equal or lower to the current raid difficulty** (If you are in Heroic raid, your Normal and Heroic items from wishlist gets passed on, but your Mythic items doesn't), so **you should add items to you wishlist at the lowest difficulty level you mostly raid or the items benefit you** if you are raiding on multiple different difficulties at the same time.

#### Leaders: LOIHLoot window

Average raider doesn't have to pay any attention to the LOIHLoot window is (s)he so desires, the window is tool for mostly leaders and it is avalable to normal users to give the system some transparency. Normal users should only worry about filling their wishlists.

Use `/loihloot` or `/lloot` with the following commands:

* `show` - show LOIHLoot window
* `hide` - hide LOIHLoot window
* `reset` - reset current character's wishlist
* `status` - report the status of LOIHLoot
* `help` - show this help message ingame

Use the slash command without any additional commands to toggle the LOIHLoot window.

When in raid, the Sync-button becomes avalable for guild officers and the loot method buttons become available for raid leader. When pressing the Sync-button it disables the button for 15 seconds to prevent spam, but everyone in raid should get the same data from one button press to give system more transparency.

---

### Known issues:

* Wishlist-buttons show up on all Loot-tabs on EncounterJournal
* If you have your own class Essence (from Blackhand) on your wishlist and loot any non-your class tier items and/or Essences and hit that 5 Tiers mark, your own class Essence according to LOIHLoot 1.3 code logic will be removed from your wishlist.
* Horribad buttons with LUI. LUI replaces some of the WoW's default textures (you shouldn't do that!) and some of them happen to be same as what LOIHLoot uses.

---

### Ran into problem or want to help?

Please drop in your:

* bug reports at https://wow.curseforge.com/projects/loihloot/issues/
* translations at https://wow.curseforge.com/projects/loihloot/localization/
* ideas at my inbox either at Curse.com or Curseforge.com or at the comment section

Your Curse-account can be used to login at Curseforge.

---

### Personal loot vs Group Loot
##### Following text is/has been correct for 6.0-6.1:
Personal loot gives as much loot as Group loot in the long run (calculated using Binomial probability, assuming same drop chance for all loot methods until confirmed otherwise by Blizzard). Napkin math supports the theory of, unless you are min-maxing your raids progress and loot distribution (usually dps &gt; tanks &gt; healers) or riging the raid composition in favor of you getting the loot you want (30 person pug raid, and you are the only hunter in the raid and hoping for weapon to drop), Personal loot is better loot method at the start of the new raid tier or difficulty when everyone need loot from (almost) all of the bosses.

This should be accurate while half or more of players in the raid need loot from the boss and even beyond that point if the raid composition is heavily unbalanced and stacked players who want same item(s). Unless you are in real cutting edge raiding guild doing multiple mixed runs before Mythic raids open, you should at least consider running few first weeks with Personal loot to maximize the loot potential of your group.

N.B.: You running the raids for few weeks doesn't give you enough data to do any real statistics with few dozen boss kills compared to hundreds of thousands to millions of boss kills Blizzard records per week.

##### For 6.2 Personal loot **WILL** yield more loot than Group loot:

> First, rather than treating loot chances independently for each player -- sometimes yielding only one or even zero items for a group -- we'll use a system similar to Group Loot to determine how many items a boss will award based on eligible group size. As a result, groups will receive a much more predictable number of drops when they defeat a boss. In addition, set items will reliably drop in Personal Loot, just like they do in Group Loot today. The end result is that groups using Personal Loot will acquire their 2- and 4-piece set bonuses at around the same time as groups using Group Loot acquire theirs.
> We're also increasing the overall rate of reward for Personal Loot, giving players more items overall to offset the fact that Personal Loot rewards can't be distributed among group members. We know that finding that one awesome specific trinket to round out your gear set can be difficult with Personal Loot, and this should help increase your odds.
> Quote from Dev Watercooler -- Itemization in 6.2 - http://eu.battle.net/wow/en/blog/19162236?page=1#1

> - More items will drop on average for a raid using 6.2 Personal Loot than would have dropped using 6.0/6.1 Personal Loot.
> - More items will drop on average for a raid using 6.2 Personal Loot than would drop for that raid using any form of Group Loot (Master, Need/Greed, etc.).
> Quote from Game Designer Watcher @ WoW Forums - http://us.battle.net/wow/en/forum/topic/17346368401?page=1#20

You should use Personal loot always unless you are min-maxing progress and loot distribution, funneling loot to someone or your raid is almost fully geared.

#### Translations

Language | Translator
-------- | ----------
German (deDE) | pas06

**Please disable TradeSkillMaster before copy&amp;pasting Lua errors to me, it makes the Lua error -reports almost impossible to read.**