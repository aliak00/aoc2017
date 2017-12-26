module _21;
import common;

import std.string: split;
import std.algorithm: map, swapAt, count, filter, any;
import std.functional: memoize, partial;
import std.typecons: Tuple;
import std.range: recurrence, array, drop, join, take;

alias Rule = Tuple!(string[], "pattern", string[], "enhancement");

auto process(string input) {
    return input
        .split('\n')
        .map!(row => row
            .split(" => ")
            .map!(part => part.split('/'))
        )
        .map!(rule => Rule(rule[0], rule[1]))
        .array;
}

auto traverseBlocks(string[] grid, size_t side) {
    static struct Result {
        size_t side;
        string[] grid;
        size_t x = 0, y = 0;
        bool empty() {
            return x >= grid.length && y >= grid.length;
        }
        auto front() {
            auto pattern = grid[y .. y + side]
                .map!(row => row[x .. x + side])
                .array;
            return Tuple!(size_t, "x", size_t, "y", string[], "pattern")(x, y, pattern);
        }
        void popFront() {
            x += side;
            if (x >= grid.length) {
                if (y < (grid.length - side)) {
                    x = 0;
                }
                y += side;
            }
        }
    }
    return Result(side, grid);
}

string[] flip(string[] pattern) {
    auto result = pattern.map!dup.array;
    foreach (ref row; result) {
        row.swapAt(0, pattern.length - 1);
    }
    return result.map!idup.array;
}

string[] rotate(string[] pattern) {
    auto n = pattern.length;
    auto result = new char[][](n, n);
    foreach (i; 0 .. n) {
        foreach (j; 0 .. n) {
            result[i][j] = pattern[n - j - 1][i];
        }
    }
    return result.map!idup.array;
}

alias variations = (pattern) =>
    pattern.recurrence!((a, n) => (n % 5 == 4)
        ? memoize!flip(a[n - 1])
        : memoize!rotate(a[n - 1])
    );

string[] findEnhancement(Rule[] rules, string[] pattern) {
    return rules
        .filter!(rule => rule.pattern.length == pattern.length)
        .filter!(rule => pattern
            .variations
            .take(8)
            .any!(v => v == rule.pattern)
        )
        .front
        .enhancement;
}

auto grids(string[] initialGrid, Rule[] rules) {
    alias enhancement = memoize!(partial!(findEnhancement, rules));
    return recurrence!((a, n) {
        auto grid = a[n - 1];
        auto side = grid.length % 2 == 0 ? 2 : 3;
        auto numSides = grid.length / side;
        auto nextSide = side + 1;
        auto nextGrid = new string[numSides * nextSide];
        foreach (block; grid.traverseBlocks(side)) {
            foreach (offset, part; enhancement(block.pattern)) {
                auto gridOffset = block.y / side;
                nextGrid[gridOffset * nextSide + offset] ~= part;
            }
        }
        return nextGrid;
    })(initialGrid);
}

auto solveA(ReturnType!process rules) {
    return grids([".#.", "..#", "###"], rules)
        .drop(5)
        .front
        .join
        .count!(a => a == '#');
}

auto solveB(ReturnType!process rules) {
    return grids([".#.", "..#", "###"], rules)
        .drop(18)
        .front
        .join
        .count!(a => a == '#');
}
