#!/usr/bin/perl
# Gets all annotated (@) XL lines from XL source and converts to a
# JS data structure.

cat >out.html <<END
<!DOCTYPE html>
<!-- AUTO-GENERATED. DO NOT EDIT. -->
END

grep -B 9999 JS_INCLUDES_HERE template.html >>out.html
echo "<script>const XL_LINES = [" >>out.html
cat ../xl/*.xl ../xl/party/*.xl | grep @ | sed "s/\"/'/g" | while read l; do
  echo "\"$l\"," >>out.html
done
echo "];" >> out.html
echo "</script>"  >>out.html
for i in *.js; do
  echo "<script src='$i' type='text/javascript'></script>" >>out.html
done
grep -A 9999 JS_INCLUDES_HERE template.html >>out.html

echo "Open in browser:"
echo `pwd`/out.html

