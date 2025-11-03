# Automated Backup System

![Backup Example](backup-example.png)

## A. Project Overview

This project is a Bash-based automated backup system designed to safely and efficiently back up important files and folders on a Linux system.

The script automatically:

* Creates compressed backup archives with timestamps
* Verifies backups using checksum files
* Logs all actions performed
* Cleans older backups based on retention rules

### Why Is This Useful?

* Prevents data loss
* Automates routine backup tasks
* Saves storage space by removing older backups
* Easy to configure and run

## B. How to Use It

### Installation

1. Clone or download this project.
2. Make the script executable:

chmod +x backup.sh

3. Edit the configuration in `backup.config` if needed.

### Basic Usage

Run the script by providing the folder you want to back up:

./backup.sh /home/vamshi/my-project

### Output

* Backups are stored in: `/home/vamshi/backups`
* Log file is stored at: `/home/vamshi/backups/backup.log`

---

## C. How It Works

### 1. Backup Creation

The script creates a compressed `.tar.gz` backup of the folder provided by the user. The backup file name includes a timestamp for uniqueness.

### 2. Backup Storage Location

Backups are saved in the destination directory defined in `backup.config`. If the folder doesn't exist, the script creates it.

C. How It Works

1. Backup Creation

The script compresses the target directory into a timestamped .tar.gz archive.

2. Checksum Verification

For every backup created, a .sha256 checksum file is also generated to verify the backup's data integrity.

3. Logging

Every backup event is recorded in a log file, including success, failure, and cleanup actions.

4. Retention / Rotation Policy

The script retains backups based on the following rules:

Daily backups → Keep last 7 days

Weekly backups → Keep last 4 weeks

Monthly backups → Keep last 3 months

Backups older than these limits are automatically deleted.

Example Backup Folder Structure

/home/vamshi/backups
 ├── backup-2025-11-03-0833.tar.gz
 ├── backup-2025-11-03-0838.tar.gz
 ├── backup-2025-11-03-0843.tar.gz
 └── backup.log

## D. Design Decisions

1. **Separate Configuration File**
   The backup settings are stored in `backup.config` instead of being hardcoded. This makes the script easier to maintain and reuse.

2. **Timestamp-Based Backup Names**
   Each backup uses the current date and time in its filename. This ensures all backups are uniquely identifiable.

3. **Automatic Backup Directory Creation**
   If the backup directory does not exist, the script creates it. This prevents errors when running on a new system.

4. **Simple Rotation Policy**
   The script keeps only the latest 7 backups. Older backups are deleted automatically to save disk space.

5. **Logging**
   All script actions are logged in `backup.log`, making it easy to review backup history.

6. **Learning Approach**
   This script was built step-by-step, fixing errors while learning. This helped in understanding Bash scripting more clearly.

## E. Testing

A sample project folder was created to test the script:

mkdir ~/my-project
echo "hello world" > ~/my-project/file1.txt
echo "important data" > ~/my-project/file2.txt

The backup script was executed:

./backup.sh ~/my-project

**Expected Behavior:**

* Expected Output
* Backup created in /home/vamshi/backups
* .sha256 checksum generated
* Log entry added into backup.log
* Old backups deleted if retention limits exceeded

## F. Known Limitations

Currently runs manually unless automated with cron.
Does not yet include a restore script.
Cannot back up remote systems without SSH/rsync integration.




