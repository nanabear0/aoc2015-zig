const std = @import("std");

const input = std.mem.trim(u8, @embedFile("inputs/day06.txt"), "\n");

const LightChange = enum { on, off, toggle };

const Operation = struct {
    x_start: u32,
    y_start: u32,
    x_end: u32,
    y_end: u32,
    change: LightChange,
    fn parse(str: []const u8) !Operation {
        var change: LightChange = undefined;
        var x_start: u32 = undefined;
        var y_start: u32 = undefined;
        var x_end: u32 = undefined;
        var y_end: u32 = undefined;
        if (std.mem.startsWith(u8, str, "toggle")) {
            change = .toggle;
        } else {
            change = if (std.mem.containsAtLeast(u8, str, 1, " on ")) .on else .off;
        }

        var line_chunks_iterator = std.mem.split(u8, str[6..], " ");
        _ = line_chunks_iterator.next();

        var nums_iterator = std.mem.split(u8, line_chunks_iterator.next().?, ",");
        x_start = try std.fmt.parseInt(u32, nums_iterator.next().?, 10);
        y_start = try std.fmt.parseInt(u32, nums_iterator.next().?, 10);

        _ = line_chunks_iterator.next();

        nums_iterator = std.mem.split(u8, line_chunks_iterator.next().?, ",");
        x_end = try std.fmt.parseInt(u32, nums_iterator.next().?, 10);
        y_end = try std.fmt.parseInt(u32, nums_iterator.next().?, 10);

        return .{
            .x_start = x_start,
            .y_start = y_start,
            .x_end = x_end,
            .y_end = y_end,
            .change = change,
        };
    }
};

fn processRange(lights: *[1000][1000]u32, operation: Operation) !void {
    for (operation.y_start..operation.y_end + 1) |y| {
        for (operation.x_start..operation.x_end + 1) |x| {
            switch (operation.change) {
                .toggle => lights[y][x] = if (lights[y][x] == 0) 1 else 0,
                .on => lights[y][x] = 1,
                .off => lights[y][x] = 0,
            }
        }
    }
}

fn part1() !void {
    var line_iter = std.mem.split(u8, input, "\n");
    var lights: [1000][1000]u32 = std.mem.zeroes([1000][1000]u32);

    while (line_iter.next()) |line| {
        try processRange(&lights, try Operation.parse(line));
    }

    var count: u32 = 0;
    for (0..1000) |y| {
        for (0..1000) |x| {
            count += lights[y][x];
        }
    }

    std.debug.print("part1: {d}\n", .{count});
}

fn processRange2(lights: *[1000][1000]u32, operation: Operation) !void {
    for (operation.y_start..operation.y_end + 1) |y| {
        for (operation.x_start..operation.x_end + 1) |x| {
            switch (operation.change) {
                .toggle => lights[y][x] += 2,
                .on => lights[y][x] += 1,
                .off => {
                    if (lights[y][x] != 0) lights[y][x] -= 1;
                },
            }
        }
    }
}

fn part2() !void {
    var line_iter = std.mem.split(u8, input, "\n");
    var lights: [1000][1000]u32 = std.mem.zeroes([1000][1000]u32);

    while (line_iter.next()) |line| {
        try processRange2(&lights, try Operation.parse(line));
    }

    var count: u32 = 0;
    for (0..1000) |y| {
        for (0..1000) |x| {
            count += lights[y][x];
        }
    }

    std.debug.print("part2: {d}\n", .{count});
}

pub export fn day06() void {
    part1() catch unreachable;
    part2() catch unreachable;
}
