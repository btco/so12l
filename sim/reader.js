"use strict";

class AnnotReader {
  constructor() {
    this.reset();
  }

  trySeek(annot, endAnnot = null) {
    // Start seeking at the NEXT line (so we don't repeatedly
    // return the same line).
    let i = this.pos + 1;
    while (i < XL_LINES.length) {
      const line = XL_LINES[i];
      let pos;
      if (endAnnot) {
        pos = line.indexOf(endAnnot);
        // Match @thing but not @thingwithsuffix
        if (pos >= 0 && !isIdChar(line[pos + endAnnot.length])) {
          // Matched end annotation, so seek failed.
          return false;
        }
      }

      pos = line.indexOf(annot);
      // Match @thing but not @thingwithsuffix
      if (pos >= 0 && !isIdChar(line[pos + annot.length])) {
        // Seek success.
        this.pos = i;
        return true;
      }
      i++;
    }
    // Not found.
    return false;
  }

  seek(annot, endAnnot = null) {
    const seekResult = this.trySeek(annot, endAnnot);
    assert(seekResult, "XL annot not found: " + annot +
        (endAnnot ? (" (end: " + endAnnot + ")") : ""));
    return this;
  }

  reset() {
    // Start at -1 because we always seek from the position FOLLOWING
    // the current one.
    this.pos = -1;
    return this;
  }

  // Gets full XL line.
  getRawLine() {
    return XL_LINES[this.pos];
  }

  // Gets the value of a key-value pair formatted as key=value
  tryGetValue(key) {
    const words = this.getRawLine().split(' ');
    for (const word of words) {
      if (word.startsWith(key + "=")) {
        return word.substr(key.length + 1);
      }
    }
    return null;
  }

  getValue(key) {
    const result = this.tryGetValue(key);
    assert(result !== null, "Could not get value for key " + key);
    return result;
  }

  // Gets normalized XL line.
  getLine() {
    return this.normalizeLine(this.getRawLine());
  }

  // Gets a string value.
  // Line in in format:
  //   D? Something something      # @annot
  //  (where ? can be anything).
  getString() {
    const nl = this.getLine();
    assert(nl.substr(0,1) === "D", "Line does not start with D?: " + nl);
    assert(nl.substr(2,1) === " ", "Line does not start with D?: " + nl);
    return nl.substr(3).trim();
  }

  // Gets a DB or DW number.
  // Line is in format:
  //   DB 1234      # @annot
  //   DW 1234      # @annot
  getNumber() {
    let nl = this.getLine();
    assert(nl.startsWith("DB ") || nl.startsWith("DW "),
      "Line does not start with DB or DW: " + nl);
    nl = nl.substr(3).trim().split(' ')[0];
    // Note: ret === ret checks for NaN.
    // Also, note that typeof(NaN) === 'number'. Thanks, Javascript.
    const ret = +nl;
    assert(typeof(ret) === 'number' && ret === ret,
        "Failed to get number from line: " + this.getLine());
    return ret;
  }

  // Gets a number anywhere on the line.
  getAnyNumber() {
    const words = this.getLine().split(' ');
    for (const word of words) {
      const num = Number.parseInt(word);
      if (typeof(num) === 'number' && num === num) {
        return num;
      }
    }
    throw new Error("Can't find a number in line: " + this.getLine());
  }

  // Determines if line contains given substring.
  lineContains(s) {
    return this.getLine().includes(s);
  }

  // Gets the word that begins with p in the line.
  // Example: getWord("ITID_") might return ITID_DAGGER
  // Returns "" if not found.
  tryGetWord(prefix, defaultValue = null) {
    const words = this.getWords(prefix);
    return words[0] || defaultValue;
  }

  getWords(prefix, minCount = 0) {
    const words = this.getLine().split(' ');
    let result = [];
    for (const word of words) {
      if (word.startsWith(prefix)) result.push(word);
    }
    assert(result.length >= minCount, "Expected " + minCount + " words with prefix " +
        prefix + " in line: " + this.getLine());

    // Remove trailing punctuation from words, like semicolons.
    result = result.map(f => f.endsWith(";") ? f.substr(0, f.length - 1) : f);

    return result;
  }

  getWord(prefix) {
    const ret = this.tryGetWord(prefix, null);
    if (ret === null) throw new Error("Could not find word with prefix "  +
        prefix + " in line " + this.getLine());
    return ret;
  }

  // Trims and removes comments from given line.
  normalizeLine(s) {
    const i = s.indexOf("#");
    if (i >= 0) s = s.substr(0, i);
    return s.trim();
  }
}

