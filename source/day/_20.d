module _20;
import common;

import std.algorithm: map, canFind, filter, sort, count, uniq;
import std.ascii: isAlpha;
import std.math: abs;
import std.conv: to;
import std.range: empty, array, enumerate;

auto process(string input) {
    return input
        .splitter('\n')
        .map!(row => row
            .splitter!((a) => "avp<>=, ".canFind(a))
            .filter!(a => !a.empty)
            .map!(to!long)
            .array
        );
}

auto update(ref long[] p, size_t step = 1) {
    p[3] += p[6] * step;
    p[0] += p[3];

    p[4] += p[7] * step;
    p[1] += p[4];

    p[5] += p[8] * step;
    p[2] += p[5];
}

auto solveA(ReturnType!process input) {
    ulong index = 0;
    long min = int.max;

    foreach (i, ref p; input.enumerate) {
        p.update(1_000_000_000);
        auto dist = p[0].abs + p[1].abs + p[2].abs;
        if (dist < min) {
            index = i;
            min = dist;
        }
    }

    return index;
}

auto solveB(ReturnType!process input) {
    auto array = input.array;
    for (long t; t < 100; ++t) {
        ulong[] indices;
        for (ulong i = 0; i < array.length - 1; ++i) {
            bool collided = false;
            for (ulong j = i + 1; j < array.length; ++j) {
                if (array[i][0..3] == array[j][0..3]) {
                    collided = true;
                    indices ~= j;
                }
            }
            if (collided) {
                indices ~= i;
            }
        }

        if (indices.length) {
            array = array.without(indices.sort.uniq);
            t = 0;
        }

        foreach (ref p; array) {
            p.update;
        }
    }

    return array.count;
}