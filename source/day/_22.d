module _22;
import common;

import std.string: split;
import std.typecons: Tuple;

struct Point {
    int x;
    int y;
    size_t toHash() const nothrow @safe {
        return y * 1000 + x;
    }
    bool opEquals(ref const typeof(this) s) const pure {
        return x == s.x && y == s.y;
    }
}

auto process(string input) {
    auto map = input.split('\n');
    dchar[Point] grid;
    foreach (int y, row; map) {
        foreach(int x, state; row) {
            grid[Point(x, y)] = state;
        }
    }
    auto mid = cast(int)map.length / 2;
    return Tuple!(dchar[Point], "grid", Point, "position")(grid.rehash, Point(mid, mid));
}

enum Direction {
    up, left, right, down
}

void advance(ref Point point, Direction direction) {
    with (Direction) final switch (direction) {
        case up: point.y--; break;
        case down: point.y++; break;
        case left: point.x--; break;
        case right: point.x++; break;
    }
}

void turn(ref Direction current, Direction direction) {
    with (Direction) final switch (current) {
        case up: current = direction == right ? right : left; break;
        case down: current = direction == right ? left : right; break;
        case left: current = direction == right ? up : down; break;
        case right: current = direction == right ? down : up; break;
    }
}

auto solveA(ReturnType!process input) {
    auto grid = input.grid;
    auto current = input.position;
    auto direction = Direction.up;
    auto count = 0;
    foreach (bursts; 0..10_000) {
        auto c = current in grid;
        with (Direction) final switch (*c) {
            case '.':
                direction.turn(left);
                *c = '#';
                count++;
                break;
            case '#':
                direction.turn(right);
                *c = '.';
                break;
        }
        current.advance(direction);
        if ((current in grid) is null) {
            grid[current] = '.';
        }
    }
    return count;
}

auto solveB(ReturnType!process input) {
    auto grid = input.grid;
    auto current = input.position;
    auto direction = Direction.up;
    auto count = 0;
    foreach (bursts; 0..10_000_000) {
        auto c = current in grid;
        with (Direction) final switch (*c) {
            case '.':
                direction.turn(left);
                *c = 'w';
                break;
            case '#':
                direction.turn(right);
                *c = 'f';
                break;
            case 'f':
                direction.turn(left);
                direction.turn(left);
                *c = '.';
                break;
            case 'w':
                *c = '#';
                count++;
                break;
        }
        current.advance(direction);
        if ((current in grid) is null) {
            grid[current] = '.';
        }
    }
    return count;
}
