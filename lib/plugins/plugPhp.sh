#### PHP Pre-processing ####
php=/usr/bin/php
#
if [ ! -e $(echo $php| awk '{print $1}') ]
then
	echo "[ERROR] no $php on $(hostname)"
	exit 1
fi

# Treat the perm.conf.template.php files
for permconftemplate in $(find $TMPDIR -name "perm.conf.template.php" -type f)
do
	PERMCONF=$(echo $permconftemplate | sed 's/.template.php//')
	(
		cat $permconftemplate
	) | $php >> $PERMCONF ; rm $permconftemplate
done

cd $TMPDIR/hosts/$host
test -e perm.conf && cat perm.conf | while read perm uid gid file arrow link
do
	# Do we need php processing?
	echo $file| grep -q ".template.php"
	if [ $? -eq 0 ]
	then
		file=$(echo $file| sed 's/.template.php//')
		(
			cat $TMPDIR/hosts/$host/root/$file.template.php
		) | $php > $TMPDIR/hosts/$host/root/$file
		rm $TMPDIR/hosts/$host/root/$file.template.php

	fi
done
test -e perm.conf && sed -i 's/.template.php//' perm.conf


for profile in $PROFILES
do
	cd $TMPDIR/templates/$profile
	test -e perm.conf && cat perm.conf | while read perm uid gid file arrow link
	do
		# Do we need php processing?
		echo $file| grep -q ".template.php"
		if [ $? -eq 0 ]
		then
			file=$(echo $file| sed 's/.template.php//')
			$php $TMPDIR/templates/$profile/root/$file.template.php \
				> $TMPDIR/templates/$profile/root/$file 
			rm $TMPDIR/templates/$profile/root/$file.template.php
		fi
	done
	test -e perm.conf && sed -i 's/.template.php//' perm.conf
done

