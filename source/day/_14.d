module _14;
import common;

import std.algorithm: map, count;
import std.range: iota, join;
import std.conv: text;
import std.array;
import std.format;

string binary(dchar c) {
    int v = c <= '9' ? c - '0' : c - 'a' + 10;
    return format("%04b", v);
}

import _10: knotHashHex = solveB;
alias knotHash = (string input) 
    => knotHashHex(input)
        .map!binary
        .join;

immutable size = 128;

auto process(string input) {
    return size
        .iota
        .map!(i => input ~ "-" ~ i.text)
        .map!knotHash
        .array;
}

auto solveA(ReturnType!process grid) {
    return grid
        .join
        .count!q{a == '1'};
}

void visit(ref string[] grid, int i, int j, ref bool[size][size] visited) {
    if (visited[i][j]) {
        return;
    }
    visited[i][j] = true;
    if (i > 0 && grid[i - 1][j] == '1') visit(grid, i - 1, j, visited);
    if (i < 127 && grid[i + 1][j] == '1') visit(grid, i + 1, j, visited);
    if (j > 0 && grid[i][j - 1] == '1') visit(grid, i, j - 1, visited);
    if (j < 127 && grid[i][j + 1] == '1') visit(grid, i, j + 1, visited);
}

auto solveB(ReturnType!process grid) {
    bool[size][size] visited;
    auto count = 0;
    foreach (i; 0..size) {
        foreach (j; 0..size) {
            if (grid[i][j] == '1' && !visited[i][j]) {
                visit(grid, i, j, visited);
                count++;
            }
        }
    }
    return count;
}
