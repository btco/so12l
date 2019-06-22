#!/usr/bin/perl

%mentions = ();
%map = ();

# Get all positions mentioned in XL code.
for $_ (qx(cat ../xl/*.xl)) {
  /LOHI\((\d+),(\d+)\)/ and do {
    $mentions{"$1,$2"} = 1;
  };
}

# Load the map into %map.
for $_ (qx(cat ../cart.lua)) {
  chomp;
  /<MAP>/ and $in_map=1;
  /<\/MAP>/ and last;
  $in_map or next;
  /<MAP>/ and next;
  /(\d+):(\w+)$/ or die "Failed to match $_.\n";
  $row = int($1);
  $cols = $2;
  length($cols) == 480 or die "Row $row does not have 480 hex chars.\n";
  for (my $col = 0; $col < 239; $col++) {
    # Annoyingly the hex digits are reversed in the TIC80 map format:
    $tid = hex(substr($cols, $col * 2 + 1, 1) . substr($cols, $col * 2, 1));
    $map{"$col,$row"} = $tid;
  }
}

%INTERACTIBLES = (
 8 => "hut",
 98 => "snow hut",
 53 => "sign",
 47 => "altar",
 77 => "book",
 16 => "door",
 32 => "door",
 101 => "door",
 102 => "door",
);

# Check that all interactibles are mentioned.
for ($row = 0; $row <= 135; $row++) {
  for ($col = 0; $col <= 239; $col++) {
    $this_tid = $map{"$col,$row"};
    $name = $INTERACTIBLES{$this_tid};
    next unless $name;
    print "NOT MENTIONED: $name @ $col,$row\n" unless $mentions{"$col,$row"};
  }
}


