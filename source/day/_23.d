module _23;
import common;

import std.stdio, std.algorithm, std.range, std.array, std.string, std.conv, std.functional, std.traits;

auto process(string input) {
    import _18: process;
    return process(input);
}

import _18: Cpu, execute;

auto solveA(ReturnType!process instructions) {
    Cpu cpu;
    auto count = 0;
    while (cpu.ip < instructions.length) {
        cpu.execute!(
            (send) {},
            (recv) {},
            () => count++
        )(instructions[cpu.ip]);
    }
    return count;
}

auto solveB(ReturnType!process instructions) {
    auto start = instructions[0].op2.to!int * 100 + 100000;
    auto end = start + 17000;
    auto stride = 17;
    auto counter = 0;
    for (int b = start; b <= end; b += 17) {
        for (int i = 2; i < b; ++i) {
            if (b % i == 0) {
                counter++;
                break;
            }
        }
    }
    return counter;
}