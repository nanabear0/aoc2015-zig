const std = @import("std");
const expect = std.testing.expect;

const input = std.mem.trim(u8, @embedFile("inputs/day05.txt"), "\n");

fn isIllegalSequence(seq: []const u8) bool {
    const illegals = [4]*const [2:0]u8{ "ab", "cd", "pq", "xy" };

    for (illegals) |il_seq| {
        if (std.mem.eql(u8, il_seq[0..2], seq)) return true;
    }

    return false;
}

fn isNice(in: []const u8) bool {
    var has_repetition = false;
    var vowel_count: u8 = 0;

    for (in, 0..) |letter, i| {
        switch (letter) {
            'a', 'e', 'i', 'o', 'u' => vowel_count += 1,
            else => {},
        }

        if (i == 0) continue;
        if (in[i - 1] == letter) has_repetition = true;
        if (isIllegalSequence(in[i - 1 .. i + 1])) return false;
    }

    return vowel_count >= 3 and has_repetition;
}

fn isEvenNicer(in: []const u8) bool {
    var has_repeating_pair = false;
    var has_one_leter_skip_repeating = false;

    for (in, 0..) |letter, i| {
        if (i >= in.len - 2) continue;

        if (!has_repeating_pair and in[i + 2] == letter) has_repeating_pair = true;

        if (!has_one_leter_skip_repeating and
            std.mem.containsAtLeast(u8, in[i..], 2, in[i .. i + 2])) has_one_leter_skip_repeating = true;
    }

    return has_repeating_pair and has_one_leter_skip_repeating;
}

test "isNice" {
    try expect(isNice("ugknbfddgicrmopn") == true);
    try expect(isNice("aaa") == true);
    try expect(isNice("jchzalrnumimnmhp") == false);
    try expect(isNice("haegwjzuvuyypxyu") == false);
    try expect(isNice("dvszwmarrgswjxmb") == false);
    try expect(isNice("aaab") == false);
    try expect(isNice("hiiixcyohmvnkpgk") == true);
}

test "isEvenNicer" {
    try expect(isEvenNicer("qjhvhtzxzqqjkmpb") == true);
    try expect(isEvenNicer("xxyxx") == true);
    try expect(isEvenNicer("uurcxstgmygtbstg") == false);
    try expect(isEvenNicer("ieodomkazucvgmuy") == false);
}

fn part1() !void {
    var line_iter = std.mem.split(u8, input, "\n");

    var nice_count: u16 = 0;
    while (line_iter.next()) |line| {
        if (isNice(line)) nice_count += 1;
    }

    std.debug.print("part1: {d}\n", .{nice_count});
}

fn part2() !void {
    var line_iter = std.mem.split(u8, input, "\n");

    var nice_count: u16 = 0;
    while (line_iter.next()) |line| {
        if (isEvenNicer(line)) nice_count += 1;
    }

    std.debug.print("part2: {d}\n", .{nice_count});
}

pub export fn day05() void {
    part1() catch unreachable;
    part2() catch unreachable;
}
