#!/usr/bin/env python

from pathlib import Path
import subprocess
import json
import shutil
import os
import sys
import argparse
from dataclasses import dataclass


if not shutil.which('niri'):
    sys.exit(1)


DRM_DEVICE_DIR = Path("/sys/class/drm")
assert DRM_DEVICE_DIR.exists() and DRM_DEVICE_DIR.is_dir(), f"Directory {DRM_DEVICE_DIR} does not exist!"

if os.getenv("NIRI_SOCKET") is None:
    sys.exit(2)


@dataclass(frozen=True)
class DrmDevice:
    sys_class_``

    def connected(self) -> bool:
        pass

niri_outputs: dict = json.loads(subprocess.run(["niri", "msg", "--json", "outputs"]).stdout)

print(f"{niri_outputs=}")
