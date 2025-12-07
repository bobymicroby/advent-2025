const std = @import("std");

const advent = @import("root.zig");

const WARMUP_ITERATIONS = 100;
const BENCH_ITERATIONS = 10_000;

const day5_input =
    \\3-5
    \\10-14
    \\16-20
    \\12-18
    \\
    \\1
    \\5
    \\8
    \\11
    \\17
    \\32
;

const day6_input =
    \\123 328  51 64
    \\ 45 64  387 23
    \\  6 98  215 314
    \\*   +   *   +
;

const day7_input =
    \\.......S.......
    \\...............
    \\.......^.......
    \\...............
    \\......^.^......
    \\...............
    \\.....^.^.^.....
    \\...............
    \\....^.^...^....
    \\...............
    \\...^.^...^.^...
    \\...............
    \\..^...^.....^..
    \\...............
    \\.^.^.^.^.^...^.
    \\...............
;

fn benchmark(comptime func: anytype, input: []const u8) u64 {
    var timer = std.time.Timer.start() catch return 0;

    for (0..WARMUP_ITERATIONS) |_| {
        std.mem.doNotOptimizeAway(func(input));
    }

    timer.reset();

    for (0..BENCH_ITERATIONS) |_| {
        std.mem.doNotOptimizeAway(func(input));
    }

    return timer.read() / BENCH_ITERATIONS;
}

pub fn main() void {
    std.debug.print("Benchmark\n", .{});
    std.debug.print("───────────────────────────────\n", .{});
    std.debug.print("Warmup iterations:  {d}\n", .{WARMUP_ITERATIONS});
    std.debug.print("Bench iterations:   {d}\n", .{BENCH_ITERATIONS});
    std.debug.print("───────────────────────────────\n", .{});

    std.debug.print("day5_fresh_ingredients: {d} ns/iter\n", .{benchmark(advent.day5_fresh_ingredients, day5_input)});
    std.debug.print("day5_total_fresh_ids  : {d} ns/iter\n", .{benchmark(advent.day5_total_fresh_ids, day5_input)});
    std.debug.print("day6_cephalopod_math  : {d} ns/iter\n", .{benchmark(advent.day6_cephalopod_math, day6_input)});
    std.debug.print("day6_cephalopod_part2 : {d} ns/iter\n", .{benchmark(advent.day6_cephalopod_math_part2, day6_input)});
    std.debug.print("day7_tachyon_splits   : {d} ns/iter\n", .{benchmark(advent.day7_tachyon_splits, day7_input)});
    std.debug.print("day7_tachyon_timelines: {d} ns/iter\n", .{benchmark(advent.day7_tachyon_timelines, day7_input)});
}
