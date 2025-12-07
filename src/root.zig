const std = @import("std");
const assert = std.debug.assert;

pub fn day1_crack_safe_part_1(input: []const u8) u32 {
    var pos: i32 = 50;
    var count: u32 = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        if (line.len < 2) continue;
        const direction: i8 = if (line[0] == 'L') -1 else 1;
        const amount = std.fmt.parseInt(i32, line[1..], 10) catch continue;
        const delta = direction * amount;
        pos = @mod(pos + delta, 100);
        if (pos == 0) count += 1;
    }
    return count;
}

pub fn day1_crack_safe_part_2(input: []const u8) u32 {
    var sum: i32 = 50;
    var count: u32 = 0;

    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        if (line.len < 2) continue;
        const prev = sum;
        const sign: i32 = if (line[0] == 'L') -1 else 1;
        const amount = std.fmt.parseInt(i32, line[1..], 10) catch continue;
        sum += sign * amount;

        if (sum > prev) {
            count += @intCast(@divFloor(sum, 100) - @divFloor(prev, 100));
        } else {
            count += @intCast(@divFloor(prev - 1, 100) - @divFloor(sum - 1, 100));
        }
    }

    return count;
}

test "day 1 - part 1 - crack safe" {
    const input =
        \\L68
        \\L30
        \\R48
        \\L5
        \\R60
        \\L55
        \\L1
        \\L99
        \\R14
        \\L82
    ;

    try std.testing.expect(day1_crack_safe_part_1(input) == 3);
}

test "day 1 - part 2 - crack safe" {
    const input =
        \\L68
        \\L30
        \\R48
        \\L5
        \\R60
        \\L55
        \\L1
        \\L99
        \\R14
        \\L82
    ;

    try std.testing.expect(day1_crack_safe_part_2(input) == 6);
}
fn sumRange(lo: u64, hi: u64) u64 {
    if (hi < lo) return 0;
    const count = hi - lo + 1;
    return count * (lo + hi) / 2;
}

pub fn day2_clear_duplicates(data: []const u8) u64 {
    var total: u64 = 0;

    var ranges = std.mem.splitScalar(u8, data, ',');
    while (ranges.next()) |range| {
        var parts = std.mem.splitScalar(u8, range, '-');
        const start = std.fmt.parseInt(u64, parts.next().?, 10) catch continue;
        const end = std.fmt.parseInt(u64, parts.next().?, 10) catch continue;

        var power: u64 = 10;
        var n_min: u64 = 1;
        var n_max: u64 = 9;

        while (n_min * (power + 1) <= end) {
            const multiplier = power + 1;

            const lo = @max(n_min, (start + multiplier - 1) / multiplier);
            const hi = @min(n_max, end / multiplier);

            if (lo <= hi) {
                total += sumRange(lo, hi) * multiplier;
            }

            n_min = n_max + 1;
            n_max = n_max * 10 + 9;
            power *= 10;
        }
    }

    return total;
}

test "day2-1" {
    const data = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";

    try std.testing.expectEqual(@as(u64, 1227775554), day2_clear_duplicates(data));
}

test "day2-2" {
    const data = "9226466333-9226692707,55432-96230,4151-6365,686836-836582,519296-634281,355894-471980,971626-1037744,25107-44804,15139904-15163735,155452-255998,2093-4136,829776608-829880425,4444385616-4444502989,2208288-2231858,261-399,66-119,91876508-91956018,2828255673-2828317078,312330-341840,6464-10967,5489467-5621638,1-18,426-834,3434321102-3434378477,4865070-4972019,54475091-54592515,147-257,48664376-48836792,45-61,1183-1877,24-43";

    try std.testing.expectEqual(@as(u64, 38158151648), day2_clear_duplicates(data));
}

