#!/usr/bin/perl

@symbs = (qx(cat ../xl/strs.xl ../xl/istrs.xl) =~ /^(?:EXPORT )?(\w+):/gm);

%uses = ();

$everything = qx(cat ../xl/*.xl ../src/*.lua);
for (@symbs) {
  chomp;
  @matches = ($everything =~ /$_/g);
  $uses{$_} = scalar(@matches) - 1;
}

for (keys(%uses)) {
  print "$_ -> $uses{$_}\n";
}

