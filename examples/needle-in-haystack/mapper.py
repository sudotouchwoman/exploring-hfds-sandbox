#!/usr/bin/env python3
"""
Simple mapper that searches for the needle in the input
"""

import pathlib
import sys


def get_needle(needle_file: pathlib.Path) -> str:
    return needle_file.read_text().strip()


def main():
    needle = get_needle(pathlib.Path("needle.txt"))
    needle_count = 0

    for line in sys.stdin:
        for word in line.strip().lower().split():
            if needle == word:
                needle_count += 1

    print(needle_count)


if __name__ == "__main__":
    main()
