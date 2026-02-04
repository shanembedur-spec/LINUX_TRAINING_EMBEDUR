#!/bin/bash

# --- Step 1: Accept arguments ---
SRC_DIR=$1
BACKUP_DIR=$2
EXT=$3

# --- Step 2: Validate inputs ---
if [ -z "$SRC_DIR" ] || [ -z "$BACKUP_DIR" ] || [ -z "$EXT" ]; then
  echo "Usage: $0 <source_dir> <backup_dir> <extension>"
  exit 1
fi

# --- Step 3: Check source directory ---
if [ ! -d "$SRC_DIR" ]; then
  mkdir -p "$SRC_DIR" || { echo "Failed to create source dir"; exit 1; }
fi

# --- Step 4: Find files with given extension ---
files=( $(find "$SRC_DIR" -type f -name "*$EXT") )

if [ ${#files[@]} -eq 0 ]; then
  echo "No files found in source dir"
  exit 0
fi

# --- Step 5: Prepare backup directory ---
mkdir -p "$BACKUP_DIR"

# --- Step 6: Copy files ---
for f in "${files[@]}"; do
  cp -u "$f" "$BACKUP_DIR"
  echo "Backing up: $f"
done

# --- Step 7: Export count ---
export BACKUP_COUNT=${#files[@]}

# --- Step 7.1: Calculate total size of backed-up files ---
TOTAL_SIZE=$(du -ch "${files[@]}" 2>/dev/null | grep total$ | awk '{print $1}')

# --- Step 8: Create report ---
REPORT="$BACKUP_DIR/backup_report.log"
{
  echo "Backup Report - $(date)"
  echo "Total files copied: $BACKUP_COUNT"
  echo "Total size of files backed up: $TOTAL_SIZE"
  echo "Files:"
  printf "%s\n" "${files[@]}"
  echo "Backup directory: $BACKUP_DIR"
} > "$REPORT"

echo "Backup complete. Report saved at $REPORT"
