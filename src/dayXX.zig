const std = @import("std");

const input = std.mem.trim(u8, @embedFile("inputs/dayXX.txt"), "\n");

fn part1() !void {
    std.debug.print("part1: \n", .{});
}

fn part2() !void {
    std.debug.print("part2: {}\n", .{});
}

pub export fn run() void {
    part1() catch unreachable;
    part2() catch unreachable;
}
