#### M4 Pre-processing ####
#
if [ ! -e $(echo $m4| awk '{print $1}') ]
then
	echo "[ERROR] no $m4 on $(hostname)"
	exit 1
fi
# Let's do the include of every etc/m4 files
for profile in $PROFILES
do
	for file in $(find $TMPDIR/templates/$profile -name "*m4" -type f | grep -v "root/etc" | grep "etc/.*m4" )
	do
		M4INCLUDE="${M4INCLUDE}m4_include($file)"
	done
done
for file in $(find $TMPDIR/hosts -name "*m4" -type f | grep -v "root/etc" | grep "etc/.*m4" )
do
	M4INCLUDE="${M4INCLUDE}m4_include($file)"
done
M4INCLUDE="${M4INCLUDE}m4_dnl"
M4INCLUDEGENERIC='m4_changequote({{,}})m4_dnl'
# Create the include 
M4CMDINCLUDE="-I $TMPDIR/hosts/$host -I $TMPDIR/templates/"
(
	echo "$M4INCLUDEGENERIC" 
	echo "$M4INCLUDE" 
) | $m4 $M4CMDINCLUDE -F $TMPDIR/include.m4f 


# Treat the perm.conf.template.m4 files
for permconftemplate in $(find $TMPDIR -name "perm.conf.template.m4" -type f)
do
	PERMCONF=$(echo $permconftemplate | sed 's/.template.m4//')
	(
		echo "$M4INCLUDEGENERIC"
		echo "$M4INCLUDE"
		cat $permconftemplate
	) | $m4 $M4CMDINCLUDE >> $PERMCONF ; rm $permconftemplate
done

cd $TMPDIR/hosts/$host
test -e perm.conf && cat perm.conf | while read perm uid gid file arrow link
do
	# Do we need m4 processing?
	echo $file| grep -q ".template.m4"
	if [ $? -eq 0 ]
	then
		file=$(echo $file| sed 's/.template.m4//')
		(
			echo "$M4INCLUDEGENERIC"
			echo "$M4INCLUDE"
			cat $TMPDIR/hosts/$host/root/$file.template.m4
		) | $m4 $M4CMDINCLUDE > $TMPDIR/hosts/$host/root/$file
		rm $TMPDIR/hosts/$host/root/$file.template.m4

	fi
done
test -e perm.conf &&  sed -i 's/.template.m4//' perm.conf


for profile in $PROFILES
do
	cd $TMPDIR/templates/$profile
	test -e perm.conf && cat perm.conf | while read perm uid gid file arrow link
	do
		# Do we need m4 processing?
		echo $file| grep -q ".template.m4"
		if [ $? -eq 0 ]
		then
			file=$(echo $file| sed 's/.template.m4//')
#			(
#				echo "$M4INCLUDEGENERIC"
#				echo "$M4INCLUDE"
#				cat $TMPDIR/templates/$profile/root/$file.template.m4
#			) | $m4 $M4CMDINCLUDE > $TMPDIR/templates/$profile/root/$file || echo "[$file.template.m4] has a problem"
			$m4 $M4CMDINCLUDE -R $TMPDIR/include.m4f $TMPDIR/templates/$profile/root/$file.template.m4 \
				> $TMPDIR/templates/$profile/root/$file 
			rm $TMPDIR/templates/$profile/root/$file.template.m4
		fi
	done
	test -e perm.conf && sed -i 's/.template.m4//' perm.conf
done

