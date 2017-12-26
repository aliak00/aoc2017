module _09;
import common;

import std.typecons: tuple;
import std.range: popFront, front, empty, popBack;

auto process(string input) {
    auto result = tuple!("numGroups", "numGarbage", "totalScore")(0, 0, 0);
    dchar[] groupStack;
    bool inGarbage = false;
    for (;!input.empty; input.popFront) {
        auto currentChar = input.front;
        if (inGarbage) {
            if (currentChar == '!') input.popFront;
            else if (currentChar == '>') inGarbage = false;
            else result.numGarbage++;
            continue;
        }
        switch (currentChar) {
        case '<': inGarbage = true; break;
        case '{': groupStack ~= currentChar; break;
        case '}':
            result.numGroups++;
            result.totalScore += groupStack.length;
            groupStack.popBack;
            break;
        default:
            break;
        }
    }
    return result;
}

unittest {
    assert("{}".process.numGroups == 1);
    assert("{{{}}}".process.numGroups == 3);
    assert("{{},{}}".process.numGroups == 3);
    assert("{{{},{},{{}}}}".process.numGroups == 6);
    assert("{<{},{},{{}}>}".process.numGroups == 1);
    assert("{<a>,<a>,<a>,<a>}".process.numGroups == 1);
    assert("{{<a>},{<a>},{<a>},{<a>}}".process.numGroups == 5);
    assert("{{<!>},{<!>},{<!>},{<a>}}".process.numGroups == 2);
}

auto solveA(ReturnType!process input) {
    return input.totalScore;
}

unittest {
    assert("{}".process.totalScore == 1);
    assert("{{{}}}".process.totalScore == 6);
    assert("{{},{}}".process.totalScore == 5);
    assert("{{{},{},{{}}}}".process.totalScore == 16);
    assert("{<a>,<a>,<a>,<a>}".process.totalScore == 1);
    assert("{{<ab>},{<ab>},{<ab>},{<ab>}}".process.totalScore == 9);
    assert("{{<!!>},{<!!>},{<!!>},{<!!>}}".process.totalScore == 9);
    assert("{{<a!>},{<a!>},{<a!>},{<ab>}}".process.totalScore == 3);
}

auto solveB(ReturnType!process input) {
    return input.numGarbage;
}

unittest {
    assert("<>".process.numGarbage == 0);
    assert("<random characters>".process.numGarbage == 17);
    assert("<<<<>".process.numGarbage == 3);
    assert("<{!>}>".process.numGarbage == 2);
    assert("<!!>".process.numGarbage == 0);
    assert("<!!!>>".process.numGarbage == 0);
    assert("<{o\"i!a,<{i<a>".process.numGarbage == 10);
}
