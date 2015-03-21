#!/bin/sh

#drwxr-xr-x      0       3       /etc
#-rwxr-xr-x      0       3       /etc/motd

#Format XML
#<property file="/etc/motd">
#         <owner>root</owner>
#         <group>wheel</group> 
#         <perms>777</perms>
#         <type></type> <!-- type: link, file, block, directory -->
#         <crc></crc>
#         <updated>everytime</updated> <!-- once, everytime, manual -->
#         <module></module> <!-- module may be m4, php or whatever module -->
#</property>

cat $1 | while read right uid gid file link target
do
	PROP="<property file=\"$file\">"	
	PROP="$PROP
	<owner>$uid</owner>"
	PROP="$PROP
	<group>$gid</group>"
	PROP="$PROP
	<perms>"
	for i in $(echo $right | tr 'r' '4' | tr 'w' '2' | tr 'x' '1' | tr '-' '0' | sed 's/.\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1+\2+\3;\4+\5+\6;\7+\8+\9/' | bc) 
	do
		PROP="$PROP$i"
	done
	PROP="$PROP</perms>"
#regular file
#directory
#symbolic link 
	TYPE=$(echo $right | sed 's/\(.\).*/\1/')
	test $TYPE == "-" && type="regular file"
	test $TYPE == "d" && type="directory"
	test $TYPE == "l" && type="symbolic link"
	PROP="$PROP
	<type>$type</type>"
	PROP="$PROP
	<link>$target</link>"
	PROP="$PROP
</property>"
svn propset property "$PROP" root$file

done
