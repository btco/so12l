"use strict";

class Region {
  // regionCode is something like "A1", "B0",...
  constructor(regionCode) {
    this.regionCode = regionCode;
    this.battles = [];

    const reader = new AnnotReader();
    if (!reader.trySeek("@wmon_" + regionCode)) {
      // No such region in table. No battles.
      return;
    }
    const count = reader.seek("@count").getNumber();
    while (this.battles.length < count) {
      const eids = reader.seek("@battle").getWords("EID_", 1)
      this.battles.push(eids);
    }
  }
  
  do(party) {
    party.restIfNeeded();
    let i = 0;
    for (const battle of this.battles) {
      ++i;
      say("START REGION " + this.regionCode + " WMON#" + i);
      Battle.doBattle(party, battle);
      party.restIfNeeded();
    }
    say("END REGION " + this.regionCode);
  }
}

