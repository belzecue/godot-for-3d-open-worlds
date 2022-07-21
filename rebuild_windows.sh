#!/bin/sh

# For windows
export MINGW32_PREFIX="/usr/bin/i686-w64-mingw32-"
export MINGW64_PREFIX="/usr/bin/x86_64-w64-mingw32-"

# For incremental
export SCONS_CACHE="./scons_cache_windows";
mkdir -p $SCONS_CACHE

${MINGW32_PREFIX}gcc --version
${MINGW64_PREFIX}gcc --version

# Target controls optimization and debug flags. Each mode means:
# debug: Build with C++ debugging symbols, runtime checks 
#		(performs checks and reports error) and none to little optimization.
# release_debug: Build without C++ debugging symbols and optimization, 
#		but keep the runtime checks (performs checks and reports errors). 
#		Official editor binaries use this configuration.
# release: Build without symbols, with optimization and with little to no runtime checks. 
#		This target can't be used together with tools=yes, as the editor requires some debug 
# 		functionality and run-time checks to run.

# Cross-compiling from some Ubuntu versions may lead to this bug, 
# due to a default configuration lacking support for POSIX threading.
# You can change that configuration following those instructions, for 64-bit:
#
#   sudo update-alternatives --config x86_64-w64-mingw32-gcc
#   <choose x86_64-w64-mingw32-gcc-posix from the list>
#   sudo update-alternatives --config x86_64-w64-mingw32-g++
#   <choose x86_64-w64-mingw32-g++-posix from the list>

# Editor (tools)
scons -j1 tools=yes target=release_debug debug_symbols=no platform=windows bits=64 2>&1 | tee ./logs/scons_windows_tools_build.log;
# Template(s)
scons -j1 tools=no target=release_debug debug_symbols=no platform=windows bits=64 2>&1 | tee ./logs/scons_windows_debug_build.log;

# Removing debug symbols
strip ./bin/godot.windows.*
