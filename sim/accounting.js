class Accounting {
  constructor() {
    this.accounts = {
      // I_ are income accounts
      // A_ are asset accounts
      // E_ are expense accounts

      // Starting money given.
      I_START_CASH: 0,
      // Starting items given.
      I_START_ITEMS: 0,
      // Money given as quest reward.
      I_REWARDS: 0,
      // Money looted from enemies.
      I_LOOT: 0,
      // Cash assets.
      A_CASH: 0,
      // Item assets.
      A_ITEMS: 0,
      // Food expenses.
      E_FOOD: 0,
      // Inn expenses.
      E_LODGING: 0,
      // Training expenses.
      E_TRAINING: 0,
      // Quest expenses.
      E_QUEST: 0,
    };
  }

  // Registers a transaction.
  reg(creditAccount, debitAccount, amount) {
    assert(undefined !== this.accounts[creditAccount],
      "Invalid account " + creditAccount);
    assert(undefined !== this.accounts[debitAccount],
      "Invalid account " + debitAccount);
    this.accounts[creditAccount] += amount;
    this.accounts[debitAccount] -= amount;
  }

  printSummary() {
    // income, assets, expense columns:
    const icol = [], acol = [], ecol = [];

    say("BALANCE SHEET:");
    const incomeKeys = Object.keys(this.accounts).
      filter(k => k.startsWith("I_"));
    const assetKeys = Object.keys(this.accounts).
      filter(k => k.startsWith("A_"));
    const expenseKeys = Object.keys(this.accounts).
      filter(k => k.startsWith("E_"));
    this.printAccounts(incomeKeys, -1, icol);
    this.printAccounts(assetKeys, 1, acol);
    this.printAccounts(expenseKeys, 1, ecol);
    printColumns("  ", [icol, acol, ecol], 40, " | ");
    say("");
    say("");
  }

  printAccounts(keys, sign, out) {
    let total = 0;
    for (const key of keys) {
      out.push(padString(key, 15) + ": " +
        padString(sign * this.accounts[key], 6));
      total += sign * this.accounts[key];
    }
    out.push(padString("--TOTAL--", 15) + ": " + padString(total, 6));
  }
}

