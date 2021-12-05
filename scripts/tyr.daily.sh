#! /bin/bash

# Daily admin tasks on Tyr
# - ZFS Maintenance
# - Backups
# - Status email



# $1 folder
# $2 bucket name
# $3 rclone remote
function backup_folder () {
  FOLDER="$1"
  UNIQUE="35B03Z06L"
  BUCKET_PREFIX="peterbraden-$UNIQUE"
  BUCKET_NAME="$BUCKET_PREFIX-$2"
  SERVICE="$3"

  echo "Backing up $FOLDER to $SERVICE:$BUCKET_NAME"
  echo "rclone sync $FOLDER $SERVICE:$BUCKET_NAME --dry-run"
}


# Send daily email digest
echo "====================================================="
echo "      TYR DAILY UPDATE          "
echo "====================================================="

## Git diff of notes in last day.
## ZFS Diff since last snapshot

## ZFS Status
  # zpool status
  # zfs list

## Backup Status


backup_folder /atlantic/tortuga tortuga aws-encrypted
#backup_folder /atlantic/photos/2004 photos-2004 aws




# Trigger jobs
## ZFS Snapshots
## ZFS Scrub
  # zpool scrub atlantic
