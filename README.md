# HAL
HAL (HAL Ain’t a LIMS) is a semi-automatic system for tracking and processing NGS sequencing runs on Illumina DNA sequencers from a remote server. All the code for code for HAL (except for user modules, for privacy reasons) can be found on HAL’s GitHub repository.
Dependencies:
•	Apache server (with configured htaccess module) and sendmail: Used for sending password protected links through email for user access to the NGS data. HAL expects the root of the Apache server in /var/www/
•	Cron: Linux’s native task scheduler for periodic executions of HAL.
•	SMB server: Used for the transfer of the NGS data from the Illumina sequencers to the remote server in real time.
•	Illumina’s bcl2fastq: for demultiplexation of the raw BCL files into fastq files.
HAL’s main script is meant to be used in one of 2 ways: executed in Linux’s command line as a bash script with the appropriate arguments depending on what’s being processed, or executing it on a scheduled way using Linux’s Cron task scheduler.
HAL can operate in one of 5 modes (addressed in sections below):
•	New User: Add a new user to the HAL system.
•	Reset Password: Reset the password of an existing HAL user.
•	Monitor: Monitor for new runs happening in the Illumina sequencers.
•	Janitor: Archive, send warnings and delete old NGS data in the server.
•	Run Processing: Process NGS runs’ data and send it to the user.
HAL’s version control and history/log changed is done through the GitHub repository.
HAL is developed and maintained by Dr. Ezequiel Martin.
