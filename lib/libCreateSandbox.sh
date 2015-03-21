## COMMON Library for the check and update tools
test $DEBUG && echo "<debug>entering libCreateSandbox.sh</debug>" 

# If TMPDIR exists, then exit, otherwise create it
test $DEBUG && echo "<debug>Creating tmpdir ($TMPDIR)</debug>" 
test -d $TMPDIR && exit 1 || mkdir -p $TMPDIR/hosts $TMPDIR/templates $TMPDIR/xml $TMPDIR/scripts $TMPDIR/sandbox/root
cd $TMPDIR


cd $TMPDIR/hosts
test $DEBUG && echo "<debug>Running svn checkout of $host</debug>" 
svn checkout $SVNROOT/hosts/$host 2> /dev/null > /dev/null
test -f $host/profile && cat $host/profile | sed 's/#.*//' | grep -v "^$" | while read profile
do
	cd $TMPDIR/templates
	test $DEBUG && echo "<debug>Running svn checkout of $profile</debug>" 
	svn checkout $SVNROOT/templates/$profile 2> /dev/null > /dev/null
done
cd $TMPDIR
test -f hosts/$host/profile && PROFILES=$(cat hosts/$host/profile| sed 's/#.*//' | grep -v "^$")

# Generating a global xml file with all the properties (legacy it was perm.conf)
echo "<manifest>Generating manifest $MANIFEST</manifest>"
echo "<properties>" > $MANIFEST
find $TMPDIR -exec svn propget property {} 2>/dev/null \;  >> $MANIFEST
echo "</properties>" >> $MANIFEST

test $DEBUG && echo "<debug>exiting libCreateSandbox.sh</debug>" 
