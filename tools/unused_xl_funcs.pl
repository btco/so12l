#!/usr/bin/perl

@procs = (qx(cat ../xl/*.xl) =~ /PROC (\w+)/g);
%used = ();
$used{$_} = "UNUSED" for @procs;

# Check for uses (in something not a PROC declaration).
$exceptPROC = qx(cat ../xl/*xl | grep -v ^PROC);
for (keys(%used)) {
  $used{$_} = "ref from XL" if ($exceptPROC =~ $_);
}

@xcalls = (qx(cat ../src/*.lua) =~ /SYM_(\w+)/g);
for (@xcalls) {
  $used{$_} = "ref from LUA" if exists($used{$_});
}

for (keys(%used)) {
  print "$_ -> $used{$_}\n";
}

