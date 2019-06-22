"use strict";

class Battle {
  // party: Party
  // ents: Ent[]
  constructor(party, ents) {
    this.party = party;
    this.ents = ents;
    // If true, ZID_PROTECT was cast.
    this.protectSpell = false;

    // Token of the character that was the last attack target.
    this.lastTargetedCharToken = null;

    assert(this.party instanceof Party);
    assert(Array.isArray(this.ents));
    assert(this.ents[0] instanceof Ent);

    // Current turn owner (index into this.turnOrder).
    // Start at -1 because we will advance it to 0 next.
    this.turnIndex = -1;

    // Token that owns the turn.
    this.turnTok = null;

    // Tokens (each is a char or enemy), which we will later
    // sort in order of speed.
    this.tokens = [];
    for (let i = 0; i < party.chars.length; i++) {
      this.tokens.push(new BattleToken(party.chars[i]));
    }
    for (const ent of ents) this.tokens.push(new BattleToken(ent));

    // Sort them in order of speed, descending.
    this.tokens.sort((a,b) => b.charOrEnt.getSpeed() - a.charOrEnt.getSpeed());

    // Advance to first turn.
    this.advanceTurn();
  }

  do() {
    let result;
    let iters = 0;
    while ((result = this.getBattleResult()) === 0) {
      this.playTurn();
      this.advanceTurn();
      this.printSummary();
      ++iters;
      assert(iters < 100, "Battle has too many iterations.");
    }
    if (result > 0) {
      say("Player won.");
    } else {
      throw new Error("****** GAME OVER.");
    }

    this.giveRewards();
  }

  static doBattle(party, ents) {
    assert(Array.isArray(ents), "ents must be array.");
    // Accept array of string for ents, auto create ents.
    let num = 0;
    if (typeof(ents[0]) === 'string') {
      ents = ents.map(x => new Ent(x, x + "#" + (++num)));
    }
    return (new Battle(party, ents)).do();
  }

  giveRewards() {
    let totalXp = 0, totalGold = 0;
    for (const ent of this.ents) {
      totalXp += ent.xp;
      totalGold += ent.gold;
    }

    this.party.addXp(totalXp, "battle");

    // Adjust gold.
    // Figure out player's total net worth.
    const curNetWorth = this.party.calcNetWorth();
    // Target net worth.
    const targetNetWorth = this.party.getTargetNetWorth();
    // Adjust total gold to be the amount to bring player
    // to the target net worth, capped to 0.5-2.0x the initial
    // amount.
    const adjustedGold = Math.min(Math.max(targetNetWorth - curNetWorth,
      5), totalGold*2);

    say("GOLD reward GROSS " + totalGold + ", ADJUSTED " + adjustedGold);
    this.party.addGold(adjustedGold, "battle", "I_LOOT");
  }

  advanceTurn() {
    this.turnIndex = (this.turnIndex + 1) % this.tokens.length;
    this.turnTok = assert(this.tokens[this.turnIndex]);
  }

  playTurn() {
    if (this.turnTok.isChar) {
      this.playCharTurn();
    } else {
      this.playEntTurn();
    }
    this.removeDead();
  }

  playCharTurn() {
    assert(this.turnTok.isChar);
    const ch = this.turnTok.charOrEnt;
    if (this.tryHealingPotion(ch)) return;
    if (this.tryHealSomeone(ch)) return;
    if (this.tryCastProtect(ch)) return;
    if (this.tryCastTempest(ch)) return;
    if (this.tryCastLightning(ch)) return;
    if (this.tryCastForceBead(ch)) return;

    // Stupid strategy: just attack the first enemy on the list.
    this.doAttack(this.getFirstEnemyToken());
  }

  getFirstEnemyToken() {
    for (const tok of this.tokens) {
      if (tok.isEnt && !tok.charOrEnt.isDead()) {
        return tok;
      }
    }
    throw new Error("No enemy token found.");
  }

  getAllEnemyTokens() {
    return this.getFirstNEnemyTokens(999);
  }

