start "Backup" cmd /k python backup.py --user %~1 --pw %~2
start "Recovery" cmd /k python recover.py --user %~1 --pw %~2