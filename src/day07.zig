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
        if (std.mem.eql(u8, "DIRECT", str)) return .NOT;
        if (std.mem.eql(u8, "INPUT", str)) return .NOT;

        unreachable;
    }
};

const Wire = struct {
    i_am: []const u8,
    in1: ?[]const u8,
    in2: ?[]const u8,
    in2v: ?u32,
    gate: Gate,
    value: ?u32,
    fn parse(str: []const u8) !Wire {
        var arrow_split = std.mem.split(u8, str, " -> ");
        const left = arrow_split.next().?;
        const right = arrow_split.next().?;
        const cnt = std.mem.count(u8, left, " ");

        switch (cnt) {
            0 => { // DIRECT, INPUT
                if (std.ascii.isAlphabetic(left[0])) { // DIRECT
                    return .{ .i_am = right, .in1 = left, .in2 = null, .in2v = null, .gate = .DIRECT, .value = null };
                } else { // INPUT
                    return .{
                        .i_am = right,
                        .in1 = null,
                        .in2 = null,
                        .in2v = null,
                        .gate = .INPUT,
                        .value = try std.fmt.parseInt(u32, left, 10),
                    };
                }
            },
            1 => { // NOT
                return .{
                    .i_am = right,
                    .in1 = left[4..],
                    .in2 = null,
                    .in2v = null,
                    .gate = .NOT,
                    .value = null,
                };
            },
            2 => {
                // OR, AND, LSHIFT, RSHIFT
                var left_split = std.mem.split(u8, left, " ");
                const in1 = left_split.next().?;
                const op = Gate.fromStr(left_split.next().?);
                const in2 = left_split.next().?;

                if (op == Gate.LSHIFT or op == Gate.RSHIFT) {
                    return .{
                        .i_am = right,
                        .in1 = in1,
                        .gate = op,
                        .in2 = null,
                        .in2v = try std.fmt.parseInt(u32, in2, 10),
                        .value = null,
                    };
                } else {
                    return .{
                        .i_am = right,
                        .in1 = in1,
                        .gate = op,
                        .in2 = in2,
                        .in2v = null,
                        .value = null,
                    };
                }
            },
            else => unreachable,
        }

        unreachable;
    }
};

fn part1() !void {
    var input_split = std.mem.split(u8, input, "\n");
    var wires = std.StringHashMap(Wire).init(std.heap.page_allocator);
    defer wires.deinit();

    var i: u32 = 1;
    while (input_split.next()) |line| : (i += 1) {
        const wire = try Wire.parse(line);
        std.debug.print("{d}: {any}\n", .{ i, wire });

        try wires.put(wire.i_am, wire);
    }

    std.debug.print("part1: \n", .{});
}

fn part2() !void {
    std.debug.print("part2: \n", .{});
}

pub export fn day07() void {
    part1() catch unreachable;
    part2() catch unreachable;
}
