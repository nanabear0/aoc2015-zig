const std = @import("std");

const input = std.mem.trim(u8, @embedFile("inputs/day03.txt"), "\n");

fn part1() !void {
    var pos: [2]i16 = .{ 0, 0 }; // x, y
    var set = std.AutoHashMap([2]i16, void).init(std.heap.page_allocator);
    defer set.deinit();

    try set.put([2]i16{ 0, 0 }, {});
    for (input) |op| {
        switch (op) {
            '>' => pos[0] += 1,
            'v' => pos[1] += 1,
            '<' => pos[0] -= 1,
            '^' => pos[1] -= 1,
            else => unreachable,
        }
        try set.put(pos, {});
    }

    std.debug.print("part1: {d}\n", .{set.count()});
}

fn part2() !void {
    var santa: [2]i16 = .{ 0, 0 }; // x, y
    var robot: [2]i16 = .{ 0, 0 }; // x, y
    var set = std.AutoHashMap([2]i16, void).init(std.heap.page_allocator);
    defer set.deinit();

    try set.put([2]i16{ 0, 0 }, {});
    for (input, 0..) |op, i| {
        const operator: *[2]i16 = if (i % 2 == 0) &santa else &robot;
        switch (op) {
            '>' => operator.*[0] += 1,
            'v' => operator.*[1] += 1,
            '<' => operator.*[0] -= 1,
            '^' => operator.*[1] -= 1,
            else => unreachable,
        }
        try set.put(operator.*, {});
    }

    std.debug.print("part2: {d}\n", .{set.count()});
}

pub export fn day03() void {
    part1() catch unreachable;
    part2() catch unreachable;
}
