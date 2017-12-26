import std.stdio;
import std.string: format;
import std.getopt;
import std.conv;
import common;

static immutable day = 25;
mixin("import _" ~ format("%02d", day) ~ ";");

enum data = process(importData!day);

int main(string[] args) {
    bool onlyA;
    bool onlyB;
    auto opts = getopt(
        args,
        "a", "only run part a", &onlyA,
        "b", "only run part b", &onlyB,
    );
    if (opts.helpWanted) {
        defaultGetoptPrinter("Advent of code day: " ~ day.to!string, opts.options);
        return 0;
    }

    if (!onlyB || onlyA) solveA(data).writeln;
    if (!onlyA || onlyB) solveB(data).writeln;

    return 0;
}
