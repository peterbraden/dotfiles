#!/usr/bin/env bash
# Tested with rclone v1.56.2

# Creates remote 'aws' for s3
create_s3_remote(){
  if rclone listremotes | grep -qx 'aws:'; then
    echo "Remote already exists"
  else
    echo "Remote 'aws' not found - creating..."
    rclone config create aws s3 provider=AWS env_auth=true region=us-east-1 acl=private
  fi
}

#$1 = name
create_bucket(){
  NAME=$1
  rclone mkdir aws:$NAME
}

create_encrypted_s3_bucket(){
  #NB This doesn't work yet, run config manually through the menus to get the 
  #   Passphrase generation etc.
  # (return, not exit: this file is sourced)
  return 1
  NAME=$1
  create_s3_remote
  create_bucket $NAME
  echo "Creating crypt $NAME"
  rclone config create "$NAME" crypt --crypt-remote=aws:$NAME
}


