const std = @import("std");
const print = std.debug.print;

const MinHeap = struct {
    heap: std.ArrayList(u64),

    pub fn init(allocator: std.mem.Allocator) MinHeap {
        return MinHeap{ .heap = std.ArrayList(u64).init(allocator) };
    }

    pub fn deinit(self: *MinHeap) void {
        self.heap.deinit();
    }

    pub fn insert(self: *MinHeap, el: u64) !void {
        try self.heap.append(el);
        self.heapifyUp();
    }

    fn get_index(self: MinHeap, el: u64) u64 {
        for (self.heap.items, 0..) |item, current_index| {
            if (item == el) {
                return current_index;
            }
        }
        return 0;
    }

    pub fn delete(self: *MinHeap, el: u64) !void {
        if (self.heap.items.len == 0) {
            return;
        }

        const index = self.get_index(el);
        if (index == -1) {
            return;
        }

        const last = self.heap.pop();
        if (index == self.heap.items.len) {
            return;
        }
        self.heap.items[index] = last;

        try self.heapifyDown(index);
    }

    fn heapifyDown(self: *MinHeap, index: u64) !void {
        const el = self.heap.items[index];

        const left_child_index = 2 * index + 1;
        const right_child_index = 2 * index + 2;
        var smallest = index;

        if (left_child_index < self.heap.items.len and self.heap.items[left_child_index] < el) {
            smallest = left_child_index;
        }
        if (right_child_index < self.heap.items.len and self.heap.items[right_child_index] < el) {
            smallest = right_child_index;
        }

        if (smallest != index) {
            self.heap.items[index] = self.heap.items[smallest];
            self.heap.items[smallest] = el;
            try self.heapifyDown(smallest);
        }
    }

    fn heapifyUp(self: *MinHeap) void {
        var index = self.heap.items.len - 1;
        if (index == 0) {
            return;
        }
        var parent_index = (index - 1) / 2;
        while (index > 0 and self.heap.items[parent_index] > self.heap.items[index]) {
            const parent = self.heap.items[parent_index];
            self.heap.items[parent_index] = self.heap.items[index];
            self.heap.items[index] = parent;
            index = parent_index;
            if (index > 1) {
                parent_index = (index - 1) / 2;
            } else {
                parent_index = 0;
            }
        }
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var heap = MinHeap.init(allocator);

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
