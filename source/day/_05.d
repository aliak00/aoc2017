module _05;
import common;

import std.algorithm: map;
import std.conv: to;
import std.array;

auto process(string input) {
    return input.splitter('\n').map!(to!int).array;
}

auto solveA(ReturnType!process input) {
    int steps = 0;
    for (int index = 0; index < input.length; steps++) {
        index += input[index]++;
    }
    return steps;
}

unittest {
    assert(solveA([0, 3, 0, 1, -3]) == 5);
}

auto solveB(ReturnType!process input) {
    int steps = 0;
    for (int index = 0; index < input.length; steps++) {
        auto jump = &input[index];
        index += *jump >= 3 ? (*jump)-- : (*jump)++;
    }
    return steps;
}

unittest {
    assert(solveB([0, 3, 0, 1, -3]) == 10);
}