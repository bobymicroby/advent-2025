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

const day8_input =
    \\162,817,812
    \\57,618,57
    \\906,360,560
    \\592,479,940
    \\352,342,300
    \\466,668,158
    \\542,29,236
    \\431,825,988
    \\739,650,466
    \\52,470,668
    \\216,146,977
    \\819,987,18
    \\117,168,530
    \\805,96,715
    \\346,949,466
    \\970,615,88
    \\941,993,340
    \\862,61,35
    \\984,92,344
    \\425,690,689
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

fn day8_part1_wrapper(input: []const u8) u64 {
    return advent.day8_playground_circuits(input, 10);
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
    std.debug.print("day8_playground       : {d} ns/iter\n", .{benchmark(day8_part1_wrapper, day8_input)});
    std.debug.print("day8_last_connection  : {d} ns/iter\n", .{benchmark(advent.day8_last_connection_x_product, day8_input)});
}
