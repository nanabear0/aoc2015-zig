const std = @import("std");

const input = std.mem.trim(u8, @embedFile("inputs/day04.txt"), "\n");

fn digits(in: u32) u32 {
    if (in == 0) return 1;

    return std.math.log10(in) + 1;
}

fn findRepeating(size: u32) !u32 {
    var result_buffer: [32]u8 = undefined;
    var md5_buffer: [16]u8 = undefined;
    var input_buffer: [128]u8 = undefined;

    var v: u32 = 0;
    const target_slice = "000000"[0..size];
    while (true) : (v += 1) {
        _ = try std.fmt.bufPrint(&input_buffer, "{s}{d}", .{ input, v });
        const len = input.len + digits(v);
        std.crypto.hash.Md5.hash(input_buffer[0..len], &md5_buffer, .{});
        _ = try std.fmt.bufPrint(&result_buffer, "{s}", .{std.fmt.fmtSliceHexUpper(&md5_buffer)});

        if (std.mem.eql(u8, target_slice, result_buffer[0..size])) break;
    }

    return v;
}

fn part1() !void {
    std.debug.print("part1: {d}\n", .{try findRepeating(5)});
}

fn part2() !void {
    std.debug.print("part2: {d}\n", .{try findRepeating(6)});
}

pub export fn day04() void {
    part1() catch unreachable;
    part2() catch unreachable;
}
