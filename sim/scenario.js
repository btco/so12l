class Scenario {
  constructor() {
    this.availableTowns = [ "RSTO" ];
    this.party = new Party();
    this.regionsDone = {};

    this.party.printSummary();
    this.doTown();
  }

  getParty() {
    return this.party;
  }

  startScenario() {
  }

  endScenario() {
  }

  doQuest(questId) {
    say("");
    say("<h1>QUEST: " + questId + "</h1>");
    say("");
    (new Quest(questId)).do(this.party);
    this.doTown();
  }

  doRegion(regionCode, regionName) {
    if (this.regionsDone[regionCode]) {
      say("REGION " + regionCode + ": was already done.");
      return;
    }
    say("<h1>Region: " + regionCode + "(" + regionName + ")</h1>");
    this.regionsDone[regionCode] = true;
    (new Region(regionCode)).do(this.party);
    this.doTown();
  }

  addChar(charAnnot) {
    this.party.addChar(charAnnot);
  }

  addTown(townId) {
    this.availableTowns.push(townId);
    say("+++ New town available: " + townId);
    say("+++ Towns now available: " +
        this.availableTowns.join(", "));
    this.doTown();
  }

  addSpell(zid) {
    this.party.addSpell(zid);
  }

  doTown() {
    (new Town(this.availableTowns)).do(this.party);
  }

  doLevel(levelId) {
    (new Level(levelId)).do(this.party);
  }

  addGold(amount, why, account) {
    this.party.addGold(amount, why, account);
  }

  //doBattle(ents) {
  //  Battle.doBattle(this.party, ents);
  //}
}

