const std = @import("std");
const min_heap = @import("min_heap.zig");
const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var heap = min_heap.MinHeap.init(allocator);

    defer heap.deinit();

    try heap.insert(4);
    try heap.insert(2);
    try heap.insert(6);
    try heap.insert(12);
    try heap.insert(5);
    print("after insert {d}\n", .{heap.heap.items});
    try heap.delete(2);
    print("after delete {d}\n", .{heap.heap.items});
    try heap.insert(23);
    try heap.insert(3);
    try heap.insert(1);
    print("after insert {d}\n", .{heap.heap.items});
    try heap.delete(6);

    print("after delete {d}\n", .{heap.heap.items});
}
