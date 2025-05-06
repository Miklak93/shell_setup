import json
from typing import Any

from constant import Source

class DbResult:
    def __init__(self, value: Any):
        self._value = value

    def value(self) -> Any:
        return self._value

    def __str__(self) -> str:
        return str(self._value)

class DbSuccess(DbResult):
    def __init__(self, value: Any, message: str):
        super().__init__(value)
        self.message = message

    def __str__(self) -> str:
        return f"DBSuccess: {self.message} - '{self.value()}'."

class DbError(Exception):
    def __init__(self, value: Any, message: str):
        self._value = value
        super().__init__(f"DbError: {message} - '{self._value}'.")

    def value(self):
        return self._value

class Db:
    def __init__(self, source: Source):
        self.source = source.value

        if not self.source.exists():
            self.source.touch()
            self.database = {}
            return self.__dump__()

        with open(self.source, "r") as file:
            self.database = json.load(file)

    def __dump__(self) -> str:
        with open(self.source, "w") as file:
            json.dump(self.database, file, indent=4)

    def add(self, key: Any, value: Any) -> DbResult:
        if key in self.database:
            raise DbError((key, self.database[key]), "Key already exists in the database")

        self.database[key] = value
        self.__dump__()
        return DbSuccess((key, value), "Entry successfully added")

    def delete(self, key: Any) -> DbResult:
        if key not in self.database:
            raise DbError(key, "Key does not exist in the database")
        
        value = self.database[key]
        del self.database[key]
        self.__dump__()
        return DbSuccess((key, value), "Entry successfully removed")

    def get(self, key: Any) -> DbResult:
        try:
            return DbSuccess((key, self.database[key]), "Key exist in the database")
        except Exception as e:
            raise DbError(key, "Key does not exist in the database")

    def update(self, key: Any, value: Any) -> DbResult:
        if key not in self.database:
            raise DbError(key, "Key does not exist in the database")

        self.database[key] = value
        self.__dump__()
        return DbSuccess((key, value), "Entry successfully updated")
