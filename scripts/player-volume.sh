#!/usr/bin/env python3
import json, shutil, subprocess, sys

STEP_DB = 1.0
MIN_DB = -50
MAX_DB = 6
CLIAMP = shutil.which("cliamp")

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
    return subprocess.run([CLIAMP, "volume", str(db)], capture_output=True).returncode

if len(sys.argv) != 2 or sys.argv[1] not in ("up", "down"):
    print(f"Uso: {sys.argv[0]} up|down", file=sys.stderr)
    sys.exit(2)

# A missing player is not an error: this binding is shared with machines that
# don't have cliamp installed.
if CLIAMP is None:
    sys.exit(0)

cur = get_volume()
if cur is None:
    sys.exit(0)

if sys.argv[1] == "up":
    new_db = min(cur + STEP_DB, MAX_DB)
else:
    new_db = max(cur - STEP_DB, MIN_DB)

sys.exit(set_volume(new_db))
