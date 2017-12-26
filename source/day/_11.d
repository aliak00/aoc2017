module _11;
import common;

import std.typecons: Tuple;
import std.math: abs;
import std.algorithm: max, maxElement, fold, cumulativeFold, map;

auto process(string input) {
    return input.splitter(',');
}

alias Point = Tuple!(int, "x", int, "y", int, "z");

auto move(return ref Point p, string coord) {
    final switch (coord) {
    case "n": p.y += 1; p.z -= 1; break;
    case "ne": p.x += 1; p.z -= 1; break;
    case "se": p.x += 1; p.y -= 1; break;
    case "s": p.y -= 1; p.z += 1; break;
    case "sw": p.x -= 1; p.z += 1; break;
    case "nw": p.x -= 1; p.y += 1; break;
    }
    return p;
}

alias distance = (p) => max(abs(p.x), abs(p.y), abs(p.z));

auto solveA(ReturnType!process input) {
    return input
        .fold!((p, coord) => p.move(coord))(Point(0, 0, 0))
        .distance;
}

unittest {
    assert("ne,ne,ne".process.solveA == 3);
    assert("ne,ne,sw,sw".process.solveA == 0);
    assert("ne,ne,s,s".process.solveA == 2);
    assert("se,sw,se,sw,sw".process.solveA == 3);
}

auto solveB(ReturnType!process input) {
    return input
        .cumulativeFold!((p, coord) => p.move(coord))(Point(0, 0, 0))
        .map!distance
        .maxElement;
}
