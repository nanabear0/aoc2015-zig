const std = @import("std");

const input = std.mem.trim(u8, @embedFile("inputs/day02.txt"), "\n");

const Present = struct {
    l: u32,
    w: u32,
    h: u32,
    fn parse(str: []const u8) Present {
        var side_iterator = std.mem.split(u8, str, "x");
        const l = std.fmt.parseInt(u32, side_iterator.next().?, 10) catch unreachable; // YOLO
        const w = std.fmt.parseInt(u32, side_iterator.next().?, 10) catch unreachable;
        const h = std.fmt.parseInt(u32, side_iterator.next().?, 10) catch unreachable;
        return .{ .l = l, .w = w, .h = h };
    }
};

fn part1() !void {
    var line_iterator = std.mem.split(u8, input, "\n");

    var total: u32 = 0;
    while (line_iterator.next()) |line| {
        const present: Present = Present.parse(line);
        const sides = [3]u32{ present.l * present.w, present.w * present.h, present.h * present.l };
        const smallest_side = std.mem.min(u32, &sides);
        const area = 2 * (sides[0] + sides[1] + sides[2]);
        const paper_needed = area + smallest_side;
        total += paper_needed;
    }

    std.debug.print("part1: {d}\n", .{total});
}

fn part2() !void {
    var line_iterator = std.mem.split(u8, input, "\n");

    var total: u32 = 0;
    while (line_iterator.next()) |line| {
        const present: Present = Present.parse(line);
        const perimeters = [3]u32{ present.l + present.w, present.w + present.h, present.h + present.l };
        const smallest_perimeter = std.mem.min(u32, &perimeters) * 2;
        const volume = present.l * present.w * present.h;
        const ribbon_needed = smallest_perimeter + volume;
        total += ribbon_needed;
    }

    std.debug.print("part2: {d}\n", .{total});
}

pub export fn day02() void {
    part1() catch unreachable;
    part2() catch unreachable;
}
