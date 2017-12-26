module _17;
import common;

import std.stdio, std.algorithm, std.range, std.array, std.string, std.conv, std.functional;

auto process(string input) {
    return input.to!int;
}

auto solveA(ReturnType!process stride) {
    size_t pos = 0;
    auto array = [0];
    foreach (i; 1..2018) {
        pos = (pos + stride) % (array.length);
        pos++;
        array.insertInPlace(pos, i);
    }
    return array[pos + 1];
}

auto solveB(ReturnType!process stride) {
    size_t pos = 0;
    auto n = 0;
    foreach (i; 1..50_000_001) {
        pos = (pos + stride) % i;
        pos++;
        if (pos == 1) {
            n = i;
        }
    }
    return n;
}
