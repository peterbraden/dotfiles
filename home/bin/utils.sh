

remove_tortuga_zfs_snapshots() {
  zfs list -H -t snapshot -o name -S creation -d1 /atlantic/tortuga | xargs -n 1 sudo zfs destroy -r
}
