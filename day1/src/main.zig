const std = @import("std");
//const fs = @import("std.fs");
const day1 = @import("day1");

const Dir = enum(u8) {
    left = 'L',
    right = 'R',
    end = 'E',
};

const Op = struct {
    dir: Dir,
    size: i32,
};

pub fn main() !void {
    const opList = try read("input");
    var pos: i32 = 50;
    var res: i32 = 0;
//    for (opList) |op| {
//        pos = rotate(pos, op.dir, op.size);
//        if (pos == 0) {
//            res += 1;
//        }
//    }
//    pos = 50;
//    res = 0;
    for (opList) |op| {

        const thing = rotate2(pos, op.dir, op.size);
        res += thing[0];
        pos = thing[1];
    }
    std.debug.print("{d}", .{res});
}

pub fn rotate(curr: i32, dir: Dir, size: i32) i32 {
    var temp: i32 = 0;
    std.debug.print("Curr: {d}, dir: {s}, size: {d}\n", .{curr, @tagName(dir), size});
    switch (dir) {
        Dir.left => {
            temp = @rem((curr - size),100);
            if (temp < 0) {
                temp += 100;
            }
        },
        Dir.right => {
            temp = @rem((curr + size),100);
        },
        Dir.end => {}
    }
    return temp;
}

pub fn rotate2(curr: i32, dir: Dir, size: i32) struct{i32, i32} {
    var temp: i32 = 0;
    var count: i32 = 0;
    if (dir == Dir.right) { std.debug.print("Curr: {d}, dir: {s}, size: {d}\n", .{curr, @tagName(dir), size}); }
    switch (dir) {
        Dir.left => {
            count = @divTrunc((curr - size), 100);
            if (count < 0) { count = -count; }
            temp = @rem((curr - size),100);
            if (temp < 0) { temp += 100; }
            if ((curr - size) <= 0 ) { count += 1; }
        },
        Dir.right => {
            count = @divTrunc((size + curr), 100);
            temp = @rem((curr + size),100);
        },
        Dir.end => {}
    }
    if (dir == Dir.right) { std.debug.print("Count: {d}, pos: {d}\n", .{count, temp});}
    return .{count, temp};
}

pub fn read(path: []const u8) ![]Op {
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var buf: [1024]u8 = undefined;
    var opList: [10000]Op = undefined;
    var fileReader = file.reader(&buf);
    const reader = &fileReader.interface;
    var i: usize = 0;
    while (reader.takeDelimiterExclusive('\n')) |line| {
        const dir: Dir = switch(line[0]) {
            'L' => Dir.left,
            'R' => Dir.right,
            else => Dir.end
        };
        if (dir != Dir.end) {
            const op: Op = .{
                .dir = dir,
                .size = try std.fmt.parseInt(i32, line[1..], 10),
            };
            opList[i] = op;
            i+=1;
            _ = try reader.take(1);
        }
    } else |_| {}
    return opList[0..i];
}