pub fn day2_part2(data: []const u8) u64 {
    var invalids: std.ArrayListUnmanaged(u64) = .{};
    defer invalids.deinit(std.heap.page_allocator);

    for (1..11) |k| {
        const base: u64 = std.math.pow(u64, 10, @intCast(k));
        const n_min: u64 = if (k == 1) 1 else base / 10;

        for (2..14) |r| {
            var mult: u64 = 0;
            var term: u64 = 1;
            for (0..r) |_| {
                mult +|= term;
                term *|= base;
            }

            var n = n_min;
            while (n < base) : (n += 1) {
                const val = n *| mult;
                if (val > 99_999_999_999) break;
                invalids.append(std.heap.page_allocator, val) catch {};
            }
        }
    }

    std.mem.sort(u64, invalids.items, {}, std.sort.asc(u64));

    var total: u64 = 0;
    var last: u64 = 0;
    var ranges = std.mem.splitScalar(u8, data, ',');

    for (invalids.items) |val| {
        if (val == last) continue;
        last = val;

        ranges.reset();
        while (ranges.next()) |range_raw| {
            const range = std.mem.trim(u8, range_raw, &std.ascii.whitespace);
            var parts = std.mem.splitScalar(u8, range, '-');
            const start = std.fmt.parseInt(u64, parts.next() orelse continue, 10) catch continue;
            const end = std.fmt.parseInt(u64, parts.next() orelse continue, 10) catch continue;
            if (val >= start and val <= end) {
                total += val;
                break;
            }
        }
    }

    return total;
}
test "day2-3" {
    const data = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    try std.testing.expectEqual(@as(u64, 4174379265), day2_part2(data));
}

fn isRepeated(n: u64) bool {
    var buf: [20]u8 = undefined;
    const s = std.fmt.bufPrint(&buf, "{d}", .{n}) catch return false;
    const len = s.len;

    if (len < 2) return false;

    var k: usize = 1;
    while (k * 2 <= len) : (k += 1) {
        if (len % k != 0) continue;
        if (std.mem.eql(u8, s[0 .. len - k], s[k..len])) return true;
    }
    return false;
}

pub fn day2_part2_simple(input: []const u8) u64 {
    var total: u64 = 0;
    var ranges = std.mem.splitScalar(u8, input, ',');

    while (ranges.next()) |range| {
        var parts = std.mem.splitScalar(u8, range, '-');
        const start = std.fmt.parseInt(u64, parts.next().?, 10) catch continue;
        const end = std.fmt.parseInt(u64, parts.next().?, 10) catch continue;

        var n = start;
        while (n <= end) : (n += 1) {
            if (isRepeated(n)) {
                total += n;
            }
        }
    }

    return total;
}

test "isRepeated" {
    try std.testing.expect(isRepeated(11));
    try std.testing.expect(isRepeated(99));
    try std.testing.expect(isRepeated(111));
    try std.testing.expect(isRepeated(123123));
    try std.testing.expect(isRepeated(123123123));
    try std.testing.expect(isRepeated(1111111));
    try std.testing.expect(isRepeated(1212121212));

    try std.testing.expect(!isRepeated(12));
    try std.testing.expect(!isRepeated(101));
    try std.testing.expect(!isRepeated(1234));
}

test "day2_part2_simple" {
    const data = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    try std.testing.expectEqual(@as(u64, 4174379265), day2_part2_simple(data));
}

pub fn maxJoltage(data: []const u8) u32 {
    var first_val: u8 = data[0];
    var first_idx: usize = 0;
    for (data[1 .. data.len - 1], 1..) |value, i| {
        if (value > first_val) {
            first_val = value;
            first_idx = i;
        }
    }

    var second_val: u8 = data[first_idx + 1];
    for (data[first_idx + 2 ..]) |value| {
        if (value > second_val) {
            second_val = value;
        }
    }

    return (first_val - '0') * 10 + (second_val - '0');
}

pub fn totalJoltage(data: []const u8) u32 {
    var total: u32 = 0;
    var lines = std.mem.splitScalar(u8, data, '\n');
    while (lines.next()) |line| {
        if (line.len >= 2) {
            total += maxJoltage(line);
        }
    }
    return total;
}

pub fn maxJoltageN(data: []const u8, comptime n: usize) u64 {
    const to_skip = data.len - n;
    var result: u64 = 0;
    var pos: usize = 0;
    var skipped: usize = 0;

    for (0..n) |_| {
        const window_end = pos + (to_skip - skipped) + 1;
        const window = data[pos..window_end];

        var best_idx: usize = 0;
        for (window[1..], 1..) |val, i| {
            if (val > window[best_idx]) {
                best_idx = i;
            }
        }

        result = result * 10 + (window[best_idx] - '0');
        skipped += best_idx;
        pos += best_idx + 1;
    }

    return result;
}

