module _07;
import common;

import std.algorithm: fold, map, filter, sort, sum, canFind;
import std.range: array;
import std.conv: to;
import std.typecons: Tuple;
import std.string;

struct Program {
    string name;
    int weight;
    string[] children;
}

Program parseTokens(string[] tokens) pure {
    Program p;
    p.name = tokens[0];
    p.weight = tokens[1].to!int;
    p.children = tokens[2 .. $];
    return p;
}

auto process(immutable string input) {
    alias tokenize = (row) => row.splitter!((a) => ", ()->".canFind(a)).filter!(t => !t.empty).array;
    Program[string] empty;
    return input.splitter('\n')
        .map!tokenize
        .map!parseTokens
        .fold!((map, program) {
            map[program.name] = program;
            return map;
        })(empty);
}

string root(Program[string] programs) {
    auto copy = programs.dup;
    foreach (v; programs.byValue) {
        foreach (name; v.children) {
            copy.remove(name);
        }
    }
    return copy.byValue.front.name;
}

auto solveA(ReturnType!process programs) {
    return programs.root;
}

auto uniqueDiff(int[] array) {
    alias Result = Tuple!(int, "value", int, "offset");
    if (array.length == 0) {
        return Result(0, 0);
    }
    auto sorted = array.sort;
    if (sorted[0] == sorted[1]) {
        return Result(sorted[$-1], sorted[0] - sorted[$-1]);
    } else if (sorted[$-1] == sorted[$-2]) {
        return Result(sorted[0], sorted[0] - sorted[1]);
    } else {
        return Result(0, 0);
    }
}

alias DiskData = Tuple!(string, "name", int, "weight", int, "offset");

DiskData findUnbalancedDisc(Program[string] programs, string root) {
    int[string] childWeights;
    auto self = programs[root];
    foreach (child; self.children) {
        auto tuple = findUnbalancedDisc(programs, child);
        if (tuple.offset) {
            return tuple;
        }
        childWeights[child] = tuple.weight;
    }
    auto weights = childWeights.values;
    auto diff = uniqueDiff(weights);
    if (weights.length < 3 || !diff.offset) {
        return DiskData(self.name, self.weight + weights.sum, 0);
    }
    auto child = childWeights
        .byKeyValue
        .filter!(a => a.value == diff.value)
        .front
        .key;
    return DiskData(child, programs[child].weight, diff.offset);
}

auto solveB(ReturnType!process programs) {
    auto result = findUnbalancedDisc(programs, programs.root);
    return result.weight + result.offset;
}

version(unittest)
immutable testInput = "pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)";

unittest {
    assert(testInput.process.solveA == "tknk");
}

unittest {
    assert(testInput.process.solveB == 60);
}
