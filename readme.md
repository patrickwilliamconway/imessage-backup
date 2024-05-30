Script to backup all my iMessages to S3. 

This uses https://github.com/ReagentX/imessage-exporter to export all my chat data to txt files, and then syncs all that data to an S3 bucket as an archive. 

I have this configured to run daily:
```zsh
crontab -l
@daily /Users/patrickconway/Documents/src/imessage-backup/imessage-backup.sh
```

This script is entirely specific to my setup, but you could easily tweak it for yourself.