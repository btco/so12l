"use strict";

// For convenience:
const ITK_ARMOR = "ITK_ARMOR";
const ITK_HELM = "ITK_HELM";
const ITK_MWEAP = "ITK_MWEAP";
const ITK_RWEAP = "ITK_RWEAP";
const ITK_SHIELD = "ITK_SHIELD";
const ITK_BOOT = "ITK_BOOT";
const ITK_BELT = "ITK_BELT";
const ITK_AMULET = "ITK_AMULET";
const ITK_RING = "ITK_RING";
const ITK_ALL = [
  ITK_ARMOR,
  ITK_HELM,
  ITK_MWEAP,
  ITK_RWEAP,
  ITK_SHIELD,
  ITK_BOOT,
  ITK_BELT,
  ITK_AMULET,
  ITK_RING
];


function assert(cond, msg = "Assertion failed") {
  if (!cond) {
    throw new Error(msg);
  }
  return cond;
}

function assertNumber(num, msg = "Expected number") {
  assert(typeof(num) === 'number' && num === num, msg + ": " + num);
  return num;
}

function assertString(str, msg = "Expected string") {
  assert(typeof(str) === 'string', msg + ": " + str);
  return str;
}

function assertBoolean(b, msg = "Expected bool") {
  assert(typeof(b) === 'boolean', msg + ": " + b);
  return b;
}

// inclusive
function randomBetween(lo, hi) {
  return clamp(Math.floor(lo + Math.random() * (hi - lo + 1)),
    lo, hi);
}

function clamp(v, lo, hi) {
  return v > hi ? hi : v < lo ? lo : v;
}

function makeBar(num, den) {
  if (num === 0) return "[--DEAD--]";
  let bar = "[";
  const dots = Math.round(8 * num/den);
  for (let i = 0; i < 8; i++) {
    bar += i < dots ? "#" : ".";
  }
  bar += "]" + num + "/" + den;
  return bar;
}

function padString(s, len) {
  while (s.length < len) s += " ";
  return s;
}

function isIdChar(c) {
  // For convenience if c === undefined, return false (it's definitely not an ID char!)
  if (c === undefined) return false;
  // Otherwise check if it's alphanum or digit, or _
  return "abcdefghijklmnopqrstuvwxyz0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZ".includes(c);
}

function printColumns(indent, cols, colWidth, sep) {
  let rows = 0;
  for (let col = 0; col < cols.length; col++) {
    rows = Math.max(rows, cols[col].length);
  }

  for (let i = 0; i < rows; i++) {
    let lineParts = [];
    for (let col = 0; col < cols.length; col++) {
      lineParts.push(padString(cols[col][i] || "", colWidth));
    }
    say(indent + lineParts.join(sep));
  }
}

