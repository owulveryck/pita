## COMMON Library for the check and update tools

cd $TMPDIR

UNIX=$(find . -type d -name 'root' | wc -l)

#### Copy the files on the remote host in the TMPDIR ####
ssh root@${host}-bck "test -d $TMPDIR && exit 1 || mkdir $TMPDIR" || exit 11

##test -f hosts/$host/profile && cat hosts/$host/profile | while read profile
for profile in $PROFILES
do
	#TODO The cross template links shoud be materialized
	# eg: is solaris/root/etc/sudoers -> unix/root/etc/sudoers then do 
	# cp unix/root/etc/sudoers solaris/root/etc/sudoers
	cd $TMPDIR/templates/$profile && tar chf - . | ssh root@${host}-bck "cd $TMPDIR && tar xf - 2>/dev/null"
done
cd $TMPDIR/hosts/$host && tar chf - . | ssh root@${host}-bck "cd $TMPDIR && tar xf - 2>/dev/null"

if [[ $(find $TMPDIR -name "packages" | wc -l) -ne 0 && $PACKAGES -eq 1 ]]
then
	echo "[DUPLICATES PACKAGES]"
	cat $(find $TMPDIR -name "packages") | awk '{print $1}' | sort | uniq -d
	cat $(find $TMPDIR -name "packages") | sort -u > packages
	scp packages $host:$TMPDIR > /dev/null
fi

cd $TMPDIR
scp perm.conf root@${host}-bck:$TMPDIR > /dev/null
