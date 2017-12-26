module _12;
import common;

import std.algorithm: canFind, map, filter, fold, any, each;
import std.range: empty, enumerate;
import std.conv: to;
import std.array;

auto process(string input) {
    auto list = input
        .splitter('\n')
        .map!(row => row
            .splitter!((a) => "<-> ,".canFind(a))
            .filter!(a => !a.empty)
            .map!(to!int)
            .array
        );
    int[][int] pipes;
    foreach (r; list) {
        pipes[r[0]] = r[1 .. $];
    }
    return pipes;
}

auto groupContaining(int[][int] pipes, int program) {
    int[] recurse(int[][int] pipes, int program, bool[] visited) {
        if (visited[program]) {
            return [];
        }
        visited[program] = true;
        return pipes[program].fold!((a, p) => a ~ recurse(pipes, p, visited))([program]);
    }
    return recurse(pipes, program, new bool[](pipes.keys.length));
}

auto solveA(int[][int] pipes) {
    return pipes.groupContaining(0).length;
}

auto solveB(int[][int] pipes) {
    auto grouped = new bool[](pipes.keys.length);
    return pipes
        .keys
        .fold!((count, k) {
            if (grouped[k]) return count;
            pipes.groupContaining(k).each!(g => grouped[g] = true);
            return count + 1;
        })(0);
}
