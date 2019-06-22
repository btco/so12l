"use strict";

class Party {
  constructor() {
    this.chars = [];
    this.level = 1;
    this.gold = 0;
    this.xp = 0;
    this.rations = 1;
    this.healingPotions = 1;
    this.accounting = new Accounting();
    this.load(); 
  }

  load() {
    say("Loading party.");
    const reader = new AnnotReader();
    const num = reader.seek("@party").seek("@nchars").getNumber();
    say("Num chars in party: " + num);
    assert(num >= 1 && num <= 4);
    for (let i = 1; i <= num; i++) {
      say("Loading char " + i);
      let ch = new Character();
      ch.loadFrom(reader.seek("@char"  + i));
      this.chars.push(ch);
      this.accounting.reg("A_ITEMS", "I_START_ITEMS",
          ch.calcNetWorth());
    }
    this.gold = reader.seek("@gold").getNumber();
    this.accounting.reg("A_CASH", "I_START_CASH", this.gold);
    this.xp = reader.seek("@xp").getNumber();
    this.level = 1;
  }

  addChar(annot) {
    say("+++ Adding party character " + annot);
    const reader = new AnnotReader();
    let ch = new Character();
    ch.loadFrom(reader.seek(annot));

    // Level up the character to match the party.
    let level = 1;
    while (level < this.level) {
      ch.levelUp(level + 1);
      level++;
    }

    this.accounting.reg("A_ITEMS", "I_START_ITEMS", ch.calcNetWorth());

    // Char starts with max hp/sp
    ch.hp = ch.maxHp;
    ch.sp = ch.maxSp;

    this.chars.push(ch);
    say("Party is now:");
    this.printSummary();
  }

  addXp(amount, why = "") {
    const oldXp = this.xp;
    this.xp += assertNumber(amount);
    say("+++ XP gained: " + amount + " (" + why + ")");
    say("    XP: " + oldXp + " -> " + this.xp);
    // TODO: show progression
  }

  addGold(amount, why, debitAccount) {
    assertNumber(amount, "addGold needs number: " + amount);
    assert(why, "why param missing.");
    assert(debitAccount, "debitAccount param missing.");
    const oldGold = this.gold;
    this.gold += amount;
    say((amount >= 0 ?
      ("+++ Gold gained: " + amount) : ("--- Gold lost: " + amount)) +
      " " + (why ? "(" + why + ")" : ""));
    say("  Gold: " + oldGold + " -> " + this.gold);
    this.accounting.reg("A_CASH", debitAccount, amount);
  }

  upgradeEquipped(chi, newItid, debitAccount) {
    const itk = ItemDb.instance().getItem(newItid).kind;
    assertString(itk); assert(itk.startsWith("ITK_"));
    const ch = this.chars[chi - 1];
    assert(ch instanceof Character);
    const currentVal = ch.eq[itk] ?
      ItemDb.instance().getItem(ch.eq[itk]).value : 0;
    const newVal = ItemDb.instance().getItem(newItid).value;
    say("+++ UPGRADE: " + ch.name + " exchanging " +
       (ch.eq[itk] || "(nothing)") + " (value " + currentVal + ")" +
       " for " + newItid + " (value " + newVal + ").");
    ch.eq[itk] = newItid;
    this.accounting.reg("A_ITEMS", debitAccount, newVal - currentVal);
  }

  restIfNeeded() {
    // Rest is needed if any character is below 75% hitpoints.
    const needRest = this.chars.filter(ch => ch.hp < 0.75 * ch.maxHp);
    if (needRest.length < 1) {
      say("No rest needed.");
      return;
    }
    say("Rest needed: " + needRest.map(ch => ch.name).join(", "));
    // Need rest.
    if (this.rations < 1) {
      say("!!! NOT ENOUGH FOOD. Need rest, but not enough rations.");
      return;
    }
    this.rations--;
    say("RESTED. Food rations now " + this.rations);
    this.recoverFull();
  }

  recoverFull() {
    for (const ch of this.chars) {
      ch.hp = ch.maxHp;
      ch.sp = ch.maxSp;
    }
  }

  isEligible() {
    return this.level < XpTab.instance().getLevelForXp(this.xp);
  }

