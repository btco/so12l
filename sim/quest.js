"use strict";

// Values for each loot category
const LOL_VALUES = {
  "LOL_A": 50,
  "LOL_B": 100,
  "LOL_C": 200,
  "LOL_D": 300,
  "LOL_E": 400,
}

class Quest {
  constructor(questId) {
    this.questId = questId;
    // Misnamed... this is not just battles, it's any quest event
    // like finding rations, etc.
    this.battles = [];  // each battle is an array of EIDs (strings)
                        // May contain special events that are not battles.
    this.xp = 0;
    this.gold = 0;
    this.hasReward = false;

    const reader = new AnnotReader();
    // Find all q_[questId] annotations and process them:
    while (reader.trySeek("@q_" + questId)) {
      // What is this line?
      const line = reader.getLine();
      if ((line.includes("UTIL_Battle") || line.includes("SYSC_BATTLE")) && 
          line.includes("EID_")) {
        // It's a battle.
        const eids = reader.getWords("EID_", 1);
        this.battles.push(eids);
      } else if (line.includes("LOOT_ChestRandom")) {
        // Loot: random items.
        const chestCount = reader.getValue("loot_count");
        const lootCategory = reader.getWord("LOL_");
        assert(chestCount > 0, "chestCount");
        assert(lootCategory, "lootCategory");
        this.battles.push({
          qevent: "LOOT",
          lootCategory: lootCategory,
          chestCount: chestCount
        });
      } else if (line.includes("GIVE_GOLD" || line.includes("UTIL_GoldChest"))) {
        const amt = reader.getAnyNumber();
        assert(amt > 0, "Failed to get GIVE_GOLD amount: " + line);
        this.gold += amt;
      } else if (line.includes("GIVE_XP")) {
        const amt = reader.getAnyNumber();
        assert(amt > 0, "Failed to get GIVE_XP amount: " + line);
        this.xp += amt;
      } else if (line.includes("LOOT_ChestItem") && line.includes("ITID_RATION")) {
        this.battles.push({ qevent: "RATION" });
      } else if ((line.includes("UTIL_ReadSpellbook") ||
          line.includes("SYSC_LEARN_SPELL")) && line.includes("ZID_")) {
        this.battles.push({ qevent: "SPELL", zid: reader.getWord("ZID_") });
      } else if (line.includes("SYSC_PAY")) {
        const price = +reader.getValue("price");
        assertNumber(price, "price must be number");
        assert(price > 0, "price must be > 0");
        this.battles.push({ qevent: "PAY", price: price });
      } else if (reader.tryGetValue("giveItem")) {
        const itid=reader.getValue("giveItem")
        const chi=+reader.getValue("chi")
        assertString(itid); assert(itid.startsWith("ITID_"));
        assertNumber(chi); assert(chi > 0 && chi <= 4);
        this.battles.push({ qevent: "ITEM", itid: itid, chi: chi });
      } else if (line.includes("CALL REW_GiveQuestReward") ||
          line.includes("SET TGV_WRLD_REW_QUEST_XP")) {
        const xpToGive = reader.getAnyNumber();
        assert(xpToGive > 0, "xpToGive must be > 0");
        this.xp += xpToGive;
        this.hasReward = true;
      } else {
        throw new Error("Failed to parse quest line: " + line);
      }
    }
  }

  do(party) {
    assert(party instanceof Party, "party must be instanceof Party");
    say("START QUEST: " + this.questId);

    const oldXp = party.xp;
    const oldGold = party.gold;

    party.restIfNeeded();
    // Run through each of the quests's battles, resting as needed.
    let i = 0;
    for (const battle of this.battles) {
      if (battle.qevent === "RATION") {
        party.rations++;
        say("+++ FOUND rations. Rations now " + party.rations);
      } else if (battle.qevent === "SPELL") {
        assert(battle.zid.startsWith("ZID_"));
        say("+++ FOUND spell: " + battle.zid);
        party.addSpell(battle.zid);
      } else if (battle.qevent === "PAY") {
        assert(battle.price);
        say("PAYMENT required " + battle.price);
        assert(party.gold >= battle.price,
           "Party has no money to pay for quest expense: " + battle.price);
        party.addGold(-battle.price, "quest expense", "E_QUEST");
      } else if (battle.qevent === "ITEM") {
        party.upgradeEquipped(battle.chi, battle.itid, "I_LOOT");
      } else if (battle.qevent === "LOOT") {
        const value = LOL_VALUES[battle.lootCategory];
        assert(value > 0, "unknown loot category: " + battle.lootCategory);
        const count = battle.chestCount;
        assert(count >= 0, "loot chest count must be >= 0: " + count);
        const amount = count * value;
        say("+++ FOUND random loot, " + count + " x " +
          battle.lootCategory + " (each " + value + ") = " +
          amount);
        party.addGold(amount, "random loot", "I_LOOT");
      } else {
        assert(Array.isArray(battle), "battle must be array here.");
        i++;
        say("START BATTLE " + this.questId + " BATTLE# " + i);
        Battle.doBattle(party, battle);
        party.restIfNeeded();
      }
    }
    say("QUEST SUCCESSFUL: " + this.questId + ":");
    party.addXp(this.xp);
    const totalXp = party.xp - oldXp;
    const totalGold = party.gold - oldGold;
    const implicitXp = totalXp - this.xp;
    const implicitGold = totalGold - this.gold;

    say("  Start XP:  " + oldXp);
    say("   + impl : +" + implicitXp);
    say("   + expl : +" + this.xp);
    say("   =      : =" + party.xp);

    say("  Start gp:  " + oldGold);
    say("   + impl : +" + implicitGold);
    say("   + expl : +" + this.gold);
    say("   =      : =" + party.gold);

    say("END QUEST: " + this.questId);

    if (this.hasReward) {
      // Figure out player's total net worth.
      const curNetWorth = party.calcNetWorth();
      // Target net worth.
      const targetNetWorth = party.getTargetNetWorth();
      const rewardGp = Math.max(500, targetNetWorth - curNetWorth);
      say("+++   Cur net worth   : " + curNetWorth);
      say("+++   Target net worth: " + targetNetWorth);
      say("+++   Reward total    : " + rewardGp);
      party.addGold(rewardGp, "quest reward", "I_REWARDS");
    }
  }
}


