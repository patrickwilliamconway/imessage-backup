#!/bin/zsh

ROOT_DIR="/Users/patrickconway/imessage-backup"
# Define base directory for exports
BASE_EXPORT_DIR="$ROOT_DIR/backups/"
LOG_FILE="$ROOT_DIR/log_file.log"
S3_BUCKET="s3://pwc-imessage-backup"
LAST_BACKUP_FILE="$ROOT_DIR/last_backup_date.txt"

# Create log file directory if it doesn't exist
mkdir -p "$ROOT_DIR"

# Get the current date in YYYY-MM-DD format
CURRENT_DATE=$(date +%F)

log() {
  local message=$1
  echo "[$(date)] $message"
}

perform_backup() {
  local export_dir="$BASE_EXPORT_DIR"

  # Log the start of the backup
  log "Starting iMessage export and sync"

  log "Removing all files in $export_dir so they can be regenerated"
  rm -rf $export_dir

  # Run imessage-exporter
  log "Running exporter tool: imessage-exporter -f txt -o $export_dir -a macOS" 
  if imessage-exporter -f txt -o "$export_dir" -a macOS ; then
    log "Successfully exported iMessages to $export_dir" 
  else
    log "Error: Failed to export iMessages for $backup_date" 
    return 1
  fi

  log "Syncing to S3: aws s3 --profile imessage-backup sync "$ROOT_DIR" "$S3_BUCKET/"" 
  if aws s3 --profile imessage-backup sync "$ROOT_DIR" "$S3_BUCKET/" ; then
    log "Successfully synced messages to $S3_BUCKET" 
  else
    log "Error: Failed to sync messages to S3 bucket" 
    return 1
  fi

  log "Completed iMessage export and sync" 
}



main() {
  log "Starting imessage-backup script"

  # Check if the last backup date file exists
  if [[ -f "$LAST_BACKUP_FILE" ]]; then
    LAST_BACKUP_DATE=$(cat "$LAST_BACKUP_FILE")
      log "Last run on $LAST_BACKUP_DATE"
  fi
  

  if perform_backup ; then
    # Update the last backup date file
    echo "$CURRENT_DATE" > "$LAST_BACKUP_FILE"
  else
    log "Error: Backup failed for $CURRENT_DATE"
    exit 1
  fi
} 

main | tee -a