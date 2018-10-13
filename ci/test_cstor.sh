#!/bin/bash
set -x

trap 'cleanup' INT

ZFS_IMG="openebs/cstor-pool:ci"
ISTGT_IMG="openebs/cstor-istgt:ci"
ZPOOL="/usr/local/bin/zpool"
ZFS="/usr/local/bin/zfs"
ISCSIADM=iscsiadm
CONF_FILE=/tmp/istgt/istgt.conf

CONTROLLER_IP="172.18.0.2"
REPLICA_IP1="172.18.0.3"
REPLICA_IP2="172.18.0.4"
REPLICA_IP3="172.18.0.5"

CONTROLLER_PORT="6060"

size=1G

install_prerequisites() {
	which iscsiadm
	if [ ! -z $? ]; then
		apt-get install -y open-iscsi;
	fi
}

cleanup() {
	cleanup_test_env
	exit
}

cleanup_istgt() {
	docker stop $controller_id
	docker rm $controller_id
}

cleanup_replicas() {
	sudo docker stop $replica1_id $replica2_id $replica3_id
	sudo docker rm $replica1_id $replica2_id $replica3_id
}

cleanup_test_env() {
	cleanup_replicas
	cleanup_istgt
	rm -rf /tmp/vol*
	rm -rf /mnt/store
	rm -rf /tmp/istgt
	rm -rf /tmp/istgtvol
}

setup_test_env() {
	rm -rf /tmp/vol*
	docker network create --subnet=172.18.0.0/16 stg-net
	mkdir -p /tmp/vol1 /tmp/vol2 /tmp/vol3
	mkdir -p /tmp/store
	mkdir -p /tmp/istgt
	mkdir -p /tmp/istgtvol
	cp istgt/src/istgt.conf istgt/src/istgtcontrol.conf /tmp/istgt/
	sed -i "s|TargetName.*|TargetName volume|g" $CONF_FILE
	sed -i "s|ReplicationFactor.*|ReplicationFactor 3|g" $CONF_FILE
	sed -i "s|ConsistencyFactor.*|ConsistencyFactor 2|g" $CONF_FILE
	sed -i "s|TargetAlias.*|TargetAlias nicknamefor-volume|g" $CONF_FILE
	sed -i "s|Portal UC1.*|Portal UC1 $CONTROLLER_IP:3261|g" $CONF_FILE
	sed -i "s|Portal DA1.*|Portal DA1 $CONTROLLER_IP:3260|g" $CONF_FILE
	sed -i "s|Netmask localhost.*|Netmask $CONTROLLER_IP\/8|g" $CONF_FILE
	sed -i "s|LUN0 Storage.*|LUN0 Storage  $size 32k|g" $CONF_FILE
	touch /tmp/istgt/auth.conf /tmp/istgt/logfile
	truncate -s 20G /tmp/vol1/zpool.img /tmp/vol2/zpool.img /tmp/vol3/zpool.img
	truncate -s 20G /tmp/istgtvol/volume
	logout_of_volume
	start_istgt
}

start_istgt() {
	controller_id=$(docker run -d --net stg-net --ip "$CONTROLLER_IP" -e externalIP="$CONTROLLER_IP" -v /tmp/istgtvol:/tmp/istgtvol -v /tmp/istgt:/usr/local/etc/istgt $ISTGT_IMG)
	echo $controller_id
}


start_replica() {
	replica_id=$(docker run -d --net stg-net --ip "$2" -v /tmp/"$3"/:/vol $ZFS_IMG)
	sleep 10
	docker exec $replica_id $ZPOOL create -f replica_pool /vol/zpool.img
	docker exec $replica_id $ZFS create -V1g -b 4k -s -o io.openebs:targetip="$1"  replica_pool/volume
	echo "$replica_id"
}

restart_replica() {
	replica_id=$(docker run -d -it --net stg-net --ip "$2" -v /tmp/"$3":/vol $ZFS_IMG)
	echo "$replica_id"
}

login_to_volume() {
	$ISCSIADM -m discovery -t st -p $1
	$ISCSIADM -m node -l
}

logout_of_volume() {
	$ISCSIADM -m node -u
	$ISCSIADM -m node -o delete
}

get_scsi_disk() {
	device_name=$($ISCSIADM -m session -P 3 |grep -i "Attached scsi disk" | awk '{print $4}')
	i=0
	while [ -z $device_name ]; do
		sleep 5
		device_name=$($ISCSIADM -m session -P 3 |grep -i "Attached scsi disk" | awk '{print $4}')
		i=`expr $i + 1`
		if [ $i -eq 10 ]; then
			echo "scsi disk not found";
			exit;
		else
			continue;
		fi
	done
}

write_and_verify_data(){

	login_to_volume "$CONTROLLER_IP:3260"
	echo "logged in"
	get_scsi_disk
	if [ "$device_name"!="" ]; then
		mkfs.ext2 -F /dev/$device_name
		
		if [ $? -ne 0 ]; then 
			echo "mkfs failed for $device_name" && exit 1
		fi

		mkdir /mnt/store
		mount /dev/$device_name /mnt/store

		if [ $? -ne 0 ]; then 
			echo "mount for $device_name" && exit 1
		fi

		dd if=/dev/urandom of=file1 bs=4k count=10000
		hash1=$(md5sum file1 | awk '{print $1}')
		cp file1 /mnt/store/
		hash2=$(md5sum /mnt/store/file1 | awk '{print $1}')
		if [ "$hash1" = "$hash2" ]; then 
			echo "DI Test: PASSED"
		else
			echo "DI Test: FAILED"; exit 1
		fi

		umount /mnt/store
		logout_of_volume
		sleep 5
	else
		echo "Unable to detect iSCSI device, login failed"; exit 1
	fi
}

run_data_integrity_test() {
	setup_test_env

	replica1_id=$(start_replica "$CONTROLLER_IP" "$REPLICA_IP1" "vol1")
	replica2_id=$(start_replica "$CONTROLLER_IP" "$REPLICA_IP2" "vol2")
	replica3_id=$(start_replica "$CONTROLLER_IP" "$REPLICA_IP3" "vol3")

	sleep 15
	write_and_verify_data

	docker stop $replica1_id
	sleep 5
	write_and_verify_data

	replica1_id=$(restart_replica "$CONTROLLER_IP" "$REPLICA_IP1" "vol1")
	sleep 5
	write_and_verify_data

	cleanup_test_env
}

install_prerequisites
run_data_integrity_test
exit 0
