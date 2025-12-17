import argparse

import json
from pathlib import Path
import subprocess


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Calls plantuml generator")
    parser.add_argument("-i", "--input", help="Input puml file", required=True)
    parser.add_argument("-o", "--output", help="Relative output directory", default=".")
    parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose output", default=False)
    return parser.parse_args()

def render_puml(args: argparse.Namespace, executable: Path) -> None:
    puml_path = Path(args.input)
    if puml_path.suffix != ".puml":
        raise ValueError("Input file must have a .puml extension")

    command = [
        "java",
        "-jar",
        Path(executable).as_posix(),
        "-o",
        str(Path(args.output).as_posix()),
        str(puml_path.absolute().as_posix())
    ]
    if args.verbose:
        command.append("-v")

    subprocess.run(command, check=True)


def main():
    with open(Path(__file__).parent / "config.json", "r") as config_file:
        config = json.load(config_file)
        render_puml(args = parse_args(), executable=Path(config["jar_path"]))

if __name__ == "__main__":
    main()
