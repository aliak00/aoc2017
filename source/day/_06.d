module _06;
import common;

import std.algorithm: maxIndex, map;
import std.conv: to;
import std.array;

auto process(string input) {
    return input.splitter('\t').map!(to!int).array;
}

void redistribute(ref int[] bank) pure {
    auto i = bank.maxIndex;
    auto blocks = bank[i];
    bank[i] = 0;
    while (blocks--) {
        bank[++i % bank.length]++;
    }   
}

auto solveA(ReturnType!process bank) {
    int cycle = 0;
    string bankString;
    for (int[string] seenBanks; !(bankString in seenBanks); cycle++) {
        seenBanks[bankString] = 0;
        bank.redistribute;
        bankString = bank.to!string;
    }
    return cycle;
}

unittest {
    assert([0, 2, 7, 4].solveA == 5);
}

auto solveB(ReturnType!process bank) {
    int cycle = 0;
    string bankString;
    int[string] seenBanks;
    for (; !(bankString in seenBanks); cycle++) {
        seenBanks[bankString] = cycle;
        bank.redistribute;
        bankString = bank.to!string;
    }
    return cycle - seenBanks[bankString];
}

unittest {
    assert([0, 2, 7, 4].solveB == 4);
}