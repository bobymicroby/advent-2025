const std = @import("std");

const advent = @import("root.zig");

const WARMUP_ITERATIONS = 100;
const BENCH_ITERATIONS = 10_000;

const test_input =
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

fn benchmarkDay5(input: []const u8) u64 {
    var timer = std.time.Timer.start() catch return 0;

    for (0..WARMUP_ITERATIONS) |_| {
        std.mem.doNotOptimizeAway(advent.day5_fresh_ingredients(input));
    }

    timer.reset();

    for (0..BENCH_ITERATIONS) |_| {
        std.mem.doNotOptimizeAway(advent.day5_fresh_ingredients(input));
    }

    const elapsed_ns = timer.read();
    return elapsed_ns / BENCH_ITERATIONS;
}

fn benchmarkDay5_part2(input: []const u8) u64 {
    var timer = std.time.Timer.start() catch return 0;

    for (0..WARMUP_ITERATIONS) |_| {
        std.mem.doNotOptimizeAway(advent.day5_total_fresh_ids(input));
    }

    timer.reset();

    for (0..BENCH_ITERATIONS) |_| {
        std.mem.doNotOptimizeAway(advent.day5_total_fresh_ids(input));
    }

    const elapsed_ns = timer.read();
    return elapsed_ns / BENCH_ITERATIONS;
}

pub fn main() void {
    std.debug.print("Day 5 Benchmark\n", .{});
    std.debug.print("───────────────────────────────\n", .{});
    std.debug.print("Warmup iterations:  {d}\n", .{WARMUP_ITERATIONS});
    std.debug.print("Bench iterations:   {d}\n", .{BENCH_ITERATIONS});
    std.debug.print("───────────────────────────────\n", .{});

    const ns_per_call = benchmarkDay5(test_input);
    const ns_per_call_2 = benchmarkDay5_part2(test_input);
    std.debug.print("day5_fresh_ingredients: {d} ns/iteration\n", .{ns_per_call});
    std.debug.print("day5_total_fresh_ids  : {d} ns/iteration\n", .{ns_per_call_2});
}