  levelUp() {
    assert(this.isEligible(), "Can't level up without being eligible.");
    say("+++ LEVEL UP " + this.level + " -> " + (this.level + 1));
    this.level++;
    for (const ch of this.chars) ch.levelUp(this.level);
    this.printSummary();
  }

  addSpell(zid) {
    const spell = SpellDb.instance().getSpell(zid);
    for (const ch of this.chars) {
      if (ch.klass === spell.klass) {
        ch.addSpell(zid);
        return;
      }
    }
    throw new Error("Nobody could learn spell " + zid + " (" + spell.klass + ")");
  }

  calcNetWorth() {
    let worth = this.gold;
    for (const ch of this.chars) {
      worth += ch.calcNetWorth();
    }
    return worth;
  }

  getTargetNetWorth() {
    return Math.floor(this.xp / 2);
  }

  printSummary() {
    say("PARTY");
    say("  LVL : " + this.level);
    let eligibleString = "";
    if (this.isEligible()) {
      eligibleString = "*** ELIGIBLE, level  " +
          XpTab.instance().getLevelForXp(this.xp);
    }
    say("  XP       : " + this.xp + " / " + 
        XpTab.instance().getXpForLevel(this.level + 1) + "  " +
        eligibleString);
    say("  Gold     : " + this.gold);
    say("  Net worth: " + this.calcNetWorth());
    for (const ch of this.chars) {
      ch.printSummary();
    }
    this.accounting.printSummary();
  }
}

class Character {
  constructor() {
    this.name = "";
    this.klass = "CLS_FIGHTER";
    this.att = 0;
    this.def = 0;
    this.speed = 0;
    this.hp = 0;
    this.maxHp = 0;
    this.sp = 0;
    this.maxSp = 0;
    this.spells = [];
    this.eq = [];
  }

  loadFrom(reader) {
    this.name = reader.seek("@name").getString();
    this.klass = reader.seek("@class").getWord("CLS_");
    this.att = reader.seek("@att").getNumber();
    this.def = reader.seek("@def").getNumber();
    this.speed = reader.seek("@speed").getNumber();
    this.hp = reader.seek("@hp").getNumber();
    this.maxHp = reader.seek("@maxHp").getNumber();
    this.sp = reader.seek("@sp").getNumber();
    this.maxSp = reader.seek("@maxSp").getNumber();
    this.eq = {};
    for (let itk of ITK_ALL) {
      this.eq[itk] = reader.seek("@eq_" + itk).tryGetWord("ITID_", "") || "";
    }
    // For formatting purposes, pad name to 4 chars.
    while (this.name.length < 4) this.name += " ";
  }

  addSpell(zid) {
    assert(zid.startsWith("ZID_"), "ZID must start with ZID_ " + zid);
    if (!this.spells.includes(zid)) {
      this.spells.push(zid);
      say("+++ NEW SPELL: " + this.name + " learned " + zid);
    }
  }

  hasSpell(zid) {
    assert(zid.startsWith("ZID_"), "ZID must start with ZID_ " + zid);
    return this.spells.includes(zid);
  }

  applyNetDamage(dmg) {
    this.hp = Math.max(0, this.hp - assertNumber(dmg));
  }

  isDead() {
    return this.hp < 1;
  }

  getAtt() {
    let att = this.att;
    let weapItk = this.klass === "CLS_ARCHER" ? ITK_RWEAP : ITK_MWEAP;
    for (const itk of [weapItk]) {
      const itid = this.eq[itk];
      if (itid) att += ItemDb.instance().getItem(itid).attdef;
    }
    return att;
  }

  getDef() {
    let def = this.def;
    for (const itk of [ITK_ARMOR, ITK_HELM, ITK_SHIELD, ITK_BOOT, ITK_BELT]) {
      const itid = this.eq[itk];
      if (itid) def += ItemDb.instance().getItem(itid).attdef;
    }
    return def;
  }

  getHp() {
    return this.hp;
  }

  getSpeed() {
    return this.speed;
  }

  getName() {
    return this.name;
  }

  getBattleSummary() {
    return this.name + ":" + makeBar(this.hp, this.maxHp);
  }

