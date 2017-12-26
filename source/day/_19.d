module _19;
import common;

import std.array;
import std.conv: to;
import std.ascii: isAlpha;
import std.algorithm: filter, count;
import std.string: indexOf;

alias Grid = char[][];

auto process(string input) {
    return input.splitter('\n')
        .array
        .to!Grid;
}

auto traverse(Grid grid) {
    import std.typecons: Tuple;
    alias Point = Tuple!(int, "x", int, "y");
    enum Direction {
        Up, Down, Left, Right
    }
    struct Traverse {
        Point pos;
        Direction dir;
        bool empty() {
            return front == ' ';
        }
        char front() {
            return grid[pos.y][pos.x];
        }
        void popFront() {
            with (Direction) final switch (dir) {
                case Up: pos.y--; break;
                case Down: pos.y++; break;
                case Left: pos.x--; break;
                case Right: pos.x++; break;
            }

            with (Direction) with (pos) if (front == '+') {
                if (dir != Up && grid[y + 1][x] != ' ') {
                    dir = Down;
                } else if (dir != Down && grid[y - 1][x] != ' ') {
                    dir = Up;
                } else if (dir != Right && grid[y][x - 1] != ' ') {
                    dir = Left;
                } else if (dir != Left && grid[y][x + 1] != ' ') {
                    dir = Right;
                }
            }
        }
    }
    auto start = Point(cast(int)grid[0].indexOf('|'), 0);
    return Traverse(start, Direction.Down);
}

auto solveA(ReturnType!process grid) {
    return grid.traverse.filter!isAlpha;
}

auto solveB(ReturnType!process grid) {
    return grid.traverse.count;
}
