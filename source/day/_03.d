module _03;
import common;

import std.math: sqrt, abs;
import std.conv: to;
import std.algorithm: map, min, filter, fold, sum, find;
import std.range: tee;
import std.typecons: Tuple, tuple;

alias Point = Tuple!(int, "x", int, "y");

immutable adjacent = (Point p) => [
    Point(p.x + 1, p.y),
    Point(p.x + 1, p.y + 1),
    Point(p.x, p.y + 1),
    Point(p.x - 1, p.y + 1),
    Point(p.x - 1, p.y),
    Point(p.x - 1, p.y - 1),
    Point(p.x, p.y - 1),
    Point(p.x + 1, p.y - 1),
];

auto spiral() {
    static struct Result {
    private:
        auto x = 0;
        auto y = 0;
        auto layer = 0;

    public:
        enum empty = false;
        auto front() @property {
            return Point(this.x, this.y);
        }
        void popFront() {
            if (this.x == layer && this.y == -layer) {
                this.layer++;
                this.x = this.layer;
            } else if (this.y < this.layer && this.x == this.layer) {
                this.y++;
            } else if (this.x > -this.layer && this.y == this.layer) {
                this.x--;
            } else if (this.y > -this.layer && this.x == -this.layer) {
                this.y--;
            } else if (this.x < this.layer && this.y == -this.layer) {
                this.x++;
            }
        }
    }
    return Result();
}

auto process(string input) {
    return input.to!real;
}

auto solveA(ReturnType!process n) {
    auto root = cast(int)sqrt(n) + 1;
    auto length = root % 2 != 0 ? root : root + 1;
    auto layer = length / 2;
    if (layer <= 1) return 0;
    auto corner = length * length;
    auto distance = corner - n;
    auto minimum = distance % (length - 1);
    return layer + abs(minimum - layer);
    //
    // Slower solution:
    // auto p = spiral.takeExactly(n - 1).front
    // return p.x.abs + p.y.abs
    //
}

unittest {
    assert(solveA(1) == 0);
    assert(solveA(12) == 3);
    assert(solveA(23) == 2);
    assert(solveA(1024) == 31);
}

int sumAdjacent(int[Point] points, Point point) pure {
    auto sum = point.adjacent
        .filter!(p => p in points)
        .map!(p => points[p])
        .sum;
    return sum ? sum : 1;
}

auto spiralOfSums() {
    int[Point] visitedPoints;
    return spiral
        .map!(p => tuple!("p", "sum")(p, visitedPoints.sumAdjacent(p)))
        .tee!(t => visitedPoints[t.p] = t.sum)
        .map!(t => t.sum);
}

auto solveB(ReturnType!process target) {
    return spiralOfSums
        .find!(n => n >= target)
        .front;
}

unittest {
    import std.range: take;
    import std.array;
    assert(spiralOfSums.take(10).array == [1, 1, 2, 4, 5, 10, 11, 23, 25, 26]);
}
