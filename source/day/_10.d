module _10;
import common;

import std.conv: to;
import std.range: iota, array, cycle, drop, chain, repeat, chunks, enumerate;
import std.algorithm: map, fold, reverse;
import std.array: replicate;
import std.uni: toLower;
import std.format;

auto process(string input) {
    return input;
}

int[] knotHash(int[] list, int[] lengths) {
    auto range = list.cycle;
    foreach(skip, length; lengths) {
        range[0..lengths[skip]].reverse;
        range = range.drop(lengths[skip] + skip);
    }
    return list;
}

unittest {
    auto list = [0, 1, 2, 3, 4];
    auto lengths = [3, 4, 1, 5];
    assert(list.knotHash(lengths) == [3, 4, 2, 1, 0]);
}

auto solveA(ReturnType!process input) {
    auto lengths = input.splitter(',').map!(to!int).array;
    auto list = 256.iota.array.knotHash(lengths);
    return list[0] * list[1];
}

auto solveB(ReturnType!process input) {
    auto lengths = input
        .map!(to!int)
        .chain([17, 31, 73, 47, 23])
        .array
        .replicate(64);
    return 256.iota.array
        .knotHash(lengths)
        .chunks(16)
        .map!(bit => bit.fold!"a ^ b")
        .format!"%(%02x%)";
}

unittest {
    assert("".solveB == "a2582a3a0e66e6e86e3812dcb672a272");
    assert("AoC 2017".solveB == "33efeb34ea91902bb2f59c9920caa6cd");
    assert("1,2,3".solveB == "3efbe78a8d82f29979031a4aa0b16a9d");
    assert("1,2,4".solveB == "63960835bcdc130f0b66d7ff4f6a5a8e");
}
