class Ent {
  constructor(eid, name) {
    const reader = new AnnotReader();
    reader.seek("@eid_" + eid);
    this.eid = eid;
    this.name = name;
    this.speed = reader.seek("@speed").getNumber();
    this.maxHp = this.hp = reader.seek("@maxHp").getNumber();
    this.def = 0;  // By new design, all ents have defense 0
    this.xp = reader.seek("@xp").getNumber();
    this.gold = reader.seek("@gold").getNumber();
    this.numAttacks = reader.seek("@numAttacks").getNumber();
    this.attType = reader.seek("@attType").getWord("BAT_AK_");
    this.att = reader.seek("@att").getNumber();
  }

  applyNetDamage(dmg) {
    this.hp = Math.max(0, this.hp - assertNumber(dmg));
  }

  isDead() {
    return this.hp < 1;
  }

  getAtt() { return this.att; }
  getDef() { return this.def; }
  getHp() { return this.hp; }
  getSpeed() { return this.speed; }
  getName() { return this.name; }
  getBattleSummary() {
    return this.name + ":" + makeBar(this.hp, this.maxHp);
  }
}

