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
include examples/CMakeFiles/amqp_exchange_declare.dir/depend.make

# Include the progress variables for this target.
include examples/CMakeFiles/amqp_exchange_declare.dir/progress.make

# Include the compile flags for this target's objects.
include examples/CMakeFiles/amqp_exchange_declare.dir/flags.make

examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o: examples/CMakeFiles/amqp_exchange_declare.dir/flags.make
examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o: ../examples/amqp_exchange_declare.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o   -c /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/amqp_exchange_declare.c

examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.i"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/amqp_exchange_declare.c > CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.i

examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.s"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/amqp_exchange_declare.c -o CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.s

examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o.requires:

.PHONY : examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o.requires

examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o.provides: examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o.requires
	$(MAKE) -f examples/CMakeFiles/amqp_exchange_declare.dir/build.make examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o.provides.build
.PHONY : examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o.provides

examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o.provides.build: examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o


examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.o: examples/CMakeFiles/amqp_exchange_declare.dir/flags.make
examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.o: ../examples/utils.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.o"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/amqp_exchange_declare.dir/utils.c.o   -c /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/utils.c

examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/amqp_exchange_declare.dir/utils.c.i"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/utils.c > CMakeFiles/amqp_exchange_declare.dir/utils.c.i

examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/amqp_exchange_declare.dir/utils.c.s"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/utils.c -o CMakeFiles/amqp_exchange_declare.dir/utils.c.s

examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.o.requires:

.PHONY : examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.o.requires

examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.o.provides: examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.o.requires
	$(MAKE) -f examples/CMakeFiles/amqp_exchange_declare.dir/build.make examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.o.provides.build
.PHONY : examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.o.provides

examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.o.provides.build: examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.o


examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o: examples/CMakeFiles/amqp_exchange_declare.dir/flags.make
examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o: ../examples/unix/platform_utils.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o   -c /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/unix/platform_utils.c

examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.i"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/unix/platform_utils.c > CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.i

examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.s"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples/unix/platform_utils.c -o CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.s

examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o.requires:

.PHONY : examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o.requires

examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o.provides: examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o.requires
	$(MAKE) -f examples/CMakeFiles/amqp_exchange_declare.dir/build.make examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o.provides.build
.PHONY : examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o.provides

examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o.provides.build: examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o


# Object files for target amqp_exchange_declare
amqp_exchange_declare_OBJECTS = \
"CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o" \
"CMakeFiles/amqp_exchange_declare.dir/utils.c.o" \
"CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o"

# External object files for target amqp_exchange_declare
amqp_exchange_declare_EXTERNAL_OBJECTS =

examples/amqp_exchange_declare: examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o
examples/amqp_exchange_declare: examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.o
examples/amqp_exchange_declare: examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o
examples/amqp_exchange_declare: examples/CMakeFiles/amqp_exchange_declare.dir/build.make
examples/amqp_exchange_declare: librabbitmq/librabbitmq.4.2.0.dylib
examples/amqp_exchange_declare: /usr/local/opt/openssl/lib/libssl.dylib
examples/amqp_exchange_declare: /usr/local/opt/openssl/lib/libcrypto.dylib
examples/amqp_exchange_declare: examples/CMakeFiles/amqp_exchange_declare.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking C executable amqp_exchange_declare"
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/amqp_exchange_declare.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
examples/CMakeFiles/amqp_exchange_declare.dir/build: examples/amqp_exchange_declare

.PHONY : examples/CMakeFiles/amqp_exchange_declare.dir/build

examples/CMakeFiles/amqp_exchange_declare.dir/requires: examples/CMakeFiles/amqp_exchange_declare.dir/amqp_exchange_declare.c.o.requires
examples/CMakeFiles/amqp_exchange_declare.dir/requires: examples/CMakeFiles/amqp_exchange_declare.dir/utils.c.o.requires
examples/CMakeFiles/amqp_exchange_declare.dir/requires: examples/CMakeFiles/amqp_exchange_declare.dir/unix/platform_utils.c.o.requires

.PHONY : examples/CMakeFiles/amqp_exchange_declare.dir/requires

examples/CMakeFiles/amqp_exchange_declare.dir/clean:
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples && $(CMAKE_COMMAND) -P CMakeFiles/amqp_exchange_declare.dir/cmake_clean.cmake
.PHONY : examples/CMakeFiles/amqp_exchange_declare.dir/clean

examples/CMakeFiles/amqp_exchange_declare.dir/depend:
	cd /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0 /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/examples /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples /Users/mario/code/alaskan/src/rabbitmq-c-0.8.0/build/examples/CMakeFiles/amqp_exchange_declare.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : examples/CMakeFiles/amqp_exchange_declare.dir/depend
