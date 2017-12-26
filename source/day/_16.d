module _16;
import common;

import std.algorithm: map, countUntil, count, until, swapAt, bringToFront;
import std.range: recurrence, array, iota, drop, tee;
import std.conv: to;

struct Move {
    dchar command;
    int spin;
    int p1, p2;
}

auto process(string input) {
    return input
        .splitter(',')
        .map!((row) {
            final switch (row[0]) {
            case 's':
                return Move('s', row[1..$].to!int, 0, 0);
            case 'x':
                auto params = row[1..$].splitter('/').array;
                return Move(row[0], 0, params[0].to!int, params[1].to!int);
            case 'p':
                return Move(row[0], 0, row[1] - 'a', row[3] - 'a');
            }
        });
}

int[] dance(int[] letters, Move[] moves) {
    foreach (move; moves) {
        final switch (move.command) {
        case 's':
            auto i = letters.length - move.spin;
            letters.bringToFront(letters[i .. $]);
            break;
        case 'x':
            letters.swapAt(move.p1, move.p2);
            break;
        case 'p':
            auto ia = letters.countUntil(move.p1);
            auto ib = letters.countUntil(move.p2);
            letters.swapAt(ia, ib);
            break;
        }
    }
    return letters;
}

auto solveA(ReturnType!process moves) {
    return ('q' - 'a')
        .iota
        .array
        .dance(moves.array)
        .map!(a => (a + 'a').to!dchar);
}

alias danceSequence = (letters, moves) => letters.recurrence!((a, n) => a[n - 1].dance(moves));

auto solveB(ReturnType!process moves) {
    auto letters = ('q' - 'a').iota.array;
    auto n = 1;
    int[][ulong] cache;
    auto count = letters
        .dup
        .dance(moves.array)
        .danceSequence(moves.array)
        .tee!(s => cache[++n] = s)
        .until!(a => a == letters)
        .count + 1;
    return cache[count].map!(a => (a + 'a').to!dchar);
}