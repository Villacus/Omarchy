#!/usr/bin/env python3
import subprocess, sys, json, os

STEP_DB = 1.0
MIN_DB = -50
MAX_DB = 6
CLIAMP = "/usr/bin/cliamp"

def get_volume():
    out = subprocess.run([CLIAMP, "status", "--json"], capture_output=True, text=True)
    if out.returncode != 0:
        return None
    try:
        d = json.loads(out.stdout)
        return d.get("volume", 0)  # cliamp omits volume field when 0 dB
    except json.JSONDecodeError:
        return None

def set_volume(db):
    subprocess.run([CLIAMP, "volume", str(db)], capture_output=True)

cur = get_volume()
if cur is None:
    sys.exit(0)

if sys.argv[1] == "up":
    new_db = min(cur + STEP_DB, MAX_DB)
elif sys.argv[1] == "down":
    new_db = max(cur - STEP_DB, MIN_DB)

set_volume(new_db)