  cast(zid) {
    assert(this.hasSpell(zid), this.name + " does not have spell " + zid);
    const cost = SpellDb.instance().getSpell(zid).cost;
    assert(cost > 0);
    if (this.sp < cost) {
      say("!!! NOT ENOUGH SP, " + this.name + " could not cast " + zid);
      return false;
    } else {
      this.sp -= cost;
      say("SPELL: " + this.name + " has cast " + zid + ", SP left: " + this.sp);
      return true;
    }
  }

  printSummary() {
    say("  CHAR: " + this.name + " " + this.klass);
    say("    Att: " + this.att + ", effective " + this.getAtt());
    say("    Def: " + this.def + ", effective " + this.getDef());
    say("    Spd: " + this.speed);
    say("    HP : " + this.hp + " / " + this.maxHp);
    say("    SP : " + this.sp + " / " + this.maxSp);
    say("    Eq :");
    for (const itk of ITK_ALL) {
      say("      " + itk + ": " + this.eq[itk]);
    }
    say("    Zs : " + this.spells.join(" "));
  }

  levelUp(toLevel) {
    this.att += assertNumber(ATT_IMPROV[this.klass]);
    this.def += assertNumber(DEF_IMPROV[this.klass]);
    this.maxHp += assertNumber(HP_IMPROV[this.klass]) + 1;
    this.maxSp += assertNumber(SP_IMPROV[this.klass]) + 1;
    this.speed += assertNumber(SPEED_IMPROV[this.klass]) + (toLevel % 2);
  }

  canUse(itid) {
    return this.canUseIt(assert(ItemDb.instance().getItem(itid)));
  }

  canUseIt(item) {
    assert(item instanceof Item, "item must be instance of Item");
    assertString(item.itac, "Item's ITAC must be string " + item.itid);
    const allowedClasses = ITAC_CLASSES[item.itac];
    assert(allowedClasses, "Invalid ITAC " + item.itac + " on " + item.itid);
    return allowedClasses.includes(this.klass);
  }

  calcNetWorth() {
    let worth = 0;
    for (let itk of ITK_ALL) {
      if (this.eq[itk]) {
        const v = ItemDb.instance().getItem(this.eq[itk]).value;
        assertNumber(v);
        worth += v;
      }
    }
    return worth;
  }

}

const ITAC_CLASSES = {
  "ITAC_FIGHTER": [ "CLS_FIGHTER" ],
  "ITAC_PALADIN": [ "CLS_PALADIN" ],
  "ITAC_ARCHER": [ "CLS_ARCHER" ],
  "ITAC_WIZARD": [ "CLS_WIZARD" ],
  "ITAC_FP": [ "CLS_FIGHTER", "CLS_PALADIN" ],
  "ITAC_FPA": [ "CLS_FIGHTER", "CLS_PALADIN", "CLS_ARCHER" ],
  "ITAC_PW": [ "CLS_PALADIN", "CLS_WIZARD" ],
  "ITAC_ALL": [ "CLS_FIGHTER", "CLS_PALADIN", "CLS_ARCHER", "CLS_WIZARD" ]
};

const ATT_IMPROV = {
  "CLS_FIGHTER": 5,
  "CLS_PALADIN": 5,
  "CLS_ARCHER": 5,
  "CLS_WIZARD": 1,
};

const DEF_IMPROV = {
  "CLS_FIGHTER": 2,
  "CLS_PALADIN": 2,
  "CLS_ARCHER": 1,
  "CLS_WIZARD": 1,
};

const HP_IMPROV = {
  "CLS_FIGHTER": 15,
  "CLS_PALADIN": 14,
  "CLS_ARCHER": 12,
  "CLS_WIZARD": 8,
};

const SPEED_IMPROV = {
  "CLS_FIGHTER": 4,
  "CLS_PALADIN": 5,
  "CLS_ARCHER": 6,
  "CLS_WIZARD": 3,
};

const SP_IMPROV = {
  "CLS_FIGHTER": 0,
  "CLS_PALADIN": 5,
  "CLS_ARCHER": 0,
  "CLS_WIZARD": 8,
};

