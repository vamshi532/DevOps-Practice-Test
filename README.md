
#  Automated Backup System (Bash Script)

## A. Project Overview

This project is a **Bash-based backup automation tool**.  
It helps you automatically back up important folders on your computer.

The script:
- Compresses the selected folder into a `.tar.gz` backup file  
- Adds a checksum file to verify backup integrity  
- Deletes old backups automatically to save storage  
- Logs all backup actions for tracking  

### Why is it Useful?
Manual backups take time and can be forgotten.  
This script makes sure your files are **safely backed up** on schedule without manual work.  
It’s simple, lightweight, and works on any Linux system.

---

## B. How to Use It

### 1️ Installation Steps
```bash
git clone https://github.com/<your-username>/DevOps-Practice-Test.git
cd DevOps-Practice-Test
chmod +x backup.sh
````

### 2️ Edit Configuration

Open `backup.config` to set your own paths:

```
BACKUP_DESTINATION=/home/user/backups
EXCLUDE_PATTERNS=".git,node_modules,.cache"
DAILY_KEEP=7
WEEKLY_KEEP=4
MONTHLY_KEEP=3
```

###  Basic Usage

Run the script with the folder you want to back up:

```bash
./backup.sh ~/my-project
```

### 4️ Command Options

| Command                               | Description                                     |
| ------------------------------------- | ----------------------------------------------- |
| `./backup.sh <folder>`                | Creates a new backup of that folder             |
| `./backup.sh --dry-run <folder>`      | Shows what will happen without creating backups |
| `./backup.sh --restore <backup-file>` | Restores a backup to its original location      |

### 5️ Output

* Backups are saved in: `~/backups`
* Logs are saved in: `~/backups/backup.log`

---

## C. How It Works

###  Rotation Algorithm

The script uses a **daily, weekly, and monthly rotation** system:

* Keeps the **last 7 daily backups**
* Keeps the **last 4 weekly backups**
* Keeps the **last 3 monthly backups**
* Deletes anything older automatically

This prevents your storage from filling up but still keeps both recent and long-term restore points.

###  Checksum Creation

After each backup, the script creates a checksum file:

```bash
sha256sum backup-2025-11-03-1040.tar.gz > backup-2025-11-03-1040.tar.gz.sha256
```

This helps confirm the backup is not corrupted.

###  Folder Structure Example

```
/home/vamshi/backups
 ├── backup-2025-11-03-0833.tar.gz
 ├── backup-2025-11-02-1201.tar.gz
 ├── backup-2025-10-27-weekly.tar.gz
 ├── backup-2025-10-01-monthly.tar.gz
 ├── backup.log
```

---

## D. Design Decisions

1. **Configuration File:**
   All paths and limits are stored in a config file to make the script reusable.

2. **Timestamped Backups:**
   Each backup has a unique date and time in the name.

3. **Rotation System:**
   Instead of keeping every backup forever, the script automatically removes old ones.

4. **Logging:**
   A log file records every backup action for easy tracking.

5. **Simple Bash Design:**
   The script uses common Linux tools like `tar`, `find`, and `sha256sum`, making it easy to run anywhere.

### Challenges Faced

* Handling old backups safely
* Making sure backups don’t run twice at the same time
* Automating cleanup without deleting needed files

### How They Were Solved

* Added a lock file to prevent multiple runs
* Used date-based filenames and checksum verification
* Wrote cleanup rules to keep specific daily, weekly, and monthly backups

---

## E. Testing

### Test Folder

```bash
mkdir ~/my-project
echo "Hello world" > ~/my-project/file1.txt
echo "Important data" > ~/my-project/file2.txt
```

### Run Backup

```bash
./backup.sh ~/my-project
```

### Expected Output

```
 Backup created: /home/vamshi/backups/backup-2025-11-05-1010.tar.gz
 Old backups cleaned
 Log updated: /home/vamshi/backups/backup.log
```

### Example Log

```
[2025-11-05 10:10:23] INFO: Starting backup of /home/vamshi/my-project
[2025-11-05 10:10:48] SUCCESS: Backup created successfully
[2025-11-05 10:10:49] INFO: Checksum verified
[2025-11-05 10:10:52] INFO: Deleted old backup: backup-2025-09-01.tar.gz
```

---

## F. Known Limitations

| Limitation                  | Description                              |
| --------------------------- | ---------------------------------------- |
| No GUI                      | Script is command-line only              |
| Local Backups Only          | Doesn’t upload to cloud yet              |
| Manual Restore              | Needs a separate restore script          |
| Large Backups May Take Time | Compression can be slow for huge folders |

---

 **In summary:**
This project automates Linux backups safely and efficiently.
It’s easy to use, fully customizable, and a great example of practical Bash scripting and DevOps automation.

````

---

###  Tip:
You can also add screenshots in Markdown like this:
```markdown
![Backup Example](backup-example.png)
![Full Output](full-output.png)
````

These should be placed **below the project title or in the testing section** once your images are inside the same folder.

---

Would you like me to make a **version with your images inserted and formatted nicely for GitHub preview** (with emojis and clean layout)?
