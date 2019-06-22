#!/bin/bash

rm -rf out
mkdir -p out

# Extract all the define statements from the source for inclusion
# in the XL assembly.
echo "Extracting defines..."
grep -E '^ *#define' src/*.lua | cut -d: -f2- >out/defs.def

# Now assemble the XL program.
echo "Assembling XL program..."
all_xl=`find xl -name '*.xl'`
if ! perl tools/xlasm -s out/xlsym.def -o out/xlbin -d out/debug.txt\
    -z out/strides.txt $all_xl out/defs.def; then
  echo "*** Error assembling XL source."
  exit 1
fi

# Process and inject the code into the cartridge.
echo "Injecting code..."
if ! perl tools/tic80_inject_code.pl cart.lua src/*.lua out/xlsym.def >out/inject.txt; then
  echo "*** Failed to inject code."
  exit 1
fi

# Inject the XL binary into the cartridge (as bank 6's map memory).
echo "Injecting XL binary (low segment)..."
if ! perl tools/tic80_inject_section.pl cart.lua MAP6 out/xlbin_lo.txt; then
  echo "*** Error injecting XL binary (low segment) into cartridge."
  exit 1
fi

# If there is a high segment of the XL binary, inject into bank 7 map.
if [ -f "out/xlbin_hi.txt" ]; then
  echo "Injecting XL binary (high segment)..."
  if ! perl tools/tic80_inject_section.pl cart.lua MAP7 out/xlbin_hi.txt; then
    echo "*** Error injecting XL binary (high segment) into cartridge."
    exit 1
  fi
fi

grep 'XL bin size' out/debug.txt

echo "Biggest XL symbol strides:"
tail -n10 out/strides.txt | sed 's/^/  /'

echo "Done."

