"use strict";

class Log {
  static clear() {
    Log.lines = [];
  }

  static say(msg) {
    Log.lines = Log.lines || [];
    Log.lines.push(msg);
    console.log(msg);
  }

  static sayObj(title, obj) {
    this.say(title + ": " + JSON.stringify(obj, null, 2));
  }

  static render() {
    const x = document.getElementById("log");
    assert(x, "log div not found.");
    x.innerHTML = Log.lines.join("\n");
  }
}

// Shorthand
function say(msg) { Log.say(msg); }
function sayObj(msg, obj) { Log.sayObj(msg, obj); }

// Shorthand
function warn(msg) { Log.say("!!! "  + msg); }

// Shorthand
function error(msg) { Log.say("*** "  + msg); }

