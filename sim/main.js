"use strict";

function main() {
  addScenario("scenario1");
  addScenario("scenario2");
}

function addScenario(name) {
  const bar = assert(document.getElementById("controls"));
  const button = document.createElement("button");
  button.innerHTML = name;
  bar.appendChild(button);
  button.addEventListener("click", function() { runScenario(name); });
}

function runScenario(name) {
  Log.clear();
  try {
    eval(name + "()");
  } catch (e) {
    say("*** ERROR RUNNING SCENARIO: " + e);
    say(e.stack);
  }
  Log.render();
}

function scenario1() {
  const scenario = new Scenario();
  scenario.startScenario();
  say("Scenario 1");
  scenario.doQuest("RESCUE_GOV");
  scenario.addChar("@char_lyla");
  scenario.doQuest("RSTO_INCENSE");
  scenario.addSpell("ZID_HEAL");
  scenario.doRegion("C3", "Riverside");  // Riverside central region
  scenario.doQuest("ORCHARD");
  scenario.addSpell("ZID_PROTECT");
  scenario.doQuest("MYRA");

  // Explore Blossom Fields.
  scenario.doRegion("C4", "Blossom Fields West");
  scenario.doRegion("D4", "Blossom Fields East");
  // Travel west to Serpent Island.
  scenario.doRegion("B4", "Serpent Island");
  // Can now access town of FOVI.
  scenario.addTown("FOVI");
  // Explore Serpent Woods.
  scenario.doRegion("A4", "Serpent Woods");
  // Explore Sandy Islands.
  scenario.doRegion("A5", "Sandy Islands N");
  scenario.doRegion("A6", "Sandy Islands S");
  // Town of SUTO is now available.
  scenario.addTown("SUTO");
  // Vic joins party.
  scenario.addChar("@char_vic");
  scenario.addSpell("ZID_FORCE_BEAD");
  // OTO quest.
  scenario.doQuest("OTO_GHOST");

  // Go through tunnel to Southern Kingdom.
  scenario.doQuest("VQ_TUNN");  // virtual quest
  // Unlock city of MTN
  scenario.addTown("MTN");
  // Complete the World Map (virtual quest).
  scenario.doQuest("VQ_WORLD_MAP");
  // Do the BRACELET quest
  scenario.doQuest("BRACELET");
  // Now travel to Castle South.
  scenario.doRegion("B6", "South Kingdom (SW quadrant)");
  // Got to the palace.
  scenario.addTown("CAST");
  // Go out to explore the dark side of South Kingdom
  scenario.doRegion("C6", "South Kingdom (dark SE quadrant)");
  // Gained access to the SK huts (weapon merchants).
  scenario.addTown("SK_HUTS");
  // Complete SK_LIGHT quest (beat Monastery).
  scenario.doQuest("SK_LIGHT");
  // Complete JEWELRY_BOX quest (got it from the thief in SK,
  // returned to Lena in SUTO).
  scenario.doQuest("JEWELRY_BOX");
  // Take boat to desert (virtual quest)
  scenario.doQuest("VQ_BOAT_TO_DE");
  // Desert regions (SW, NW, NE):
  scenario.doRegion("C2", "Great Desert SW");
  scenario.doRegion("C1", "Great Desert NW");
  scenario.doRegion("D1", "Great Desert NE");
  // Get to SAHA.
  scenario.addGold(3000, "SAHA spoils", "I_LOOT");
  // Obelisk quest.
  scenario.doQuest("OBELISK");

  // Gain access to Marshes huts for trade
  scenario.addTown("MA_HUTS");

  // Travel to WPTO
  scenario.doRegion("B2", "Marshes - South");
  // Get access to WPTO town.
  scenario.addTown("WPTO");
  // Defeat monsters in Bamboo Grove, get Indigo Statuette.
  scenario.doRegion("D3");
  // Complete the INTO quest.
  scenario.doQuest("INTO");
  // Return to mashes to visit NOKE.
  scenario.doRegion("B1", "Marshes - North");
  // Night Island:
  scenario.doRegion("E1", "Night Island (North)");
  // Now they get the King's Crown, and journey south.
  // Reach the Underground City.
  scenario.addTown("UGTO");

  // Side quests: the Lost Library and Dictionary
  scenario.doQuest("LLIB");
  scenario.doQuest("DICTIONARY");

  // Travel through Frost Island
  scenario.doRegion("E4", "Frost Island (northern peninsula)");
  scenario.doRegion("E5", "Frost Island");
  // Gain access to YNIS
  scenario.addTown("YNIS");
  // Continue to travel the frost lands.
  scenario.doRegion("D5", "Frost Island");
  scenario.doRegion("E6", "Frost Island");
  scenario.doRegion("F5", "Frost Island");
  // Do the Music Box quest (return buried Music Box to WPTO).
  scenario.doQuest("MUSIC_BOX");
  // Do the King's Ring sword and ring quests.
  scenario.doQuest("KINGS_SWORD");
  scenario.doQuest("KINGS_RING");

  // Get final equipment.
  scenario.getParty().upgradeEquipped(1, "ITID_KINGS_SWORD", "I_LOOT");
  scenario.getParty().upgradeEquipped(1, "ITID_KINGS_ARMOR", "I_LOOT");
  scenario.getParty().upgradeEquipped(1, "ITID_KINGS_CROWN", "I_LOOT");

  // Final quest.
  scenario.doQuest("FINAL");

  scenario.endScenario();
}

function scenario2() {
  say("Scenario 2");
}



