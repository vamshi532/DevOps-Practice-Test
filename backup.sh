#!/bin/bash

# Load config
source "$(dirname "$0")/backup.config"

TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
PROJECT_PATH="$1"
RESTORE_FILE="$2"

LOG_FILE="$BACKUP_DEST/backup.log"

# -----------------------
# Restore Mode
# -----------------------
if [[ "$1" == "--restore" ]]; then
    if [[ ! -f "$2" ]]; then
        echo "❌ Backup file not found!"
        exit 1
    fi

    echo "♻ Restoring backup..."
    tar -xzf "$2" -C /
    echo "✅ Restore Completed: $2" | tee -a "$LOG_FILE"
    exit 0
fi

# -----------------------
# Dry Run Mode
# -----------------------
if [[ "$1" == "--dry-run" ]]; then
    echo " DRY RUN: Checking what would be deleted..."
    ls -1 "$BACKUP_DEST" | sort
    echo "No changes were made."
    exit 0
fi

# -----------------------
# Backup Mode
# -----------------------
if [[ -z "$PROJECT_PATH" ]]; then
    echo "Usage:"
    echo "./backup.sh <project-folder>"
    echo "./backup.sh --restore <backup-file-path>"
    echo "./backup.sh --dry-run"
    exit 1
fi

mkdir -p "$BACKUP_DEST"

BACKUP_NAME="backup-$TIMESTAMP.tar.gz"
BACKUP_FILE="$BACKUP_DEST/$BACKUP_NAME"

# Exclusion options
EXCLUDE_ARGS=""
IFS=',' read -ra EXCLUDES <<< "$EXCLUDE_PATTERNS"
for pattern in "${EXCLUDES[@]}"; do
    EXCLUDE_ARGS+=" --exclude=$pattern"
done

echo " Creating backup..."
tar -czf "$BACKUP_FILE" $EXCLUDE_ARGS "$PROJECT_PATH" 2>/dev/null

if [[ $? -ne 0 ]]; then
    echo "❌ Backup failed."
    exit 1
fi

echo "✅ Backup created: $BACKUP_FILE" | tee -a "$LOG_FILE"

# -----------------------
# Cleanup old backups
# -----------------------
echo " Cleaning old backups..."

# Keep last DAILY_KEEP backups
ls -tp "$BACKUP_DEST"/backup-*.tar.gz | tail -n +$((DAILY_KEEP + 1)) | xargs -I {} rm -- {}

echo "✅ Cleanup Done." | tee -a "$LOG_FILE"

