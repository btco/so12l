#!/bin/bash
cd `dirname $0`
cd ..
echo "Searching..."
# What syscalls is XL code using?
grep -ho -E 'SYSC_[A-Z0-9_]+' `find xl -name '*.xl'` | sort | uniq >/tmp/used_syscalls.tmp
# What syscalls exist?
grep -ho -E 'SYSC_[A-Z0-9_]+' src/xlvm.lua | sort | uniq >/tmp/avail_syscalls.tmp
diff /tmp/avail_syscalls.tmp /tmp/used_syscalls.tmp

