Script to backup all my iMessages outside of iCloud. As of writing this, iMessage takes up about 120GB of my 200GB of iCloud. I'm going to switch configuration from `save forever -> delete after 1 year`.  

This uses https://github.com/ReagentX/imessage-exporter to export all my chat data to txt files, and then syncs all that data to an ~~S3 bucket~~ Google Drive folder as an archive. 

I have this configured to run daily with (LaunchD)[https://www.launchd.info/] configuration. I'm running this on my personal machine which may be close and asleep most of the time, and crontab cannot wake the machine up to run the script. LaunchD _does_ allow for that, so I'm using it.

```zsh
# create the file in LaunchAgents
> touch ~/Library/LaunchAgents/com.pwc.imessage-backup.plist

# load the launch config
> launchctl load ~/Library/LaunchAgents/com.pwc.imessage-backup.plist

# find the status
> launchctl list | grep com.pwc.imessage-backup

# unload it if you need to make a change
> launchctl load ~/Library/LaunchAgents/com.pwc.imessage-backup.plist
```

This script is entirely specific to my setup, but you could easily tweak it for yourself.