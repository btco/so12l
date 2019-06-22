"use strict";

class Item {
  constructor(itid, kind, flags, value, itac, attdef) {
    this.itid = itid;
    this.kind = kind;
    this.flags = flags;
    this.value = value;
    this.itac = itac;
    this.attdef = attdef;
  }
}

// Singleton. Lazily created.
class ItemDb {
  static instance() {
    if (!ItemDb.inst) {
      ItemDb.inst = new ItemDb();
    }
    return ItemDb.inst;
  }

  constructor() {
    assert(!ItemDb.inst, "ItemDb is singleton!");

    // Map from ITID to item.
    this.items = {};

    //say("Loading item DB...");
    const reader = new AnnotReader();
    while (reader.trySeek("@item")) {
      const itid = reader.getWord("ITID_");
      const kind = reader.seek("@kind").getWord("ITK_");
      const flags = reader.seek("@flags").getString();
      let value = reader.seek("@value").getNumber();
      const itac = reader.seek("@itac").getString();
      const attdef = reader.seek("@attdef").getNumber();
      // ITF_VALUE_X100 flag means value must be multiplied by 100
      if (flags.includes("ITF_VALUE_X100")) value *= 100;

      this.items[itid] =
        new Item(itid, kind, flags, value, itac, attdef);
    }
    assert(Object.keys(this.items).length > 50, "Item DB load failed.");
  }

  getItem(itid) {
    return assert(this.items[itid], "Item not found: " + itid);
  }

  getAllOfKind(itk) {
    return Object.values(this.items).filter(it => it.kind === itk);
  }
}

