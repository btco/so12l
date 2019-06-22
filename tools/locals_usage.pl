#!/usr/bin/perl
@lines = `cat ../src/*.lua`;

$cur_func = "";
%num_locals = ();

for (@lines) {
  if (/^\s*function\s+(\w+)/) {
    $cur_func = $1;
    $num_locals{$cur_func} = 0;
  } elsif (/\s+local/) {
    $num_locals{$cur_func}++;
  }
}


@func_names = keys(%num_locals);

@func_names = sort {$num_locals{$a} <=> $num_locals{$b}} @func_names;

print "$_ -> $num_locals{$_} local decl lines\n" for @func_names;

