const std = @import("std");

const input = std.mem.trim(u8, @embedFile("inputs/day01.txt"), "\n");

fn part1() !void {
    var floor: i32 = 0;
    for (input) |c| {
        switch (c) {
            '(' => {
                floor += 1;
            },
            ')' => {
                floor -= 1;
            },
            else => unreachable,
        }
    }
    std.debug.print("part1: {d}\n", .{floor});
}

fn part2() !void {
    var floor: i32 = 0;
    for (input, 1..) |c, i| {
        switch (c) {
            '(' => {
                floor += 1;
            },
            ')' => {
                floor -= 1;
            },
            else => unreachable,
        }
        if (floor < 0) {
            std.debug.print("part2: {d}\n", .{i});
            break;
        }
    }
}

pub export fn day01() void {
    part1() catch unreachable;
    part2() catch unreachable;
}
