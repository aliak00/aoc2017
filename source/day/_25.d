module _25;
import common;

import std.stdio, std.algorithm, std.range, std.array, std.string, std.conv, std.functional, std.traits;


auto process(string input) {
    return input.to!(char[]);
}

auto solveA(ReturnType!process input) {
    auto state = 'a';
    auto pos = 0;
    bool[int] tape;
    foreach (i; 0..12386363) {
        auto value = tape.get(pos, false);
        final switch (state) {
        case 'a':
            if (!value) {
                tape[pos] = true;
                pos++;
                state = 'b';
            } else {
                tape[pos] = false;
                pos--;
                state = 'e';
            }
            break;
        case 'b':
            if (!value) {
                tape[pos] = true;
                pos--;
                state = 'c';
            } else {
                tape[pos] = false;
                pos++;
                state = 'a';
            }
            break;
        case 'c':
            if (!value) {
                tape[pos] = true;
                pos--;
                state = 'd';
            } else {
                tape[pos] = false;
                pos++;
                state = 'c';
            }
            break;
        case 'd':
            if (!value) {
                tape[pos] = true;
                pos--;
                state = 'e';
            } else {
                tape[pos] = false;
                pos--;
                state = 'f';
            }
            break;
        case 'e':
            if (!value) {
                tape[pos] = true;
                pos--;
                state = 'a';
            } else {
                tape[pos] = true;
                pos--;
                state = 'c';
            }
            break;
        case 'f':
            if (!value) {
                tape[pos] = true;
                pos--;
                state = 'e';
            } else {
                tape[pos] = true;
                pos++;
                state = 'a';
            }
            break;
        }
    }

    return tape.values.count(true);
}

auto solveB(ReturnType!process input) {
    return __FUNCTION__ ~ " " ~ "nothing to see here";
}