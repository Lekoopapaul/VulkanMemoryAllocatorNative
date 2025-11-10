const std = @import("std");

// Although this function looks imperative, it does not perform the build
// directly and instead it mutates the build graph (`b`) that will be then
// executed by an external runner. The functions in `std.Build` implement a DSL
// for defining build steps and express dependencies between them, allowing the
// build runner to parallelize the build automatically (and the cache system to
// know when a step doesn't need to be re-run).
pub fn build(b: *std.Build) void {
    const target=  b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addLibrary(.{
        .name = "VMA",
        .linkage = .dynamic,
        .root_module = b.createModule(.{
            .root_source_file = null,
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .link_libcpp = true
        }),
    });
    lib.addCSourceFile(.{
        .file = b.path("src/vk_mem_alloc.cpp"),
        .language = .cpp
    });
    lib.addIncludePath(b.path("include/"));
    lib.addIncludePath(b.path("Vulkan-Headers/include/"));

    b.installArtifact(lib);
}