pub fn totalJoltageN(data: []const u8, comptime n: usize) u64 {
    var total: u64 = 0;
    var lines = std.mem.splitScalar(u8, data, '\n');
    while (lines.next()) |line| {
        if (line.len >= n) {
            total += maxJoltageN(line, n);
        }
    }
    return total;
}

test "maxJoltageN" {
    const cases = .{
        .{ .input = "987654321111111", .expected = 987654321111 },
        .{ .input = "811111111111119", .expected = 811111111119 },
        .{ .input = "234234234234278", .expected = 434234234278 },
        .{ .input = "818181911112111", .expected = 888911112111 },
    };

    inline for (cases) |tc| {
        try std.testing.expectEqual(tc.expected, maxJoltageN(tc.input, 12));
    }
}

test "totalJoltageN" {
    const input =
        \\987654321111111
        \\811111111111119
        \\234234234234278
        \\818181911112111
    ;
    try std.testing.expectEqual(3121910778619, totalJoltageN(input, 12));
}

test "totalJoltage" {
    const input =
        \\987654321111111
        \\811111111111119
        \\234234234234278
        \\818181911112111
    ;
    try std.testing.expectEqual(357, totalJoltage(input));
}

test "maxJoltage" {
    const cases = .{
        .{ .input = "987654321111111", .expected = 98 },
        .{ .input = "811111111111119", .expected = 89 },
        .{ .input = "234234234234278", .expected = 78 },
        .{ .input = "818181911112111", .expected = 92 },
    };

    inline for (cases) |tc| {
        try std.testing.expectEqual(tc.expected, maxJoltage(tc.input));
    }
}

fn getGridCell(data: []const u8, width: usize, height: usize, row: i64, col: i64) ?u8 {
    if (row < 0 or col < 0 or row >= height or col >= width) return null;
    const stride = width + 1;
    const idx = @as(usize, @intCast(row)) * stride + @as(usize, @intCast(col));
    if (idx >= data.len) return null;
    return data[idx];
}

fn countAdjacentRolls(data: []const u8, width: usize, height: usize, row: usize, col: usize) u8 {
    const offsets = [_][2]i8{
        .{ -1, -1 }, .{ -1, 0 }, .{ -1, 1 },
        .{ 0, -1 },  .{ 0, 1 },  .{ 1, -1 },
        .{ 1, 0 },   .{ 1, 1 },
    };

    var count: u8 = 0;
    for (offsets) |offset| {
        const new_row = @as(i64, @intCast(row)) + offset[0];
        const new_col = @as(i64, @intCast(col)) + offset[1];

        if (getGridCell(data, width, height, new_row, new_col)) |cell| {
            if (cell == '@') count += 1;
        }
    }
    return count;
}

pub fn day4_accessible_rolls(input: []const u8) u32 {
    const width = std.mem.indexOfScalar(u8, input, '\n') orelse input.len;
    if (width == 0) return 0;

    const stride = width + 1;
    const height = (input.len + 1) / stride;

    var accessible_count: u32 = 0;

    for (0..height) |row| {
        for (0..width) |col| {
            const idx = row * stride + col;
            if (idx >= input.len) continue;
            if (input[idx] != '@') continue;

            const neighbor_count = countAdjacentRolls(input, width, height, row, col);
            if (neighbor_count < 4) {
                accessible_count += 1;
            }
        }
    }

    return accessible_count;
}

fn countAdjacentRollsMut(grid: []u8, width: usize, height: usize, row: usize, col: usize) u8 {
    const offsets = [_][2]i8{
        .{ -1, -1 }, .{ -1, 0 }, .{ -1, 1 },
        .{ 0, -1 },  .{ 0, 1 },  .{ 1, -1 },
        .{ 1, 0 },   .{ 1, 1 },
    };

    const stride = width + 1;
    var count: u8 = 0;

    for (offsets) |offset| {
        const new_row = @as(i64, @intCast(row)) + offset[0];
        const new_col = @as(i64, @intCast(col)) + offset[1];

        if (new_row < 0 or new_col < 0 or new_row >= height or new_col >= width) continue;

        const idx = @as(usize, @intCast(new_row)) * stride + @as(usize, @intCast(new_col));
        if (idx < grid.len and grid[idx] == '@') count += 1;
    }
    return count;
}

