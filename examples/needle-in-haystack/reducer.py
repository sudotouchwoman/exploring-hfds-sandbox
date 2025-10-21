#! /usr/bin/env python3

"""
Simple reducer that sums the number of times a needle appears in the input
"""

import pathlib
import sys


def get_needle(needle_file: pathlib.Path) -> str:
    return needle_file.read_text().strip()


def main():
    needle = get_needle(pathlib.Path("needle.txt"))
    needle_count = 0

    for line in (line.strip() for line in sys.stdin):
        try:
            count = int(line)
            needle_count += count
        except ValueError:
            continue

    print(f"{needle}\t{needle_count}")


if __name__ == "__main__":
    main()
