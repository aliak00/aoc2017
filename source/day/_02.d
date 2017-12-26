module _02;
import common;

import std.conv: to;
import std.algorithm: fold, map, min, max, sum, filter;
import std.algorithm.setops: cartesianProduct;

auto process(string input) {
    return input
        .splitter('\n')
        .map!((a) => a
            .splitter('\t')
            .map!(to!int)
        );
}

int solveA(ReturnType!process rows) {
    return rows
        .map!(fold!(min, max))
        .map!(p => p[1] - p[0])
        .sum;
}

unittest {
    auto spreadsheet = "5\t1\t9\t5\n7\t5\t3\n2\t4\t6\t8";
    assert(process(spreadsheet).solveA == 18);
}

int solveB(ReturnType!process rows) {
    return rows
        .map!(row => cartesianProduct(row, row)
            .filter!(p => p[0] > p[1] && p[0] % p[1] == 0)
            .front
        )
        .map!(p => p[0] / p[1])
        .sum;
}

unittest {
    auto spreadsheet = "5\t9\t2\t8\n9\t4\t7\t3\n3\t8\t6\t5";
    assert(process(spreadsheet).solveB == 9);
}
