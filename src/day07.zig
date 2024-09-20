const std = @import("std");

const input = std.mem.trim(u8, @embedFile("inputs/day07.txt"), "\n");

const Gate = enum {
    OR,
    AND,
    LSHIFT,
    RSHIFT,
    NOT,
    DIRECT,
    INPUT,
    pub fn fromStr(str: []const u8) Gate {
        if (std.mem.eql(u8, "OR", str)) return .OR;
        if (std.mem.eql(u8, "AND", str)) return .AND;
        if (std.mem.eql(u8, "LSHIFT", str)) return .LSHIFT;
        if (std.mem.eql(u8, "RSHIFT", str)) return .RSHIFT;
        if (std.mem.eql(u8, "NOT", str)) return .NOT;
        if (std.mem.eql(u8, "DIRECT", str)) return .DIRECT;
        if (std.mem.eql(u8, "INPUT", str)) return .INPUT;

        unreachable;
    }
};

const InputTypeEnum = enum { int, string };
const Input = union(InputTypeEnum) {
    int: u16,
    string: []const u8,
    pub fn fromStr(str: []const u8) Input {
        const int_value = std.fmt.parseInt(u16, str, 10) catch {
            return Input{
                .string = str,
            };
        };
        return Input{ .int = int_value };
    }
};

const Wire = struct {
    i_am: []const u8,
    in1: ?Input,
    in2: ?Input,
    gate: Gate,
    value: ?u16,
    fn parse(str: []const u8) !Wire {
        var arrow_split = std.mem.split(u8, str, " -> ");
        const left = arrow_split.next().?;
        const right = arrow_split.next().?;
        const cnt = std.mem.count(u8, left, " ");

        switch (cnt) {
            0 => { // DIRECT, INPUT
                // Assume DIRECT
                var wire: Wire = .{ .i_am = right, .in1 = Input.fromStr(left), .in2 = null, .gate = .DIRECT, .value = null };
                switch (wire.in1.?) {
                    .int => |*value| { // Update to INPUT
                        wire.value = value.*;
                        wire.gate = .INPUT;
                    },
                    else => {},
                }
                return wire;
            },
            1 => { // NOT
                return .{
                    .i_am = right,
                    .in1 = Input.fromStr(left[4..]),
                    .in2 = null,
                    .gate = .NOT,
                    .value = null,
                };
            },
            2 => {
                // OR, AND, LSHIFT, RSHIFT
                var left_split = std.mem.split(u8, left, " ");

                return .{
                    .i_am = right,
                    .in1 = Input.fromStr(left_split.next().?),
                    .gate = Gate.fromStr(left_split.next().?),
                    .in2 = Input.fromStr(left_split.next().?),
                    .value = null,
                };
            },
            else => unreachable,
        }

        unreachable;
    }
};

const WireMap = std.StringHashMap(Wire);

fn getValueOfWireOrStaticValue(wires: *WireMap, target: Input) u16 {
    switch (target) {
        .int => |*int| return int.*,
        .string => |*string| return getValueOfWire(wires, string.*),
    }
}

fn getValueOfWire(wires: *WireMap, name: []const u8) u16 {
    var wire = wires.getPtr(name).?;
    if (wire.value) |value| return value;

    switch (wire.gate) {
        .OR => {
            wire.value = getValueOfWireOrStaticValue(wires, wire.in1.?) |
                getValueOfWireOrStaticValue(wires, wire.in2.?);
        },
        .AND => {
            wire.value = getValueOfWireOrStaticValue(wires, wire.in1.?) &
                getValueOfWireOrStaticValue(wires, wire.in2.?);
        },
        .LSHIFT => {
            wire.value = getValueOfWireOrStaticValue(wires, wire.in1.?) <<
                @intCast(getValueOfWireOrStaticValue(wires, wire.in2.?));
        },
        .RSHIFT => {
            wire.value = getValueOfWireOrStaticValue(wires, wire.in1.?) >>
                @intCast(getValueOfWireOrStaticValue(wires, wire.in2.?));
        },
        .NOT => {
            wire.value = ~getValueOfWireOrStaticValue(wires, wire.in1.?);
        },
        .DIRECT => {
            wire.value = getValueOfWireOrStaticValue(wires, wire.in1.?);
        },
        .INPUT => unreachable, // should already have a value
    }

    return wire.value.?;
}

fn part1() !u16 {
    var input_split = std.mem.split(u8, input, "\n");
    var wires = WireMap.init(std.heap.page_allocator);
    defer wires.deinit();

    var i: u32 = 1;
    while (input_split.next()) |line| : (i += 1) {
        const wire = try Wire.parse(line);
        try wires.put(wire.i_am, wire);
    }

    std.debug.print("part1: {d}\n", .{getValueOfWire(&wires, "a")});

    return wires.get("a").?.value.?;
}

fn part2(p1_result: u16) !void {
    var input_split = std.mem.split(u8, input, "\n");
    var wires = WireMap.init(std.heap.page_allocator);
    defer wires.deinit();

    var i: u32 = 1;
    while (input_split.next()) |line| : (i += 1) {
        const wire = try Wire.parse(line);
        try wires.put(wire.i_am, wire);
    }
    wires.getPtr("b").?.value = p1_result;

    std.debug.print("part2: {d}\n", .{getValueOfWire(&wires, "a")});
}

pub export fn day07() void {
    const p1_result = part1() catch unreachable;
    part2(p1_result) catch unreachable;
}
