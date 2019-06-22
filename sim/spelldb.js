class SpellDb {
  static instance() {
    return (SpellDb.inst = SpellDb.inst || new SpellDb());
  }

  constructor() {
    this.spells = {}

    const reader = new AnnotReader();
    while (reader.trySeek("@paladinSpell")) {
      const zid = reader.getWord("ZID_");
      const cost = reader.seek("@cost").getNumber()
      this.spells[zid] = new Spell(zid, cost, "CLS_PALADIN");
    }
    while (reader.trySeek("@wizardSpell")) {
      const zid = reader.getWord("ZID_");
      const cost = reader.seek("@cost").getNumber()
      this.spells[zid] = new Spell(zid, cost, "CLS_WIZARD");
    }

    say("ZDB: loaded " + Object.keys(this.spells).length + " spells.");
  }

  getSpell(zid) {
    const spell = this.spells[zid];
    assert(spell, "ZID not found: " + zid);
    return spell;
  }
}

class Spell {
  constructor(zid, cost, klass) {
    this.zid = zid;
    this.cost = cost;
    this.klass = klass;
  }
}

