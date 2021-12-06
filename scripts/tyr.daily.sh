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
  backup_folder_mixed "$SERVICE:$BUCKET_NAME"
}

# Backup folder to '$2'
# $1 FOLDER
# $2 remote:bucket
function backup_folder_mixed () {
  FOLDER="$1"
  DEST="$2"
  echo "# Backing up $FOLDER to $DEST"
  rclone sync --fast-list $FOLDER $DEST -v #--progress

}

# $1 Dataset
# $2 Service
backup_dataset () {
  DATASET="$1"
  SERVICE="$2"
  zfs list -H -r -o name $DATASET | while read -r line; do
    if [ "$line" != "$DATASET" ]; then
      DATASET_NAME="$(echo $line | cut -d'/' -f2)"
      FOLDER_NAME="$(echo $line | cut -d'/' -f3)"
      backup_folder $line "$DATASET_NAME-$FOLDER_NAME" $SERVICE
    fi
  done
}

# $1 DATASET
zfs_diff_last_day () {
  DATASET="$1"
  TODAY=$(date)
  YESTERDAY=$(date --date="$TODAY - 1 day" --iso="date")
  SNAPSHOT_NAME=$(zfs list -o name -t snapshot $DATASET | grep zfs-auto-snap_daily | grep $YESTERDAY)
  echo "Differences between $(date --iso="date") and $YESTERDAY for $DATASET"
  zfs diff $SNAPSHOT_NAME
}

main () {
  # Send daily email digest
  echo "====================================================="
  echo "      TYR DAILY UPDATE          "
  echo "====================================================="

  ## Git diff of notes in last day.
  # TODO

  ## ZFS Diff since last snapshot
  zfs_diff_last_day atlantic/photos
  echo " "

  ## ZFS Status
  zpool status
  echo " "
  zfs list
  echo " "

  ## Backup Status

  backup_folder /atlantic/tortuga tortuga bb-encrypted

  #backup_dataset atlantic/photos bb
  backup_folder /atlantic/photos/2004 photos-2004 bb




  # Trigger jobs
  ## ZFS Snapshots
  ## ZFS Scrub
    # zpool scrub atlantic
}

backup_folder_mixed /atlantic/tortuga bb-encrypted-tortuga:

