#!/usr/bin/perl

qx(cat ../src/loot.lua) =~ /LOL_TARGET_VALUES={(.*?)}/ or die "No LOL_TARGET_VALUES";
@values = split(/,/,$1);
scalar(@values) > 0 or die "Could not get target values.";

while (qx(cat ../src/loot.lua) =~ /define\s+(LOL_\w+)\s+(\d+)/g) {
  $target_value{$1} = $values[$2 - 1];
  $target_value{$1} > 0 or die "Target value is not > 0: $1";
  print "Loot category $1 has target value $target_value{$1}\n";
}

for $loot_cat (sort keys %target_value) {
  $target_val = $target_value{$loot_cat};
  print "$loot_cat (target $target_val gp):\n";
  while (qx(cat ../xl/items.xl) =~ /(ITID_.*?)\@dmg/gs) {
    $item = $1;

    $item =~ /^(ITID_\w+)/ or die "no itid";
    $itid = $1;

    $item =~ /^\s*DB\s+(\d+)\s*#\s*\@value/m or die "no \@value";
    $val = $1;

    $item =~ /^\s*DS\s+(.*\S)\s*#\s*name/m or die "no item name";
    $name = $1;

    $val = $val * 100 if $item =~ /ITF_VALUE_X100/;

    print "  - $itid ($name) = $val\n" if $val > 0 && $val <= $target_val;
  }
}

