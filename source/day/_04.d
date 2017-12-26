module _04;
import common;

import std.array;
import std.algorithm: map, any, sort, filter, count;
import std.functional: memoize;

auto process(string input) {
    return input.splitter('\n').map!(a => a.splitter(' '));
}

auto solveA(ReturnType!process rows) {
    return rows
        .map!permutedPairs
        .filter!(p => !p.any!(a => a[0] == a[1]))
        .count;
}

unittest {
    assert("aa bb cc dd ee".process.solveA == 1);
    assert("aa bb cc dd aa".process.solveA == 0);
    assert("aa bb cc dd aaa".process.solveA == 1);
}


auto solveB(ReturnType!process rows) {
    alias sort = (string s) => s.array.sort;
    alias msort = memoize!sort;
    return rows
        .map!permutedPairs
        .filter!(p => !p.any!(a => msort(a[0]) == msort(a[1])))
        .count;
}

unittest {
    assert("abcde fghij".process.solveB == 1);
    assert("abcde xyz ecdab".process.solveB == 0);
    assert("iiii oiii ooii oooi oooo".process.solveB == 1);
    assert("oiii ioii iioi iiio".process.solveB == 0);
}
