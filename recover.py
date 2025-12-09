import subprocess
import argparse as ap
import os
import time

argparser = ap.ArgumentParser(description='Recovery')
argparser.add_argument('--user', type=str, default='admin', help='Database user')
argparser.add_argument('--pw', type=str, default='admin', help='Database password')
args = argparser.parse_args()

BACKUP_DIR="./backups"
MYSQL_BIN = r"C:\Program Files\MySQL\MySQL Server 9.5\bin"
mysqladmin_path = os.path.join(MYSQL_BIN, "mysqladmin.exe")
mysql_path = os.path.join(MYSQL_BIN, "mysql.exe")

INTERVAL = 5 * 60

try:
    while True:
        result = subprocess.run(
            [mysqladmin_path, "-u", args.user, f"-p{args.pw}", "ping"],
            capture_output=True,
            text=True,
            check=True
        )
        if "mysqld is alive" in result.stdout:
            print("Database is OK")
        else:
            raise Exception("Database not responding")
        time.sleep(INTERVAL)
except:
    print("Database crash detected! Triggering recovery...")
    backups = [f for f in os.listdir(BACKUP_DIR) if f.endswith(".sql")]
    if not backups:
        print("No backups found to recover.")
        exit()
    
    latest_backup = max(backups, key=lambda f: os.path.getmtime(os.path.join(BACKUP_DIR, f)))
    backup_path = os.path.join(BACKUP_DIR, latest_backup)
    
    try:
        subprocess.run(
            [mysql_path, "-u", args.user, f"-p{args.pw}", "job_beacon_maine"],
            stdin=open(backup_path, "r"),
            check=True
        )
        print(f"Database restored from: {backup_path}")
    except subprocess.CalledProcessError as e:
        print("Recovery failed: {e}")
