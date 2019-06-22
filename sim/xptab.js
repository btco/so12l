// Singleton.
class XpTab {
  static instance() {
    return (XpTab.inst = XpTab.inst || new XpTab());
  }

  constructor() {
    assert(!XpTab.inst, "XpTab is singleton.");
    this.xpForLevel = [];

    const reader = new AnnotReader();
    reader.seek("@xptable");
    for (let i = 0; reader.trySeek("@xptable_entry"); i++) {
      const xp = reader.getNumber() * 1000;
      //say("XP TABLE: " + i + " -> " + xp);
      this.xpForLevel.push(xp);
    }
    assert(this.xpForLevel[0] === 0);
    assert(this.xpForLevel[1] === 0);
    assert(this.xpForLevel[2] > 0);
  }

  getXpForLevel(level) {
    return this.xpForLevel[level];
  }

  getLevelForXp(xp) {
    let level = 1;
    while (this.xpForLevel[level + 1] !== undefined &&
        xp >= this.xpForLevel[level + 1]) {
      level++;
    }
    return level;
  }
}

