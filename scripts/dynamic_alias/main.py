import argparse
import json
import platform
import os

import command

from constant import Option, Source, System

def parse_args() -> dict:
    parser = argparse.ArgumentParser(description="Shell alias manager.")
    subparsers = parser.add_subparsers(dest="option", required=True)

    add_subparser = subparsers.add_parser(Option.add.value, help="Add a new alias to the database")
    add_subparser.add_argument("name", type=str, nargs="?", help="Alias name")
    add_subparser.add_argument("-p", "--path", type=str, help="Alias path")
    add_subparser.add_argument("-f", "--force", action="store_true", default=False, help="Force overwrite an alias value")

    delete_subparser = subparsers.add_parser(Option.delete.value, help="Delete an alias from the database")
    delete_subparser.add_argument("name", type=str, nargs="?", help="Alias name")

    get_subparser = subparsers.add_parser(Option.get.value, help="Gets an alias value from the database")
    get_subparser.add_argument("name", type=str, nargs="?", help="Alias name")
    get_subparser.add_argument("-e", "--executable", type=str, default=None, help="Executable name")

    return parser.parse_args()

def detect_shell() -> System:
    if (platform.system() == "Linux" and "WSL_DISTRO_NAME" in os.environ) or ("BASH_VERSION" in os.environ):
        return System.Linux
    elif "PSModulePath" in os.environ:
        return System.Windows
    raise SystemError(f"No configuration found for {platform.system()}")

def get_args() -> dict:
    config_path = Source.shell_config.value

    shell_config = {}
    args = parse_args()
    with open(config_path, "r") as config:
        shell_config = json.load(config)
        args.shell_command = shell_config[detect_shell().value]["command"]
        return args
    raise RuntimeError(f"File {config_path} cannot be loaded.")


def main() -> str:
    args = get_args()
    mapping = {
        Option.add: command.Add(args),
        Option.delete: command.Delete(args),
        Option.get: command.Get(args)
    }
    
    try:
        print(mapping[Option(args.option)]())
    except Exception as e:
        print(e)

if __name__ == "__main__":
    main()
