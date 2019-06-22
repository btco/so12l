#!/usr/bin/perl
# Injects a section into a text-based TIC80 cartridge.
# Syntax:
#   tic80_inject_section cart.lua SECTION_NAME file.txt
#
# This will replace section SECTION_NAME in the cartridge with
# the contents of file.txt.

$cart_file = shift or die "Missing cart file.\n";
$section_name = shift or die "Missing section name.\n";
$section_file = shift or die "Missing section contents file.\n";

print STDERR "Cart file: $cart_file\n";
print STDERR "Section name: $section_name\n";
print STDERR "Section contents file: $section_file\n";

open CONTENTS, "$section_file" or die "Failed to read $section_file.\n";
$contents = join("",<CONTENTS>);
$contents =~ s/\r//g;
$contents =~ s/\n$//;
close CONTENTS;

open CART, "$cart_file" or die "Failed to read cart file $cart_file.\n";
push @lines, $_ while (<CART>);
close CART;

open CART, ">$cart_file" or die "Failed to write to $cart_file.\n";
$in_section = 0;
$found = 0;
for $line (@lines) {
  $line =~ s/\r//g;
  if ($in_section) {
    # Skip lines until the end of the section.
    $line =~ /^--\s+<\/$section_name>/ and $in_section = 0;
    next;
  }
  if ($line =~ /^--\s+<$section_name>/) {
    $in_section = 1;
    $found = 1;
    # Inject contents.
    print CART "-- <$section_name>\n$contents\n-- </$section_name>\n";
    next;
  }
  print CART $line;
}
close CART;
if ($found) {
  print "Section $section_name replaced.\n";
} else {
  print "*** ERROR: section $section_name NOT FOUND.\n" unless $found;
}

