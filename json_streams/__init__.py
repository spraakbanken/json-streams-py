from typing import Iterable
from typing import BinaryIO

from . import json_iter
from . import jsonl_iter
from . import utils


def choose_iter(name, json_format):
    if json_format == "jsonl" or name is None or utils.is_jsonl(name):
        return jsonl_iter
    return json_iter


def load(fp: BinaryIO, *, file_type=None) -> Iterable:
    _iter = choose_iter(utils.get_name_of_file(fp), file_type)

    yield from _iter.load(fp)


def load_from_file(file_name: str, *, file_type: str = None) -> Iterable:
    _iter = choose_iter(file_name, file_type)

    yield from _iter.load_from_file(file_name)


def dump(in_iter_, fp: BinaryIO, *, file_type: str = None):
    _iter = choose_iter(utils.get_name_of_file(fp), file_type)

    _iter.dump(in_iter_, fp)


def dump_to_file(in_iter_, file_name: str, *, file_type=None):
    _iter = choose_iter(file_name, file_type)

    _iter.dump_to_file(in_iter_, file_name)
