const std = @import("std");

const input = std.mem.trim(u8, @embedFile("inputs/day08.txt"), "\n");

fn part1() !void {
    var line_iterator = std.mem.split(u8, input, "\n");
    var result: u32 = 0;
    while (line_iterator.next()) |line| {
        const code_size: u32 = @intCast(line.len);
        var string_size: u32 = 0;

        var i: u32 = 1;
        while (i < line.len - 1) : (i += 1) {
            if (line[i] == '\\') {
                if (line[i + 1] == 'x') {
                    string_size += 1;
                    i += 3;
                } else {
                    string_size += 1;
                    i += 1;
                }
            } else {
                string_size += 1;
            }
        }
        result += code_size - string_size;
    }

    std.debug.print("part1: {}\n", .{result});
}

fn part2() !void {
    var line_iterator = std.mem.split(u8, input, "\n");
    var result: u32 = 0;
    while (line_iterator.next()) |line| {
        result += 2 +
            @as(u32, @intCast(std.mem.count(u8, line, "\\"))) +
            @as(u32, @intCast(std.mem.count(u8, line, "\"")));
    }

    std.debug.print("part2: {}\n", .{result});
}

pub export fn day08() void {
    part1() catch unreachable;
    part2() catch unreachable;
}
