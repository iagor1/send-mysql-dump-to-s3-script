#!/bin/bash
# Automatic backup script

generate_filename() {
  echo backup-auto-$(date +'%d-%m-%Y-%Hh').sql.gz
}

# Vars
BACKUP_FILE=$(generate_filename)
BACKUP_LOCATION='/tmp/'
BUCKET_NAME='bucket_name'
DESTINATION_IN_BUCKET='path_inside_bucket/'
export AWS_ACCESS_KEY_ID="xxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxx"
export AWS_DEFAULT_REGION="us-east-1"

docker exec mariadb mysqldump -u user --password=pwd database_name | gzip > $BACKUP_LOCATION$BACKUP_FILE
echo generating backup $(date +'%d-%m-%Y-%Hh')
echo "backup name: $BACKUP_FILE, file in $BACKUP_LOCATION"
echo "backup file moved to $BACKUP_LOCATION"

function errecho() {
  printf "%s\n" "$*" 1>&2
}


function copy_file_to_bucket() {

  response=$(aws s3api put-object \
    --bucket "$BUCKET_NAME" \
    --body "$BACKUP_LOCATION$BACKUP_FILE" \
    --key "$DESTINATION_IN_BUCKET$BACKUP_FILE")

  # shellcheck disable=SC2181
  echo "response: $response"
  if [[ ${?} -ne 0 ]]; then
    errecho "ERROR: AWS reports put-object operation failed.\n$response"
    return 1
  else
    echo "Backup $BACKUP_FILE successfully copied to bucket $BUCKET_NAME in $DESTINATION_IN_BUCKET"
  fi
}

copy_file_to_bucket
