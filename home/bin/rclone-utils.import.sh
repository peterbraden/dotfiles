#!/usr/bin/env bash
# Tested with rclone v1.56.2

# Creates remote 'aws' for s3
create_s3_remote(){
  CONFIG=$(rclone config file | sed 's/Configuration file is stored at://g' | tr '\n' ' ' | sed 's/ //g')
  MATCH=$(grep '\[aws\]' ${CONFIG})
  if [ -z "$MATCH" ]; then
    echo "Remote 'aws' not found - creating..."
    echo "\n[aws]\ntype = s3\nprovider = AWS\nenv_auth = true\nregion = us-east-1\nacl = private" >> ${CONFIG}
  else
    echo "Remote already exists"
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
  exit 1
  NAME=$1
  create_s3_remote
  create_bucket $NAME
  echo "Creating crypt $NAME"
  rclone config create "$NAME" crypt --crypt-remote=aws:$NAME
}


