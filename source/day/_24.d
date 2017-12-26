module _24;
import common;

import std.stdio, std.algorithm, std.range, std.array, std.string, std.conv, std.functional, std.traits, std.typecons;

struct Pipe { int a; int b; int strength() { return a + b; } }

auto process(string input) {
    return input
        .split('\n')
        .map!(row => row
            .split('/')
            .map!(to!int)
        )
        .map!(a => Pipe(a[0], a[1]))
        .array;
}

size_t strongest(Pipe[] pipes, int port) {
    size_t strongest = 0;
    for (size_t i = 0; i < pipes.length; ++i) {
        auto pipe = pipes[i];
        if (pipe.a != port && pipe.b != port) {
            continue;
        }
        auto rest = pipes[0..i] ~ pipes[i + 1 .. $];
        auto strength = pipe.strength + rest.strongest(pipe.a == port ? pipe.b : pipe.a);
        if (strength > strongest) {
            strongest = strength;
        }
    }
    return strongest;
}

auto solveA(ReturnType!process pipes) {
    return pipes.strongest(0);
}

alias Bridge = Pipe[];
alias strength = (Bridge bridge) => bridge.fold!((a, p) => a + p.a + p.b)(0);

Bridge[] findBridges(Pipe[] pipes, int port) {
    Pipe[][] bridges = [[]];
    for (size_t i = 0; i < pipes.length; ++i) {
        auto pipe = pipes[i];
        if (pipe.a != port && pipe.b != port) {
            continue;
        }
        auto rest = pipes[0..i] ~ pipes[i + 1 .. $];
        foreach (bridge; rest.findBridges(pipe.a == port ? pipe.b : pipe.a)) {
            bridges ~= [pipe] ~ bridge;
        }
    }
    return bridges;
}

auto solveB(ReturnType!process pipes) {
    auto bridges = pipes.findBridges(0);
    size_t max = 0;
    foreach (bridge; bridges) {
        if (bridge.length > max) {
            max = bridge.length;
        }
    }
    return bridges.filter!(b => b.length == max).map!strength.maxElement;
}
