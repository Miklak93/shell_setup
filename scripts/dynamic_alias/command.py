from pathlib import Path

from db import Db, DbResult
from constant import Source

class ShellCommand():
    def __init__(self, executable: str, path: str):
        self.executable = executable
        self.path = path

    def __str__(self):
        return f"Command: '{self.executable}' '{self.path}'"

class Add:
    def __init__(self, args: dict):
        self.args = args
        self.db = Db(Source.database)

    def __call__(self) -> DbResult:
        path = Path(self.args.path).expanduser().resolve(strict=False) if self.args.path else Path.cwd()
        alias = self.args.name if self.args.name else path.name
        return self.db.add(key=alias, value=path.as_posix(), force=self.args.force)

class Delete:
    def __init__(self, args: dict):
        self.args = args
        self.db = Db(Source.database)

    def __call__(self) -> DbResult:
        return self.db.delete(key=self.args.name)

class Get:
    def __init__(self, args: dict):
        self.args = args
        self.db = Db(Source.database)

    def __call__(self) -> ShellCommand:
        get_executable = lambda default_command: self.args.executable if self.args.executable else default_command

        if not self.args.name:
            return ShellCommand(get_executable(self.args.shell_command["cat"]), Source.database.value)

        _, path = self.db.get(key=self.args.name).value()
        return ShellCommand(get_executable(self.args.shell_command["cd"]), path)