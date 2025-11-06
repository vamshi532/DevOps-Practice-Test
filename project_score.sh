#!/bin/bash
# Automated Project Scoring Script for Backup System
# Author: vamshi532

SCORE=0
TEST_FOLDER=~/my-project
BACKUP_DIR=~/backups
RESTORE_DIR=~/restore-test

echo "🧩 Starting Automated Evaluation of Backup Project..."
echo "-----------------------------------------------------"

# 1️⃣ Check if script runs successfully
echo "▶ Testing normal backup..."
mkdir -p "$TEST_FOLDER"
echo "data test" > "$TEST_FOLDER/file1.txt"
./backup.sh "$TEST_FOLDER" >/tmp/backup_output.txt 2>&1
if grep -q "Backup created" /tmp/backup_output.txt; then
  echo "✅ Backup created successfully [+30]"
  SCORE=$((SCORE+30))
else
  echo "❌ Backup failed"
fi

# 2️⃣ Check for checksum file
echo "▶ Checking checksum..."
if ls "$BACKUP_DIR"/*.sha256 >/dev/null 2>&1; then
  echo "✅ Checksum generated [+5]"
  SCORE=$((SCORE+5))
else
  echo "❌ No checksum file found"
fi

# 3️⃣ Check logging
echo "▶ Checking logs..."
if grep -q "Backup created" "$BACKUP_DIR/backup.log" 2>/dev/null; then
  echo "✅ Log entry found [+5]"
  SCORE=$((SCORE+5))
else
  echo "❌ No log entry found"
fi

# 4️⃣ Test dry-run mode
echo "▶ Testing dry-run..."
./backup.sh --dry-run "$TEST_FOLDER" >/tmp/dryrun_output.txt 2>&1
if grep -q "DRY RUN" /tmp/dryrun_output.txt || grep -q "Would backup" /tmp/dryrun_output.txt; then
  echo "✅ Dry run works [+5]"
  SCORE=$((SCORE+5))
else
  echo "❌ Dry run failed"
fi

# 5️⃣ Test error handling
echo "▶ Testing error handling..."
./backup.sh /invalid/path >/tmp/error_output.txt 2>&1
if grep -q "Error" /tmp/error_output.txt; then
  echo "✅ Error handling works [+10]"
  SCORE=$((SCORE+10))
else
  echo "❌ Missing error message"
fi

# 6️⃣ Test cleanup / rotation
echo "▶ Testing rotation (creating multiple backups)..."
for i in {1..10}; do
  echo "change $i" >> "$TEST_FOLDER/file1.txt"
  ./backup.sh "$TEST_FOLDER" >/dev/null 2>&1
done
COUNT=$(ls "$BACKUP_DIR"/backup-*.tar.gz | wc -l)
if [ "$COUNT" -le 7 ]; then
  echo "✅ Rotation works, old backups removed [+10]"
  SCORE=$((SCORE+10))
else
  echo "❌ Rotation not working properly"
fi

# 7️⃣ Test restore mode
echo "▶ Testing restore..."
LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/backup-*.tar.gz | head -n 1)
mkdir -p "$RESTORE_DIR"
./backup.sh --restore "$LATEST_BACKUP" --to "$RESTORE_DIR" >/tmp/restore_output.txt 2>&1
if grep -q "Restore" /tmp/restore_output.txt || [ "$(ls -A $RESTORE_DIR)" ]; then
  echo "✅ Restore works [+10]"
  SCORE=$((SCORE+10))
else
  echo "❌ Restore failed"
fi

# 8️⃣ Check configuration file
echo "▶ Checking config file..."
if grep -q "BACKUP_DEST" backup.config && grep -q "DAILY_KEEP" backup.config; then
  echo "✅ Config parameters found [+10]"
  SCORE=$((SCORE+10))
else
  echo "❌ Config incomplete"
fi

echo "-----------------------------------------------------"
echo "🎯 Your Project Score: $SCORE / 100"
echo "-----------------------------------------------------"

if [ "$SCORE" -ge 90 ]; then
  echo "🏆 Excellent work! Grade: A+"
elif [ "$SCORE" -ge 75 ]; then
  echo "✅ Great job! Grade: A"
elif [ "$SCORE" -ge 60 ]; then
  echo "🙂 Passed! Grade: B"
else
  echo "⚠️ Needs improvement. Grade: C"
fi

echo "-----------------------------------------------------"
