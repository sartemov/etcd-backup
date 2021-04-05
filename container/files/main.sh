#!/bin/sh -xe

#
# Defaults setup
#
S3CMD=/usr/bin/s3cmd
S3FCG=/opt/.s3cfg
DATE=`/bin/date '+%Y-%m-%d'`

if [ -z "${BUCKET}" ]; then
    BUCKET=etcd-backup/ocp
    echo "Set bucket to default value: $BUCKET"
fi

if [ -z "${ETCD_BACKUP_MASTER_PATH}" ]; then
    ETCD_BACKUP_MASTER_PATH=/home/core/assets/backup
    echo "Set backup destination to default value: $ETCD_BACKUP_MASTER_PATH"
fi

if [ -z "${SYNC_COMMAND}" ]; then
    SYNC_COMMAND="${S3CMD} --config=${S3FCG} sync ${HOST_PATH}/${ETCD_BACKUP_MASTER_PATH} s3://${BUCKET}/${DATE}/"
    echo "Set sync command to default value: $SYNC_COMMAND"
fi

# Make etcd backup
chroot ${HOST_PATH} ${ETCD_BACKUP_SCRIPT} ${ETCD_BACKUP_MASTER_PATH} 

# Copy backup files (etcd and static pods) to S3 storage and prune backup files
${SYNC_COMMAND} && rm -f ${HOST_PATH}/${ETCD_BACKUP_MASTER_PATH}/*.db ${HOST_PATH}/${ETCD_BACKUP_MASTER_PATH}/*.tar.gz
