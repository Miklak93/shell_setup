import argparse
import os

from pathlib import Path

def parse_args() -> dict:
    parser = argparse.ArgumentParser(description="Performs reversed 'cd'.")
    parser.add_argument("directory", help="Choose the directory which you want to visit")
    return parser.parse_args()

def up_directory(target: str) -> Path:
    current_directory = Path.cwd()
    while current_directory.name != target:
        if current_directory == current_directory.parent:
            return f"Error: No such target '{target}'."
        current_directory = current_directory.parent
    return current_directory

def main():
    args = parse_args()
    print(up_directory(args.directory))

if __name__ == "__main__":
    main()