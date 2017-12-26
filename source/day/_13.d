module _13;
import common;

import std.algorithm: map, fold, any, countUntil;
import std.array;
import std.conv: to;
import std.typecons;
import std.range: recurrence;

auto process(string input) {
    return input
        .splitter('\n')
        .map!(row => row.splitter(": ")
            .map!(to!int)
            .array
        )
        .array
        .map!(a => Tuple!(int, "click", int, "depth")(a[0], a[1]));
}

alias collidesAfter = (layer, delay) => (layer.click + delay) % (2 * (layer.depth - 1)) == 0;

auto solveA(ReturnType!process layers) {
    return layers.fold!((severity, layer) {
        return severity + (layer.collidesAfter(0) ? layer.click * layer.depth : 0);
    })(0);
}

auto solveB(ReturnType!process layers) {
    return recurrence!"n + 1"(0)
        .countUntil!(delay => !layers
            .any!(layer => layer.collidesAfter(delay))
        ) + 1;
}
