class Town {
  // availableTowns: array of town codes, e.g., ["RSTO", "WPTO", "FOVI"]
  constructor(availableTowns) {
    assert(Array.isArray(availableTowns), "availableTowns must be array.");
    this.wares = [];
    this.levelCap = 1;
    this.availableTowns = availableTowns;

    // List of items we wanted but could not afford when trying to upgrade.
    this.couldNotAfford = [];

    for (const town of availableTowns) {
      assertString(town, "Town code must be string: " + town);
      const reader = new AnnotReader();
      while (reader.trySeek("@wares_" + town)) {
        this.wares.push(reader.getWord("ITID_"));
      }
      reader.reset();
      if (reader.trySeek("@train_" + town)) {
        assert(reader.lineContains("CALL Train"));
        const levelCap = reader.getAnyNumber();
        say("Town " + town + " has training up to " + levelCap);
        this.levelCap = Math.max(this.levelCap, levelCap);
      }
    }
    assert(this.wares.length > 0, "No wares?");
  }

  do(party) {
    say("---- TOWN");
    this.buyRations(party);
    this.train(party);
    this.buyUpgrades(party);
    this.visitInn(party);
    party.healingPotions = 4;
    say("---- END TOWN");
    party.printSummary();
  }

  visitInn(party) {
    say("INN (full recovery).");
    //if (party.gold > 10) party.addGold(-10, "Inn", "E_LODGING");
    party.recoverFull();
  }

  buyRations(party) {
    say("Bought rations.");
    party.rations = 4;
    // Buy rations.
    /*
    const rationPrice = ItemDb.instance().getItem("ITID_RATION").value;
    assertNumber(rationPrice, "ration price must be number.");
    assert(rationPrice > 0, "ration price must be > 0");
    let bought = 0;
    while (assertNumber(party.rations) < MAX_RATIONS) {
      if (party.gold < rationPrice) {
        say("!!! NOT ENOUGH MONEY TO BUY RATIONS. Have " +
            party.rations + " rations.");
        break;
      }
      party.addGold(-rationPrice, "Rations", "E_FOOD");
      party.rations++;
      bought++;
    }
    say("Bought " + bought + " rations. Gold now " + party.gold); */
  }

  train(party) {
    while (party.isEligible()) {
      if (party.level >= this.levelCap) {
        say("!!! LEVEL CAP OF AVAILABLE TOWNS REACHED: " + this.levelCap);
        return;
      }
      say("TRAINING");
      const cost = (party.level + 1) * (party.level + 1) * 10;
      say("  Lvl : " + (party.level + 1));
      say("  Cost: " + cost);
      if (party.gold < cost) {
        say("!!! NOT ENOUGH MONEY TO TRAIN.");
        break;
      } else {
        party.levelUp();
        party.addGold(-cost, "Training", "E_TRAINING");
      }
      say("END TRAINING");
    }
  }

  buyUpgrades(party) {
    say("SHOPPING FOR UPGRADES in " + this.availableTowns.join(', '));
    this.couldNotAfford = [];
    let upgraded = true;
    while (upgraded) {
      upgraded = false;
      for (const ch of party.chars) {
        if (ch.getAtt() < ch.getDef()) {
          // Prioritize upgrading attack.
          upgraded = this.tryUpgradeAtt(party, ch) || upgraded;
          upgraded = this.tryUpgradeDef(party, ch) || upgraded;
        } else {
          // Prioritize upgrading defense.
          upgraded = this.tryUpgradeDef(party, ch) || upgraded;
          upgraded = this.tryUpgradeAtt(party, ch) || upgraded;
        }
      }
    }
    say("DONE SHOPPING FOR UPGRADES.");
    if (this.couldNotAfford.length > 0) {
      say("!!! COULD NOT AFFORD: " + this.couldNotAfford.join(', '));
    }
    this.couldNotAfford = [];
  }

  tryUpgradeAtt(party, ch) {
    const itk = ch.klass === "CLS_ARCHER" ? "ITK_RWEAP" : "ITK_MWEAP";
    return this.tryUpgrade(party, ch, itk);
  }

  tryUpgradeDef(party, ch) {
    for (const itk of [ITK_ARMOR, ITK_HELM, ITK_SHIELD, ITK_BOOT ]) {
      if (this.tryUpgrade(party, ch, itk)) {
        return true;
      }
    }
    return false;
  }

  getAllAvailableItemsOfKind(itk) {
    return this.wares.
        map(itid => ItemDb.instance().getItem(itid)).
        filter(item => item.kind === itk);
  }

  tryUpgrade(party, ch, itk) {
    const available = this.getAllAvailableItemsOfKind(itk);
    // Current item of this kind.
    const curItid = ch.eq[itk];
    const curItem = curItid ? ItemDb.instance().getItem(curItid) : null;
    const curAttDef = curItem ? curItem.attdef : 0;
    const curValue = curItem ? curItem.value : 0;
    const curItidStr = curItid ? curItid : "(none)";
    const curScore = curAttDef;
    // Find the cheapest upgrade.
    let cheapestItid, cheapestPrice;
    for (const it of available) {
      // Right kind?
      if (it.kind !== itk) continue;
      // Can we use it?
      if (!ch.canUseIt(it)) continue;
      // Zero-value items are special. Ignore.
      if (!it.value) continue;
      const thisScore = it.attdef;
      // How good is it compared to the one we have now?
      if (thisScore <= curScore) continue;
      if (!cheapestItid || it.value < cheapestPrice) {
        cheapestItid = it.itid;
        cheapestPrice = it.value;
      }
    }
    if (!cheapestItid) return false;
    // Can we afford the upgrade? (sell current, buy new)
    const spend = cheapestPrice - curValue;
    const upgradeDesc = curItidStr + " -> " + cheapestItid + ", cost " + spend;
    if (party.gold < spend) {
      this.couldNotAfford.push(cheapestItid);
      return false;
    } else {
      party.addGold(-spend, "Upgrade", "A_ITEMS");
      say("  +++ Upgrade made " + ch.name + ": " + upgradeDesc + ", gold left " + party.gold);
      ch.eq[itk] = cheapestItid;
      return true;
    }
  }
}

const MAX_RATIONS = 4;

