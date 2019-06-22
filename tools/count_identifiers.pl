#!/usr/bin/perl
# count_identifiers.pl cart.lua

$input = join(' ',<>);
%counts = ();

for $m ($input =~ /(\w+)/g) {
  $counts{$m}++;
}

@ids = sort {$counts{$a} <=> $counts{$b}} keys(%counts);

for $id (@ids) {
  print "$counts{$id} $id\n";
}


