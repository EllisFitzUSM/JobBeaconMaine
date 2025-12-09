import subprocess
import os
import time
from datetime import datetime
import argparse as ap 

argparser = ap.ArgumentParser(description='Backup')
argparser.add_argument('--user', type=str, default='admin', help='Database user')
argparser.add_argument('--pw', type=str, default='admin', help='Database password')
args = argparser.parse_args()


BACKUP_DIR = r"./backups"
MYSQL_BIN = r"C:\Program Files\MySQL\MySQL Server 9.5\bin"
mysqladump_path = os.path.join(MYSQL_BIN, "mysqldump.exe")

os.makedirs(BACKUP_DIR, exist_ok=True)

INTERVAL = 2 * 60 * 60


timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
backup_file = os.path.join(BACKUP_DIR, f"backup_{timestamp}.sql")

if __name__ == "__main__":
    while True:
        try:
            subprocess.run(
                [mysqladump_path, "-u", args.user, f"-p{args.pw}", 'job_beacon_maine'],
                stdout=open(backup_file, "w"),
                check=True
            )
            print(f"[{datetime.now()}] Backup created: {backup_file}")
        except subprocess.CalledProcessError as e:
            print(f"[{datetime.now()}] Backup failed: {e}")
        time.sleep(INTERVAL)