fn findAccessibleRolls(grid: []u8, width: usize, height: usize, accessible: []usize) usize {
    const stride = width + 1;
    var count: usize = 0;

    for (0..height) |row| {
        for (0..width) |col| {
            const idx = row * stride + col;
            if (idx >= grid.len or grid[idx] != '@') continue;

            const neighbor_count = countAdjacentRollsMut(grid, width, height, row, col);
            if (neighbor_count < 4) {
                accessible[count] = idx;
                count += 1;
            }
        }
    }
    return count;
}

fn removeRolls(grid: []u8, indices: []const usize) void {
    for (indices) |idx| {
        grid[idx] = '.';
    }
}

pub fn day4_total_removable_rolls(input: []const u8) u32 {
    const width = std.mem.indexOfScalar(u8, input, '\n') orelse input.len;
    if (width == 0) return 0;

    const stride = width + 1;
    const height = (input.len + 1) / stride;

    var grid: [256 * 256]u8 = undefined;
    @memcpy(grid[0..input.len], input);
    const grid_slice = grid[0..input.len];

    var accessible_buf: [256 * 256]usize = undefined;
    var total_removed: u32 = 0;

    while (true) {
        const accessible_count = findAccessibleRolls(grid_slice, width, height, &accessible_buf);
        if (accessible_count == 0) break;

        removeRolls(grid_slice, accessible_buf[0..accessible_count]);
        total_removed += @intCast(accessible_count);
    }

    return total_removed;
}

test "day4 - accessible paper rolls" {
    const input =
        \\..@@.@@@@.
        \\@@@.@.@.@@
        \\@@@@@.@.@@
        \\@.@@@@..@.
        \\@@.@@@@.@@
        \\.@@@@@@@.@
        \\.@.@.@.@@@
        \\@.@@@.@@@@
        \\.@@@@@@@@.
        \\@.@.@@@.@.
    ;

    try std.testing.expectEqual(13, day4_accessible_rolls(input));
    try std.testing.expectEqual(43, day4_total_removable_rolls(input));
}

const Range = struct {
    start: u64,
    end: u64,
};

fn parseRanges(range_section: []const u8, buffer: []Range) []Range {
    var count: usize = 0;
    var lines = std.mem.splitScalar(u8, range_section, '\n');

    while (lines.next()) |line| {
        if (line.len == 0) continue;
        if (count >= buffer.len) break;

        var parts = std.mem.splitScalar(u8, line, '-');
        const start = std.fmt.parseInt(u64, parts.next() orelse continue, 10) catch continue;
        const end = std.fmt.parseInt(u64, parts.next() orelse continue, 10) catch continue;

        buffer[count] = Range{ .start = start, .end = end };
        count += 1;
    }

    return buffer[0..count];
}

fn compareRangesByStart(_: void, a: Range, b: Range) bool {
    return a.start < b.start;
}

fn mergeRanges(ranges: []Range) []Range {
    if (ranges.len == 0) return ranges[0..0];

    std.mem.sort(Range, ranges, {}, compareRangesByStart);

    var write_idx: usize = 0;
    for (ranges[1..]) |current| {
        if (current.start <= ranges[write_idx].end + 1) {
            ranges[write_idx].end = @max(ranges[write_idx].end, current.end);
        } else {
            write_idx += 1;
            ranges[write_idx] = current;
        }
    }

    return ranges[0 .. write_idx + 1];
}

fn parseAndSortIngredients(ingredient_section: []const u8, buffer: []u64) []u64 {
    var count: usize = 0;
    var lines = std.mem.splitScalar(u8, ingredient_section, '\n');

    while (lines.next()) |line| {
        if (line.len == 0) continue;
        if (count >= buffer.len) break;

        buffer[count] = std.fmt.parseInt(u64, line, 10) catch continue;
        count += 1;
    }

    const result = buffer[0..count];
    std.mem.sort(u64, result, {}, std.sort.asc(u64));
    return result;
}

