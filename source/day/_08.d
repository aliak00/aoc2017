module _08;
import common;

import std.algorithm: map, fold, max;
import std.conv: to;
import std.typecons: tuple;
import std.array;
import std.format;

struct Command {
    string reg;
    int val;
    string lhs;
    string cond;
    int rhs;
}

Command parse(string[] parts) {
    return Command(
        parts[0],
        parts[2].to!int * (parts[1] == "inc" ? +1 : -1),
        parts[4],
        parts[5],
        parts[6].to!int
    );
}

auto process(string input) {
    auto commands = input.splitter('\n')
        .map!((a) => a.splitter(' ').array)
        .map!(to!(string[]))
        .map!parse;

    int maxSeenValue = 0;  
    int[string] map;
    foreach (cmd; commands) {
        immutable statement = `case "%1$s": if (map.get(cmd.lhs, 0) %1$s cmd.rhs) map[cmd.reg] = map.get(cmd.reg, 0) + cmd.val; break L;`;
        L: final switch (cmd.cond) {
            static foreach (op; ["<", ">", "<=", ">=", "==", "!="]) mixin(statement.format(op));
        }
        auto value = map.get(cmd.reg, 0);
        if (value > maxSeenValue) {
            maxSeenValue = value;
        }
    }

    return tuple(map.fold!max, maxSeenValue);
}

auto solveA(ReturnType!process input) {
    return input[0];
}

auto solveB(ReturnType!process input) {
    return input[1];
}

version(unittest)
immutable testInput = "b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10";

unittest {
    assert(testInput.process.solveA == 1);
}

unittest {
    assert(testInput.process.solveB == 10);
}
