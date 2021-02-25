#!/bin/sh

##### pre_Disk_Partition.sh ####

outfile='/tmp/part-include'


CreatePartFile() {

## VAR
	boot_size=1022
	biosboot_size=2
	swap_size=8196
	root_size=50000
	home_size=75500

##
	get_disktype=$1
	get_disknu=$2
	if [ $get_disknu -gt 1 ];then
		##-------------------2 drives-------------------##

			# 2 Disk partitioning information,datapool in ${get_disktype}b" >> $outfile
			echo "clearpart --all --initlabel" >> $outfile
			echo "part swap --fstype=\"swap\" --size=$swap_size --ondisk=${get_disktype}a">> $outfile
			echo "part /boot --fstype="ext4" --size=$boot_size --ondisk=${get_disktype}a">> $outfile
			echo "part /biosboot --fstype="biosboot" --size=$biosboot_size --ondisk=${get_disktype}a">> $outfile
			echo "part / --fstype=\"ext4\" --grow --size=$root_size --ondisk=${get_disktype}a">> $outfile
			echo "part /home --fstype="ext4" --size=$home_size --grow --ondisk=${get_disktype}b">> $outfile

	else
		##-------------------1 drives-------------------##
			echo "# 1 Disk partitioning information,datapool in ${get_disktype}a" >> $outfile
			echo "clearpart --all --initlabel" >> $outfile
			echo "part swap --fstype=\"swap\" --size=$swap_size  --ondisk=${get_disktype}a">> $outfile
			echo "part /boot --fstype="ext4" --size=$boot_size --ondisk=${get_disktype}a">> $outfile
			echo "part /biosboot --fstype="biosboot" --size=$biosboot_size --ondisk=${get_disktype}a">> $outfile
			echo "part / --fstype=\"ext4\" --size=$root_size --ondisk=${get_disktype}a">> $outfile
			echo "part /home --fstype="ext4" --size=$home_size --grow --ondisk=${get_disktype}a">> $outfile
	fi
}

CheckDiskType() {
	disktype="default"
	disknu=0
	for t in "vd" "sd" "hd";do
		fdisk -l|grep -E "/dev/${t}[a-z]:" >>/dev/null
		if [ $? -eq 0 ];then
			if [ `fdisk -l|grep -E "/dev/${t}[a-z]:"|wc -l` -gt 1 ];then
					disknu=`fdisk -l|grep -E "/dev/${t}[a-z]:"|wc -l`
			else
					disknu=1
			fi
		disktype="$t"
		fi
	done
	CreatePartFile $disktype $disknu

}
CheckDiskType
