module _15;
import common;

import std.stdio, std.algorithm, std.range, std.array, std.string, std.conv;

immutable factors = [16807, 48271];
immutable maxint = 2_147_483_647;

auto process(string input) {
    return input
        .splitter('\n')
        .map!(p => p.splitter(' ').array[4].to!ulong).array;
}

auto solveA(ReturnType!process input) {
    // int count = 0;
    // foreach (i; 0..40_000_000) {
    //     ulong a = input[0] * factors[0] % 2147483647;
    //     ulong b = input[1] * factors[1] % 2147483647;
    //     if ((a & 0xffff) == (b & 0xffff)) count++;
    //     input[0] = a;
    //     input[1] = b;
    // }
    // return count;
    immutable n = 40_000_000;
    auto a = recurrence!((a, n) => a[n-1] * factors[0] % maxint)(input[0]).dropOne;
    auto b = recurrence!((a, n) => a[n-1] * factors[1] % maxint)(input[1]).dropOne;
    return zip(a.take(n), b.take(n)).filter!(p =>  ((p[0] & 0xffff) == (p[1] & 0xffff))).count;
}

auto solveB(ReturnType!process input) {
    immutable n = 5_000_000;
    auto a = recurrence!((a, n) => a[n-1] * factors[0] % maxint)(input[0]).filter!(a => !(a % 4)).dropOne;
    auto b = recurrence!((a, n) => a[n-1] * factors[1] % maxint)(input[1]).filter!(a => !(a % 8)).dropOne;
    return zip(a.take(n), b.take(n)).filter!(p =>  ((p[0] & 0xffff) == (p[1] & 0xffff))).count;
}