  getFirstNEnemyTokens(n) {
    const result = [];
    for (const tok of this.tokens) {
      if (tok.isEnt && !tok.charOrEnt.isDead()) {
        result.push(tok);
        if (result.length >= n) break;
      }
    }
    return result;
  }

  tryHealingPotion(ch) {
    if (ch.hp < ch.maxHp/3 && this.party.healingPotions > 0) {
      this.party.healingPotions--;
      say(ch.name + " uses a healing potion. Potions left: " + this.party.healingPotions);
      ch.hp += 10;
      return true;
    }
    return false;
  }

  tryHealSomeone(ch) {
    if (!ch.hasSpell("ZID_HEAL")) return false;
    let healTarget;
    for (const other of this.party.chars) {
      if (other.hp > 0 && other.hp <= other.maxHp/4) {
        healTarget = other;
        break;
      }
    }
    // Nobody to heal.
    if (!healTarget) return false;
    // Try to cast.
    if (!ch.cast("ZID_HEAL")) return false;
    const oldHp = healTarget.hp;
    healTarget.hp = Math.min(healTarget.maxHp,
      healTarget.hp + Math.min(20, 3 + 2 * this.party.level));
    say("SPELL: " + ch.name + " heals " + healTarget.name + " " +
        oldHp + "hp ---> " + healTarget.hp + "hp");
    return true;
  }

  tryCastProtect(ch) {
    if (this.protectSpell) return false;  // already cast.
    if (!ch.hasSpell("ZID_PROTECT")) return false;
    if (!ch.cast("ZID_PROTECT")) return false;
    say("SPELL: PROTECT SPELL CAST !!!");
    this.protectSpell = true;
    return true;
  }

  tryCastForceBead(ch) {
    if (!ch.hasSpell("ZID_FORCE_BEAD")) return false;
    if (!ch.cast("ZID_FORCE_BEAD")) return false;
    say("SPELL: " + ch.name + " casts ZID_FORCE_BEAD");
    // Real damage is 2-6 but ZID_BURN is 6-8, and we're
    // simulating an average, so let's say the damage is 5.
    const enemyTok = this.getFirstEnemyToken();
    // Apply net damage.
    enemyTok.charOrEnt.applyNetDamage(5);
    return true;
  }

  tryCastTempest(ch) {
    if (!ch.hasSpell("ZID_TEMPEST")) return false;

    // Is it worth casting?
    const enemies = this.getFirstNEnemyTokens(2);
    if (enemies.length < 2) return false;

    if (!ch.cast("ZID_TEMPEST")) return false;

    say("SPELL: " + ch.name + " casts ZID_TEMPEST");
    for (const enemy of enemies) {
      enemy.charOrEnt.applyNetDamage(12);
    }
    return true;
  }

  tryCastLightning(ch) {
    if (!ch.hasSpell("ZID_LIGHTNING")) return false;
    // Select target (enemy with most hit points).
    let target = null;
    for (const ent of this.ents) {
      if (ent.hp <= 0) continue;  // dead
      if (!target || ent.hp > target.hp) {
        target = ent;
      }
    }
    if (!target || target.hp < 25) return false;  // not worth it.
    if (!ch.cast("ZID_LIGHTNING")) return false;
    say("SPELL: " + ch.name + " casts ZID_LIGHTNING.");
    target.applyNetDamage(25);
    return true;
  }

  playEntTurn() {
    const ent = this.turnTok.charOrEnt;
    assert(ent instanceof Ent);
    for (let i = 0; i < ent.numAttacks; i++) {
      // Attack a random player.
      assert(ent.attType.startsWith("BAT_AK_"), "Invalid ent attack type: " + ent.attType);
      // Try to select a target that's appropriate for the attack type
      // (if ranged, pick anyone; if melee only pick fighter/paladin).
      // But if there is no choice, pick anyone.
      let targetTok;
      const preferredClasses = ent.attType === "BAT_AK_MELEE" ?
          [ "CLS_FIGHTER", "CLS_PALADIN" ] : null;
      targetTok = this.chooseBalancedAliveCharTok(preferredClasses);
      assert(targetTok, "Could not find attack target. Should not happen.");
      this.doAttack(targetTok);
    }
  }

