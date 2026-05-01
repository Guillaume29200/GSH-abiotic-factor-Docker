#!/usr/bin/env bash
set -euo pipefail

pgrep -f "AbioticFactorServer-Win64-Shipping.exe|wine" >/dev/null 2>&1
