import argparse
import contextlib
import io
import json
import platform
import os
import sys

import command

from constant import Option, Source, System


def parse_args(args=None) -> dict:
    parser = argparse.ArgumentParser(description="Shell alias manager.")
    subparsers = parser.add_subparsers(dest="option", required=True)

    add_subparser = subparsers.add_parser(
        Option.add.value, help="Add a new alias to the database"
    )
    add_subparser.add_argument("name", type=str, nargs="?", help="Alias name")
    add_subparser.add_argument("-p", "--path", type=str, help="Alias path")
    add_subparser.add_argument(
        "-f",
        "--force",
        action="store_true",
        default=False,
        help="Force overwrite an alias value",
    )

    delete_subparser = subparsers.add_parser(
        Option.delete.value, help="Delete an alias from the database"
    )
    delete_subparser.add_argument("name", type=str, nargs="?", help="Alias name")

    get_subparser = subparsers.add_parser(
        Option.get.value, help="Gets an alias value from the database"
    )
    get_subparser.add_argument("name", type=str, nargs="?", help="Alias name")
    get_subparser.add_argument(
        "-e", "--executable", type=str, default=None, help="Executable name"
    )

    use_subparser = subparsers.add_parser(
        Option.use.value, help="Gets an alias value from the database"
    )
    use_subparser.add_argument("name", type=str, nargs="?", help="Alias name")
    use_subparser.add_argument(
        "-e", "--executable", type=str, default=None, help="Executable name"
    )

    return parser.parse_args(args)


def get_args() -> dict:
    try:
        # Silence potential argparse error messages
        with contextlib.redirect_stderr(io.StringIO()):
            args = parse_args()
    except SystemExit:  # User may not use any subparse command, set "use" as default
        shell_args = [Option.use.value] + sys.argv[1:]
        args = parse_args(args=shell_args)

    config_path = Source.shell_config.value
    shell_config = {}
    with open(config_path, "r") as config:
        shell_config = json.load(config)
        args.shell_command = shell_config[detect_shell().value]["command"]
        return args
    raise RuntimeError(f"File {config_path} cannot be loaded.")


def detect_shell() -> System:
    if (platform.system() == "Linux" and "WSL_DISTRO_NAME" in os.environ) or (
        "BASH_VERSION" in os.environ
    ):
        return System.Linux
    elif "PSModulePath" in os.environ:
        return System.Windows
    raise SystemError(f"No configuration found for {platform.system()}")


def main() -> str:
    mapping = {
        Option.add: command.Add,
        Option.delete: command.Delete,
        Option.get: command.Get,
        Option.use: command.Use,
    }

    args = get_args()
    try:
        print(mapping[Option(args.option)](args)())
    except Exception as e:
        print(e)


if __name__ == "__main__":
    main()
