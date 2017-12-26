module _01;
import common;

import std.range: zip, cycle, drop;
import std.algorithm: filter, map, sum;

auto process(string input) {
    return input;
}

int checksum(string input, size_t offset) pure {
    return input
        .zip(input.cycle.drop(offset))
        .filter!(p => p[0] == p[1])
        .map!(p => p[0] - '0')
        .sum;
}

auto solveA(ReturnType!process input) {
    return input.checksum(1);
}

unittest {
    assert(process("1122").solveA == 3);
    assert(process("1111").solveA == 4);
    assert(process("1234").solveA == 0);
    assert(process("91212129").solveA == 9);
}

auto solveB(ReturnType!process input) {
    return input.checksum(input.length / 2);
}

unittest {
    assert(process("1212").solveB == 6);
    assert(process("1221").solveB == 0);
    assert(process("123425").solveB == 4);
    assert(process("123123").solveB == 12);
    assert(process("12131415").solveB == 4);
}