  chooseBalancedAliveCharTok(klasses) {
    // If no target found with class restriction, relax class restriction:
    let target = this.chooseRandomAliveCharTok(klasses) ||
        this.chooseRandomAliveCharTok();
    assert(target, "No character to target??");
    // If we chose the same one as last time, try to choose again
    // to reduce the probability of repeated attacks on the same
    // character.
    if (target === this.lastTargetedCharToken) {
      target = this.chooseRandomAliveCharTok(klasses) ||
          this.chooseRandomAliveCharTok();
      assert(target, "No character to target?? (2)");
    }
    this.lastTargetedCharToken = target;
    return target;
  }

  // klasses is an array of classes to look for. If omitted,
  // will choose from any class.
  chooseRandomAliveCharTok(klasses) {
    // Start at a random token index and walk forward (with
    // wraparound) until we find a character.
    const baseIndex = randomBetween(0, this.tokens.length - 1);
    for (let i = 0; i < this.tokens.length; i++) {
      const thisIndex = (baseIndex + i) % this.tokens.length;
      const thisTok = this.tokens[thisIndex];
      if (!thisTok.isChar) continue;
      const klass = assert(thisTok.charOrEnt.klass);
      // Apply filter by class.
      if (!klasses || klasses.includes(klass)) return thisTok;
    }
    return null;
  }

  removeDead() {
    for (let i = this.tokens.length - 1; i >= 0; i--) {
      const tok = this.tokens[i];
      if (tok.charOrEnt.isDead()) {
        say(tok.charOrEnt.getName() + " died.");
        // Delete entry.
        this.tokens.splice(i, 1);
        // If removal position is before turn owner,
        // the turn owner index must be shifted to the left.
        if (i < this.turnIndex) {
          this.turnIndex--;
        }
      }
    }
  }

  doAttack(targetTok) {
    const att = this.turnTok.charOrEnt.getAtt();
    let def = targetTok.charOrEnt.getDef();
    if (targetTok.isChar && this.protectSpell) {
      say("      ...ZID_PROTECT grants def+5");
      def += 5;
    }

    // Max damage is attack - defense.
    const rawDmg = Math.max(1, att - def);
    // Compute net damage.
    const netDmg = this.dmgRand(rawDmg);
    targetTok.charOrEnt.applyNetDamage(netDmg);

    const suff = (targetTok.isChar ? "TOOK " : "DEALT ") + netDmg;

    say(this.turnTok.charOrEnt.getName() + " attacks " +
        targetTok.charOrEnt.getName() + ". Max " + rawDmg +
        ", net " + netDmg + "              " + suff);
  }

  dmgRand(dmg) {
    return Math.max(1, randomBetween(Math.floor(dmg/2),dmg));
  }

  // Returns 0 if battle not yet ended, 1 if player won,
  // -1 if player lost.
  getBattleResult() {
    // Battle ends when all character tokens, or all enemy tokens,
    // are removed.
    let hasChars = false;
    let hasEnts = false;
    for (const tok of this.tokens) {
      hasChars = hasChars || !!tok.isChar;
      hasEnts = hasEnts || !!tok.isEnt;
    }
    return !hasChars ? -1 : !hasEnts ? 1 : 0;
  }

  printSummary() {
    for (let i = 0; i < 
        Math.max(this.party.chars.length, this.ents.length); i++) {
      const thisChar = this.party.chars[i];
      const thisEnt = this.ents[i];
      const thisCharSum = thisChar ? thisChar.getBattleSummary() : "";
      const thisEntSum = thisEnt ? thisEnt.getBattleSummary() : "";
      say("  " + padString(thisCharSum, 20) + " " + padString(thisEntSum, 20));
    }
  }
}

class BattleToken {
  constructor(charOrEnt) {
    this.charOrEnt = charOrEnt;
    this.isChar = charOrEnt instanceof Character;
    this.isEnt = charOrEnt instanceof Ent;
    assert(this.isChar || this.isEnt, "charOrEnt not a Character or Ent: " +
        charOrEnt);
  }
}

