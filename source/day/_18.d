module _18;
import common;

import std.conv: castFrom, to;
import std.algorithm: map;
import std.array;

enum Mnemonic: string {
    Set = "set",
    Add = "add",
    Mul = "mul",
    Mod = "mod",
    Jgz = "jgz",
    Jnz = "jnz",
    Snd = "snd",
    Rcv = "rcv",
    Sub = "sub",
}

struct Instruction {
    this(string[] parts) {
        this.mnemonic = castFrom!string.to!Mnemonic(parts[0]);
        this.op1 = parts[1];
        this.op2 = parts.length == 3 ? parts[2] : "";
    }
    Mnemonic mnemonic;
    string op1;
    string op2;
}

struct Cpu {
    long[dchar] registers;
    int ip;
    long value(string op) {
        auto a = op.array;
        return a[0] >= 'a' ? this.registers.get(a[0], 0) : op.to!long;
    }
}

void execute(
    alias send,
    alias receive,
    alias mul,
)(
    ref Cpu cpu,
    Instruction instruction
) {
    auto dst = instruction.op1.array[0];
    alias v1 = () => cpu.value(instruction.op1);
    alias v2 = () => cpu.value(instruction.op2);
    with (Mnemonic) final switch (instruction.mnemonic) {
        case Set: cpu.registers[dst] = v2(); break;
        case Add: cpu.registers[dst] += v2(); break;
        case Mul: cpu.registers[dst] *= v2(); mul(); break;
        case Mod: cpu.registers[dst] %= v2(); break;
        case Jgz:
            if (v1() > 0) {
                cpu.ip += v2();
                return;
            }
        break;
        case Jnz:
            if (v1()) {
                cpu.ip += v2();
                return;
            }
        break;
        case Rcv:
            if (!(dst in cpu.registers)) {
                cpu.registers[dst] = 0;
            }
            receive(dst in cpu.registers);
            break;
        case Snd: send(v1()); break;
        case Sub: cpu.registers[dst] -= v2(); break;
    }
    ++cpu.ip;
}

auto process(string input) {
    return input
        .splitter('\n')
        .map!(r => r.splitter(' ').array)
        .map!Instruction
        .array;
}

auto solveA(ReturnType!process instructions) {
    Cpu cpu;
    long[] sounds;
    bool recover;
    while (cpu.ip < instructions.length) {
        cpu.execute!(
            (sound) {
                sounds ~= sound;
            },
            (register) {
                if (*register > 0) {
                    recover = true;
                }
            },
            () {}
        )(instructions[cpu.ip]);
        if (recover) {
            break;
        }
    }
    return sounds[$ - 1];
}

import std.concurrency, core.time;

auto worker(immutable Instruction[] instructions, int programId, Tid otherTid) {
    Cpu cpu;
    cpu.registers = ['p': programId];
    auto counter = 0;
    bool deadlock = false;
    while (cpu.ip < instructions.length && !deadlock) {
        cpu.execute!(
            (value) {
                send(otherTid, value);
                if (programId == 1) {
                    counter++;
                }
            },
            (register) {
                deadlock = true;
                receiveTimeout(
                    100.msecs,
                    (long value) {
                        deadlock = false;
                        *register = value;
                    },
                );
            },
            () {}
        )(instructions[cpu.ip]);
    }
    import std.stdio: writeln;
    if (programId == 1) counter.writeln;
}

auto solveB(ReturnType!process instructions) {
    auto thatTid = spawn(&worker, cast(immutable)(instructions), 0, thisTid);
    worker(cast(immutable)instructions, 1, thatTid);
    return 0;
}