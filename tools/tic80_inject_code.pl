#!/usr/bin/perl

@NON_DIGITS = split('', "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_");
$next_short_id_seed = 0;  # skip the IDs that start with a number.

sub gen_short_id {
  my $short_id = "";
  while (1) {
    $short_id = short_id_for_seed($next_short_id_seed++); 
    # If it starts with a digit, it's invalid.
    next if $short_id =~ /^\d/;
    # If it doesn't occur in the source code as a word, we can use it.
    last unless $full_text =~ /\b$short_id\b/;
  }
  return $short_id;
}

sub short_id_for_seed {
  use integer;

  my $seed = shift;
  # We be safe, we make short IDs that are either a single uppercase
  # character, or something in the format [A-Za-z][0-9]
  if ($seed <= 25) {
    return chr(65 + $seed);
  }
  $seed -= 26;

  my $tens = $seed / 10;
  my $ones = $seed % 10;
  die "Ran out of IDs\n" if $tens >= scalar(@NON_DIGITS);

  return $NON_DIGITS[$tens] . chr(48 + $ones);
}

$cart_file = shift;
-r $cart_file or die "Pass a valid cart file.\n";

open CART, "$cart_file" or die "Can't read cart file.";

# Read all parts of the cart file that are not code into $not_code.
$not_code = "";
$reading_code = 1;
while (<CART>) {
  if (/^-- </) {
    # Start of non-code section.
    $not_code = $_;
    last;
  }
}
while (<CART>) { $not_code .= $_; }
close CART;

# Now rewrite the cart file with the code in place.
$code_section = "";

# Size of each LUA file.
%sizes = ();
# Defines and their values.
%defines = ();
# IDs that we need to shorten and replace.
@ids = ();

$full_text="";
while ( ($lua_file = shift) ) {
  print STDERR "Including: $lua_file\n";
  open LUA, "$lua_file" or die "Failed to read $lua_file.";
  $block_comment=0;
  $processed = "";
  while ($line = <LUA>) {
    # Check for dangerous patterns:
    $line =~ /X_Str\(SYM_[^S]/ and die "$lua_file: X_Str requires SYM_S*\n";
    $line =~ /X_Strs\(SYM_[^A]/ and die "$lua_file: X_Strs requires SYM_A*...\n";

    $full_text .= $line;
    chomp $line;
    $line =~ s/\r//g;
    if ($block_comment) {
      $line =~ /^\s*\]\]/ and $block_comment=0;
    } elsif ($line =~ /^\s*--\[\[/) {
      $block_comment=1;
    } elsif (!$block_comment) {
      # Special syntax for the comments that should be preserved:
      # on the output file: --//
      if ($line =~ /^--##/) {
        # Convert back to regular comment style.
        $line =~ s/^--##/--/;
      } else {
        # Otherwise, remove comments.
        $line =~ s/--.*$//;
      }

      if ($line =~ /^\s*#define\s+(\S+)\s+(.*)$/) {
        $defines{$1}=$2;
      } elsif ($line =~ /^#id\s+(\S+)\s*$/) {
        push @ids, $1;
      } elsif ($line =~ /^function\s+(\S+)[(]/) {
        if ($line =~ /#keep/) {
          # Do not obfuscate this function.
          $line =~ s/\#keep//;
          $processed .= "$line\n";
        } else {
          # Shorten function name.
          push @ids, $1;
          $processed .= "$line\n";
        }
      } else {
        $processed .= "$line\n" if $line =~ /\S/;
      }
    }
  }
  close LUA;
  $code_section .= $processed;
  $sizes{$lua_file} = length($processed);
}

# Figure out the frequency of each ID in the full text.
%idfreq = ();
for $id (@ids) {
  @matches = $full_text =~ /\b($id)\b/g;
  $freq = scalar(@matches);
  die "Duplicated ID $id\n" if exists($idfreq{$id});
  $idfreq{$id} = $freq;
  die "*** ID is only used once, likely unnecessary: $id"
    if $idfreq{$id} < 2;
}

# Sort IDs by their frequency, most frequent first.
@ids = sort {$idfreq{$b} <=> $idfreq{$a}} @ids;

# Replace IDs by short names, in order.
for $id (@ids) {
  my $short_id = gen_short_id();
  $defines{$id} = $short_id;
  print "ID $id (freq $idfreq{$id}) --> SHORT $short_id\n";
}

# Expand all #defines.
while (1) {
  $old = $code_section;
  for $k (keys(%defines)) {
    $v = $defines{$k};
    $code_section =~ s/\b$k\b/$v/g;
  }
  last if ($old eq $code_section);
}

# If there are any SYM_* left, it means we failed to expand a
# symbol reference. Error out instead of failing silently.
die "SYM_ ref missing: $1\n" if $code_section =~ /(SYM_\w+)/;

# Remove indentation.
$code_section =~ s/^\s+//mg;

# Remove empty lines.
$code_section =~ s/^\s*$//mg;

# Remove \r's if there are any.
$code_section =~ s/\r/ /g;

# Join lines that can be safely joined.
$code_section =~ s/[)][ \n]/)/g;
$code_section =~ s/[}][ \n]/}/g;
$code_section =~ s/[\]][ \n]/]/g;
$code_section =~ s/,[ \n]/,/g;

$contents = $code_section . "\n" . $not_code;

open CART, ">$cart_file" or die "Failed to write cart file.";
print CART $contents;
close CART;

print "Wrote $cart_file.\n";

@p = ();
for $k (keys(%sizes)) {
  #printf "%7d %s\n", $sizes{$k}, $k;
  push @p, sprintf("%7d %s", $sizes{$k}, $k);
}
@p = sort @p;
print STDERR "$_\n" for @p;
printf STDERR "%7d TOTAL\n", length($code_section);

