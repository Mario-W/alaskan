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
include examples/CMakeFiles/amqps_connect_timeout.dir/depend.make

# Include the progress variables for this target.
include examples/CMakeFiles/amqps_connect_timeout.dir/progress.make

# Include the compile flags for this target's objects.
include examples/CMakeFiles/amqps_connect_timeout.dir/flags.make

examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o: examples/CMakeFiles/amqps_connect_timeout.dir/flags.make
examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o: ../examples/amqps_connect_timeout.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o   -c /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/amqps_connect_timeout.c

examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.i"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/amqps_connect_timeout.c > CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.i

examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.s"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/amqps_connect_timeout.c -o CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.s

examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o.requires:

.PHONY : examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o.requires

examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o.provides: examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o.requires
	$(MAKE) -f examples/CMakeFiles/amqps_connect_timeout.dir/build.make examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o.provides.build
.PHONY : examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o.provides

examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o.provides.build: examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o


examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.o: examples/CMakeFiles/amqps_connect_timeout.dir/flags.make
examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.o: ../examples/utils.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.o"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/amqps_connect_timeout.dir/utils.c.o   -c /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/utils.c

examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/amqps_connect_timeout.dir/utils.c.i"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/utils.c > CMakeFiles/amqps_connect_timeout.dir/utils.c.i

examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/amqps_connect_timeout.dir/utils.c.s"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/utils.c -o CMakeFiles/amqps_connect_timeout.dir/utils.c.s

examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.o.requires:

.PHONY : examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.o.requires

examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.o.provides: examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.o.requires
	$(MAKE) -f examples/CMakeFiles/amqps_connect_timeout.dir/build.make examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.o.provides.build
.PHONY : examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.o.provides

examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.o.provides.build: examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.o


examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o: examples/CMakeFiles/amqps_connect_timeout.dir/flags.make
examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o: ../examples/unix/platform_utils.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o   -c /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/unix/platform_utils.c

examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.i"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/unix/platform_utils.c > CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.i

examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.s"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/unix/platform_utils.c -o CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.s

examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o.requires:

.PHONY : examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o.requires

examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o.provides: examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o.requires
	$(MAKE) -f examples/CMakeFiles/amqps_connect_timeout.dir/build.make examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o.provides.build
.PHONY : examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o.provides

examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o.provides.build: examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o


# Object files for target amqps_connect_timeout
amqps_connect_timeout_OBJECTS = \
"CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o" \
"CMakeFiles/amqps_connect_timeout.dir/utils.c.o" \
"CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o"

# External object files for target amqps_connect_timeout
amqps_connect_timeout_EXTERNAL_OBJECTS =

examples/amqps_connect_timeout: examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o
examples/amqps_connect_timeout: examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.o
examples/amqps_connect_timeout: examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o
examples/amqps_connect_timeout: examples/CMakeFiles/amqps_connect_timeout.dir/build.make
examples/amqps_connect_timeout: librabbitmq/librabbitmq.4.2.0.dylib
examples/amqps_connect_timeout: /usr/local/opt/openssl/lib/libssl.dylib
examples/amqps_connect_timeout: /usr/local/opt/openssl/lib/libcrypto.dylib
examples/amqps_connect_timeout: examples/CMakeFiles/amqps_connect_timeout.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking C executable amqps_connect_timeout"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/amqps_connect_timeout.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
examples/CMakeFiles/amqps_connect_timeout.dir/build: examples/amqps_connect_timeout

.PHONY : examples/CMakeFiles/amqps_connect_timeout.dir/build

examples/CMakeFiles/amqps_connect_timeout.dir/requires: examples/CMakeFiles/amqps_connect_timeout.dir/amqps_connect_timeout.c.o.requires
examples/CMakeFiles/amqps_connect_timeout.dir/requires: examples/CMakeFiles/amqps_connect_timeout.dir/utils.c.o.requires
examples/CMakeFiles/amqps_connect_timeout.dir/requires: examples/CMakeFiles/amqps_connect_timeout.dir/unix/platform_utils.c.o.requires

.PHONY : examples/CMakeFiles/amqps_connect_timeout.dir/requires

examples/CMakeFiles/amqps_connect_timeout.dir/clean:
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && $(CMAKE_COMMAND) -P CMakeFiles/amqps_connect_timeout.dir/cmake_clean.cmake
.PHONY : examples/CMakeFiles/amqps_connect_timeout.dir/clean

examples/CMakeFiles/amqps_connect_timeout.dir/depend:
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0 /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples/CMakeFiles/amqps_connect_timeout.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : examples/CMakeFiles/amqps_connect_timeout.dir/depend

