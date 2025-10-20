#!/usr/bin/env python3
"""
Simple word count mapper
Reads lines from stdin and emits word\t1 for each word
"""

import sys

for line in sys.stdin:
    for word in line.strip().lower().split():
        print(f"{word}\t1")
