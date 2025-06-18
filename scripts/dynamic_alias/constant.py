import os
from enum import Enum
from pathlib import Path


class Option(Enum):
    add = "add"
    delete = "delete"
    get = "get"
    use = "use"


class Source(Enum):
    shell_config = Path(os.path.realpath(__file__)).parent / ".shell_config.json"
    database = Path(os.path.realpath(__file__)).parent / ".database.json"


class System(Enum):
    Linux = "Linux"
    Windows = "Windows"
