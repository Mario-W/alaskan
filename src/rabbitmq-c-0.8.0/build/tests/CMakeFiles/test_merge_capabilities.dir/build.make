# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.9

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /Applications/CMake.app/Contents/bin/cmake

# The command to remove a file.
RM = /Applications/CMake.app/Contents/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build

# Include any dependencies generated for this target.
include tests/CMakeFiles/test_merge_capabilities.dir/depend.make

# Include the progress variables for this target.
include tests/CMakeFiles/test_merge_capabilities.dir/progress.make

# Include the compile flags for this target's objects.
include tests/CMakeFiles/test_merge_capabilities.dir/flags.make

tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o: tests/CMakeFiles/test_merge_capabilities.dir/flags.make
tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o: ../tests/test_merge_capabilities.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/tests && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o   -c /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/tests/test_merge_capabilities.c

tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.i"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/tests && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/tests/test_merge_capabilities.c > CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.i

tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.s"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/tests && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/tests/test_merge_capabilities.c -o CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.s

tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o.requires:

.PHONY : tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o.requires

tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o.provides: tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o.requires
	$(MAKE) -f tests/CMakeFiles/test_merge_capabilities.dir/build.make tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o.provides.build
.PHONY : tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o.provides

tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o.provides.build: tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o


# Object files for target test_merge_capabilities
test_merge_capabilities_OBJECTS = \
"CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o"

# External object files for target test_merge_capabilities
test_merge_capabilities_EXTERNAL_OBJECTS =

tests/test_merge_capabilities: tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o
tests/test_merge_capabilities: tests/CMakeFiles/test_merge_capabilities.dir/build.make
tests/test_merge_capabilities: librabbitmq/librabbitmq.a
tests/test_merge_capabilities: /usr/local/opt/openssl/lib/libssl.dylib
tests/test_merge_capabilities: /usr/local/opt/openssl/lib/libcrypto.dylib
tests/test_merge_capabilities: tests/CMakeFiles/test_merge_capabilities.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable test_merge_capabilities"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/tests && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/test_merge_capabilities.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/CMakeFiles/test_merge_capabilities.dir/build: tests/test_merge_capabilities

.PHONY : tests/CMakeFiles/test_merge_capabilities.dir/build

tests/CMakeFiles/test_merge_capabilities.dir/requires: tests/CMakeFiles/test_merge_capabilities.dir/test_merge_capabilities.c.o.requires

.PHONY : tests/CMakeFiles/test_merge_capabilities.dir/requires

tests/CMakeFiles/test_merge_capabilities.dir/clean:
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/tests && $(CMAKE_COMMAND) -P CMakeFiles/test_merge_capabilities.dir/cmake_clean.cmake
.PHONY : tests/CMakeFiles/test_merge_capabilities.dir/clean

tests/CMakeFiles/test_merge_capabilities.dir/depend:
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0 /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/tests /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/tests /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/tests/CMakeFiles/test_merge_capabilities.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/CMakeFiles/test_merge_capabilities.dir/depend