fn countFreshIngredients(merged_ranges: []const Range, sorted_ingredients: []const u64) u32 {
    var fresh_count: u32 = 0;
    var range_idx: usize = 0;

    for (sorted_ingredients) |ingredient| {
        while (range_idx < merged_ranges.len and merged_ranges[range_idx].end < ingredient) {
            range_idx += 1;
        }

        if (range_idx >= merged_ranges.len) break;

        if (ingredient >= merged_ranges[range_idx].start and ingredient <= merged_ranges[range_idx].end) {
            fresh_count += 1;
        }
    }

    return fresh_count;
}

pub fn day5_fresh_ingredients(input: []const u8) u32 {
    var sections = std.mem.splitSequence(u8, input, "\n\n");
    const range_section = sections.next() orelse return 0;
    const ingredient_section = sections.next() orelse return 0;

    var range_buffer: [1024]Range = undefined;
    var ingredient_buffer: [4096]u64 = undefined;

    const ranges = parseRanges(range_section, &range_buffer);
    const merged_ranges = mergeRanges(ranges);
    const sorted_ingredients = parseAndSortIngredients(ingredient_section, &ingredient_buffer);

    return countFreshIngredients(merged_ranges, sorted_ingredients);
}

fn sumRangeSizes(merged_ranges: []const Range) u64 {
    var total: u64 = 0;
    for (merged_ranges) |range| {
        total += range.end - range.start + 1;
    }
    return total;
}

pub fn day5_total_fresh_ids(input: []const u8) u64 {
    var sections = std.mem.splitSequence(u8, input, "\n\n");
    const range_section = sections.next() orelse return 0;

    var range_buffer: [1024]Range = undefined;

    const ranges = parseRanges(range_section, &range_buffer);
    const merged_ranges = mergeRanges(ranges);

    return sumRangeSizes(merged_ranges);
}

test "day5 - fresh ingredients" {
    const input =
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

    try std.testing.expectEqual(3, day5_fresh_ingredients(input));
}

fn parseNumber(slice: []const u8) u64 {
    var result: u64 = 0;
    for (slice) |c| {
        if (c >= '0' and c <= '9') {
            result = result * 10 + (c - '0');
        }
    }
    return result;
}

fn isColumnAllSpaces(lines: []const []const u8, col: usize) bool {
    for (lines) |line| {
        if (col < line.len and line[col] != ' ') return false;
    }
    return true;
}

pub fn day6_cephalopod_math(input: []const u8) u64 {
    var lines: [64][]const u8 = undefined;
    var line_count: usize = 0;
    var max_len: usize = 0;

    var iter = std.mem.splitScalar(u8, input, '\n');
    while (iter.next()) |line| {
        if (line.len > 0) {
            lines[line_count] = line;
            max_len = @max(max_len, line.len);
            line_count += 1;
        }
    }

    if (line_count < 2) return 0;

    const all_lines = lines[0..line_count];
    const data_lines = lines[0 .. line_count - 1];
    const op_line = lines[line_count - 1];

    var grand_total: u64 = 0;
    var col: usize = 0;

    while (col < max_len) {
        while (col < max_len and isColumnAllSpaces(all_lines, col)) : (col += 1) {}
        if (col >= max_len) break;

        const start_col = col;
        while (col < max_len and !isColumnAllSpaces(all_lines, col)) : (col += 1) {}
        const end_col = col;

        var operator: u8 = '+';
        for (start_col..end_col) |c| {
            if (c < op_line.len and (op_line[c] == '+' or op_line[c] == '*')) {
                operator = op_line[c];
                break;
            }
        }

        var result: u64 = 0;
        var first = true;
        for (data_lines) |line| {
            const s = @min(start_col, line.len);
            const e = @min(end_col, line.len);
            if (s < e) {
                const n = parseNumber(line[s..e]);
                if (first) {
                    result = n;
                    first = false;
                } else if (operator == '+') {
                    result += n;
                } else {
                    result *= n;
                }
            }
        }

        grand_total += result;
    }

    return grand_total;
}

