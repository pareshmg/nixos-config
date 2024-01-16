#!/usr/bin/env python3

import sys

def get_host():
    for arg in sys.argv[1:]:
        if not arg.startswith('-'):
            return arg


def str_to_color(s):
    hash = 0
    for c in s:
        hash = ord(c) + ((hash << 5) - hash)

    for i in range(3):
        yield (hash >> (i * 8)) & 0xff


def generate_seqs(color):
    seq = '\033]6;1;bg;{};brightness;{}\a'
    names = ['red', 'green', 'blue']
    for name, v in zip(names, color):
        yield seq.format(name, v)


if __name__ == '__main__':
    host = get_host()
    if host:
        color = str_to_color(host)
        for seq in generate_seqs(color):
            sys.stdout.write(seq)
