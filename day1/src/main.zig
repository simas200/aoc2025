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
    for (opList) |op| {
        //if (&op == null ) break;
        pos = rotate(pos, op.dir, op.size);
        if (pos == 0) {
            res += 1;
        }
    }
    std.debug.print("{d}", .{res});
    //std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
    //std.debug.print("{s}", .{try std.fs.cwd()});
    //try day1.bufferedPrint();
}

pub fn rotate(curr: i32, dir: Dir, size: i32) i32 {
    var temp: i32 = 0;
    std.debug.print("Curr: {d}, dir: {s}, size: {d}\n", .{curr, @tagName(dir), size});
    switch (dir) {
        Dir.left => {
            temp = @rem((curr - size + 100),100);
        },
        Dir.right => {
            temp = @rem((curr + size),100);
        },
        Dir.end => {}
    }
    return temp;
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
        //std.debug.print("{s}, len: {d}\n", .{line, line.len});
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