pub fn day6_cephalopod_math_part2(input: []const u8) u64 {
    var lines: [64][]const u8 = undefined;
    var line_count: usize = 0;
    var max_len: usize = 0;

    var iter = std.mem.splitScalar(u8, input, '\n');
    while (iter.next()) |line| {
        if (line.len > 0) {
            lines[line_count] = line;
            max_len = @max(max_len, line.len);
            line_count += 1;
        }
    }

    if (line_count < 2) return 0;

    const all_lines = lines[0..line_count];
    const data_lines = lines[0 .. line_count - 1];
    const op_line = lines[line_count - 1];

    var grand_total: u64 = 0;
    var col: usize = 0;

    while (col < max_len) {
        while (col < max_len and isColumnAllSpaces(all_lines, col)) : (col += 1) {}
        if (col >= max_len) break;

        const start_col = col;
        while (col < max_len and !isColumnAllSpaces(all_lines, col)) : (col += 1) {}
        const end_col = col;

        var operator: u8 = '+';
        for (start_col..end_col) |c| {
            if (c < op_line.len and (op_line[c] == '+' or op_line[c] == '*')) {
                operator = op_line[c];
                break;
            }
        }

        var result: u64 = 0;
        var first = true;
        var c: usize = end_col;
        while (c > start_col) {
            c -= 1;
            var num: u64 = 0;
            var has_digit = false;
            for (data_lines) |line| {
                if (c < line.len and line[c] >= '0' and line[c] <= '9') {
                    num = num * 10 + (line[c] - '0');
                    has_digit = true;
                }
            }
            if (has_digit) {
                if (first) {
                    result = num;
                    first = false;
                } else if (operator == '+') {
                    result += num;
                } else {
                    result *= num;
                }
            }
        }

        grand_total += result;
    }

    return grand_total;
}

test "day6 - cephalopod math" {
    const input =
        \\123 328  51 64
        \\ 45 64  387 23
        \\  6 98  215 314
        \\*   +   *   +
    ;

    try std.testing.expectEqual(@as(u64, 4277556), day6_cephalopod_math(input));
    try std.testing.expectEqual(@as(u64, 3263827), day6_cephalopod_math_part2(input));
}

const Grid = struct {
    width: usize,
    height: usize,
    stride: usize,
    start_col: usize,

    fn parse(input: []const u8) ?Grid {
        const width = std.mem.indexOfScalar(u8, input, '\n') orelse input.len;
        if (width == 0) return null;

        const stride = width + 1;
        const height = (input.len + 1) / stride;
        const s_idx = std.mem.indexOfScalar(u8, input, 'S') orelse return null;

        return .{
            .width = width,
            .height = height,
            .stride = stride,
            .start_col = s_idx % stride,
        };
    }
};

fn propagateBeams(
    input: []const u8,
    grid: Grid,
    current: []const u64,
    next: []u64,
) u32 {
    var splits: u32 = 0;

    for (current[0..grid.width], 0..) |count, col| {
        if (count == 0) continue;

        const is_splitter = input[col] == '^';
        if (is_splitter) {
            splits += 1;
            if (col > 0) next[col - 1] += count;
            if (col + 1 < grid.width) next[col + 1] += count;
        } else {
            next[col] += count;
        }
    }

    return splits;
}

pub fn day7_tachyon_splits(input: []const u8) u32 {
    const result = day7_solve(input);
    return result.splits;
}

pub fn day7_tachyon_timelines(input: []const u8) u64 {
    const result = day7_solve(input);
    return result.timelines;
}

fn day7_solve(input: []const u8) struct { splits: u32, timelines: u64 } {
    const grid = Grid.parse(input) orelse return .{ .splits = 0, .timelines = 0 };

    var buffers: [2][512]u64 = .{ .{0} ** 512, .{0} ** 512 };
    buffers[0][grid.start_col] = 1;

    var split_count: u32 = 0;
    var current: usize = 0;

    for (1..grid.height) |row| {
        const next = 1 - current;
        @memset(buffers[next][0..grid.width], 0);

        const row_start = row * grid.stride;
        split_count += propagateBeams(
            input[row_start..],
            grid,
            &buffers[current],
            &buffers[next],
        );

        current = next;
    }

    var total: u64 = 0;
    for (buffers[current][0..grid.width]) |count| {
        total += count;
    }

    return .{ .splits = split_count, .timelines = total };
}

test "day7 - tachyon splits" {
    const input =
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

    try std.testing.expectEqual(@as(u32, 21), day7_tachyon_splits(input));
    try std.testing.expectEqual(@as(u64, 40), day7_tachyon_timelines(input));
}
