#! /usr/bin/env python3

import sys
from collections import defaultdict

word_counts = defaultdict(int)

for line in (line.strip() for line in sys.stdin):
    try:
        word, count = line.split("\t", 1)
        word_counts[word] += int(count)
    except ValueError:
        continue

for word, count in sorted(
    word_counts.items(),
    key=lambda x: x[1],
    reverse=True,
):
    print(f"{word}\t{count}")
