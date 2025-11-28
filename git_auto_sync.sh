#!/bin/bash
git add .
git commit -m "auto run $(date '+%Y-%m-%d %H:%M:%S')"
git push
