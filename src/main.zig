const std = @import("std");

const advent_2025 = @import("advent_2025");

fn readInputFile(allocator: std.mem.Allocator, filename: []const u8) ![]const u8 {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    var reader = file.reader(&.{});
    return try reader.interface.allocRemaining(allocator, .unlimited);
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    try solveDay1(arena.allocator());
    try solveDay2(arena.allocator());
    try solveDay3(arena.allocator());
    try solveDay4(arena.allocator());
    try solveDay5(arena.allocator());
    try solveDay6(arena.allocator());
    try solveDay7(arena.allocator());
    try solveDay8(arena.allocator());
}

pub fn solveDay1(allocator: std.mem.Allocator) !void {
    const file_data = try readInputFile(allocator, "day1_input.txt");
    const solution1 = advent_2025.day1_crack_safe_part_1(file_data);
    const solution2 = advent_2025.day1_crack_safe_part_2(file_data);
    std.debug.print("[day 1] solution part 1: {d}\n", .{solution1});
    std.debug.print("[day 1] solution part 2: {d}\n", .{solution2});
}

pub fn solveDay2(allocator: std.mem.Allocator) !void {
    const file_data = try readInputFile(allocator, "day2_input.txt");
    const trimmed = std.mem.trim(u8, file_data, &std.ascii.whitespace);
    const solution = advent_2025.day2_clear_duplicates(trimmed);
    std.debug.print("[day 2] solution part 1: {d}\n", .{solution});

    const solution2_2 = advent_2025.day2_part2_simple(trimmed);
    std.debug.print("[day 2] alternative solution part 2: {d}\n", .{solution2_2});

    const solution2 = advent_2025.day2_part2(trimmed);
    std.debug.print("[day 2] solution part 2: {d}\n", .{solution2});
}
pub fn solveDay3(allocator: std.mem.Allocator) !void {
    const file_data = try readInputFile(allocator, "day3_input.txt");
    const trimmed = std.mem.trim(u8, file_data, &std.ascii.whitespace);
    const solution = advent_2025.totalJoltage(trimmed);
    std.debug.print("[day 3] solution part 1: {d}\n", .{solution});
    const solution_2 = advent_2025.totalJoltageN(trimmed, 12);
    std.debug.print("[day 3] solution part 2: {d}\n", .{solution_2});
}

pub fn solveDay4(allocator: std.mem.Allocator) !void {
    const file_data = try readInputFile(allocator, "day4_input.txt");
    const trimmed = std.mem.trim(u8, file_data, &std.ascii.whitespace);
    const solution = advent_2025.day4_accessible_rolls(trimmed);
    std.debug.print("[day 4] solution part 1: {d}\n", .{solution});

    const solution_2 = advent_2025.day4_total_removable_rolls(trimmed);
    std.debug.print("[day 4] solution part 1: {d}\n", .{solution_2});
}

pub fn solveDay5(allocator: std.mem.Allocator) !void {
    const file_data = try readInputFile(allocator, "day5_input.txt");
    const trimmed = std.mem.trim(u8, file_data, &std.ascii.whitespace);
    const solution = advent_2025.day5_fresh_ingredients(trimmed);
    std.debug.print("[day 5] solution part 1: {d}\n", .{solution});

    const solution2 = advent_2025.day5_total_fresh_ids(trimmed);
    std.debug.print("[day 5] solution part 2: {d}\n", .{solution2});
}

pub fn solveDay6(allocator: std.mem.Allocator) !void {
    const file_data = try readInputFile(allocator, "day6_input.txt");
    const trimmed = std.mem.trim(u8, file_data, &std.ascii.whitespace);
    const solution = advent_2025.day6_cephalopod_math(trimmed);
    std.debug.print("[day 6] solution part 1: {d}\n", .{solution});

    const solution2 = advent_2025.day6_cephalopod_math_part2(trimmed);
    std.debug.print("[day 6] solution part 1: {d}\n", .{solution2});
}

pub fn solveDay7(allocator: std.mem.Allocator) !void {
    const file_data = try readInputFile(allocator, "day7_input.txt");
    const trimmed = std.mem.trim(u8, file_data, &std.ascii.whitespace);
    const solution = advent_2025.day7_tachyon_splits(trimmed);
    std.debug.print("[day 7] solution part 1: {d}\n", .{solution});

    const solution2 = advent_2025.day7_tachyon_timelines(trimmed);
    std.debug.print("[day 7] solution part 2: {d}\n", .{solution2});
}

pub fn solveDay8(allocator: std.mem.Allocator) !void {
    const file_data = try readInputFile(allocator, "day8_input.txt");
    const trimmed = std.mem.trim(u8, file_data, &std.ascii.whitespace);
    const solution = advent_2025.day8_playground_circuits(trimmed, 1000);
    std.debug.print("[day 8] solution part 1: {d}\n", .{solution});

    const solution2 = advent_2025.day8_last_connection_x_product(trimmed);
    std.debug.print("[day 8] solution part 2: {d}\n", .{solution2});
}
