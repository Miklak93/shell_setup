import argparse
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Display contents of all files in a directory."
    )
    parser.add_argument(
        "directory", help="Choose the directory which you want to print"
    )
    return parser.parse_args()


def get_content(directory: Path):
    def is_binary(file_path: Path) -> bool:
        try:
            with open(file_path, "rb") as file:
                return b"\0" in file.read(1024)
        except Exception:
            return True

    if not directory.exists() or not directory.is_dir():
        raise ValueError(f"Error: '{directory}' is not a valid directory.")

    for path in sorted(directory.rglob("*")):
        if path.is_file() and not is_binary(path):
            absolute_path = path.resolve()
            print(f"\n\033[1m{absolute_path}\033[0m")
            with open(path, "r", encoding="utf-8") as file:
                print(f"{file.read()}")


def main():
    args = parse_args()
    get_content(Path(args.directory).resolve())


if __name__ == "__main__":
    main()
