module common;

import std.format;
public import std.traits: ReturnType;
public import std.algorithm: splitter;
import std.typecons: Tuple;
import std.range, std.traits;

template importData(int day) {
    string importData() {
        return mixin("import(\"day" ~ format("%02d", day) ~".txt\")");
    }
}

template from(string moduleName) {
    mixin("import from = " ~ moduleName ~ ";");
}

auto without(T, R)(T[] array, R indices) if (isForwardRange!R && isIntegral!(ElementType!R) && !isInfinite!R) {
    T[] newArray;
    ElementType!R start = 0;
    foreach (i; indices) {
        newArray ~= array[start .. i];
        start = i + 1;
    }
    newArray ~= array[start .. $];
    return newArray;
}

auto splitByAnyOf(R)(R range, string separators) {
    import std.algorithm : splitter, filter, canFind;
    import std.string: empty;
    import std.conv: to;
    auto casted = separators.to!(dchar[]);
    return range.splitter!(c => separators.canFind(c)).filter!(token => !token.empty);
}

auto permutedPairs(Range)(Range range) if (isInputRange!Range) {
    static struct Result {
        import std.typecons: Tuple;
        import std.range: ElementType, dropOne;

    private:
        alias ElemType = Tuple!(ElementType!Range, ElementType!Range);
        Range r1, r2;

        this(Range range) {
            this.r1 = range;
            this.r2 = range.dropOne;
        }

    public:
        auto front() @property pure {
            return ElemType(this.r1.front, this.r2.front);
        }
        bool empty() @property pure {
            return this.r1.dropOne.empty;
        }
        void popFront() {
            if (this.r2.dropOne.empty) {
                this.r1.popFront;
                this.r2 = this.r1;
            }
            this.r2.popFront;
        }
    }

    return Result(range);
}
