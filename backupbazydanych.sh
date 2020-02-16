#!/bin/sh

timestamp=$(date +'%Y-%m-%d_%H:%M:%S')
filename="db_backup_$timestamp".gz
backupfolder="/home/dawid/backuptst"
fullpathbackupfile="$backupfolder/$filename"
logfile="${backupfolder}/backup_log_$timestamp".log

echo "mysqldump started at $timestamp" >> "$logfile"
wynik=`/usr/bin/mysqldump --user=dawid --password=Dawid12345., --default-character-set=utf8 mydatabase 2>>$logfile`
status=$?
if [ $status -eq 0 ]; then
	echo $timestamp ze skryptu OK | tee -a $logfile
else
	echo $timestamp DUPA | tee -a $logfile
	exit $status 
fi


echo $wynik | /bin/gzip > "$fullpathbackupfile"


file="$fullpathbackupfile"
if [ -f "$file" ]
then
	echo "$file found." | tee -a $logfile
	find "$backupfolder" -name db_backup_* -mtime +8 -exec rm {} \;
echo "old files deleted" >> "$logfile"
echo "operation finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"
exit 0

else
	echo "Operation has failed." >> "$logfile"
	echo "Old files are still exist $(date +'%d-%m-%Y  %H:%M:%S')">>"$logfile"
	echo "*****************" >> "$logfile"

	echo "$file not found."
echo "*****************" >> "$logfile"
fi
