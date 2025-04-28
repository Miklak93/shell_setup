#!/usr/bin/env python3

import argparse
import subprocess
import constants

def parse_args() -> dict:
    branches = constants.commands.keys()

    parser = argparse.ArgumentParser(description="The 'git push' command helper shortening it.")
    parser.add_argument("branch", choices=branches, help="Choose where to push your changes")
    return parser.parse_args()

def main():
    args = parse_args()
    subprocess.run(constants.commands[args.branch], shell=True, check=True)

if __name__ == "__main__":
    main()
