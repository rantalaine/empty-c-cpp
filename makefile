# Thanks to Job Vranish (https://spin.atomicobject.com/2016/08/26/makefile-c-projects/)

# Name of the executable
PROG_BIN := empty-cpp

UNAME_S := $(shell uname -s)

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

ifeq ($(PREFIX),)
	PREFIX := /usr
endif

ifeq ($(DESTDIR),)
	DESTDIR := /
endif

SERIVCE_FILES = $(wildcard *.service)

INCLUDE_DIR := /usr/local/include
LIB_DIR := /usr/local/lib

default: $(PROG_BIN)

BUILD_DIR := ./build
SRC_DIRS := ./src
INC_DIRS := \
./include \
$(INCLUDE_DIR) \


# Add MacOS specific paths and frameworks (if necessary
# EXTRA_LIB_DIRS :=
# ifeq ($(UNAME_S),Darwin)
# 	INC_DIRS += /opt/homebrew/include
#	EXTRA_LIB_DIRS := /opt/homebrew/lib
# endif

LDFLAGS := \
-L$(LIB_DIR) \

# Find all the C and C++ files we want to compile
# Note the single quotes around the * expressions. Make will incorrectly expand these otherwise.
SRCS := $(shell find $(SRC_DIRS) -name '*.cpp' -or -name '*.c' -or -name '*.s')
SRCS_NOTDIR := $(notdir $(SRCS))
$(info $$srcs with dir is [${SRCS}])
$(info $$[${SRCS_NOTDIR}])

# String substitution for every C/C++ file.
# As an example, hello.cpp turns into ./build/hello.cpp.o
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o) $(LIBS)
# Remove unnecessary './'
OBJS := $(patsubst ./%, %, $(OBJS))
$(info $$Objs is [${OBJS}])

# String substitution (suffix version without %).
# As an example, ./build/hello.cpp.o turns into ./build/hello.cpp.d
DEPS := $(OBJS:.o=.d)

# Every folder in ./src will need to be passed to GCC so that it can find header files
#INC_DIRS := $(shell find $(SRC_DIRS)/include -type d)
# Add a prefix to INC_DIRS. So moduleA would become -ImoduleA. GCC understands this -I flag
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# The -MMD and -MP flags together generate Makefiles for us!
# These files will have .d instead of .o as the output.
CPPFLAGS := $(INC_FLAGS) -MMD -MP -g $(CXXFLAGS)

# The final build step.
$(PROG_BIN): $(OBJS)
	$(CXX) -Wall -Wextra -Werror $(OBJS) -o $@ $(LDFLAGS)

# Build step for C source
$(BUILD_DIR)/$(SRC_DIRS)/%.c.o: %.c
	mkdir -p $(dir $@)
	@echo "Created directory: $(dir $@)"
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# Build step for C++ source
# For some reason the path is all fucked up and we need to add SRC_DIRS here
$(BUILD_DIR)/$(SRC_DIRS)/%.cpp.o: $(SRC_DIRS)/%.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) -c $< -o $@

.PHONY: clean clean-all install uninstall

install: $(PROG_BIN)
	install -d $(PREFIX)/lib/systemd/system
	for f in ${SERIVCE_FILES}; do \
		install -D -t $(DESTDIR)/$(PREFIX)/lib/systemd/system $$f; \
	done
	install $(PROG_BIN) $(DESTDIR)/$(PREFIX)/bin

uninstall:
	rm -f $(DESTDIR)/$(PREFIX)/bin/$(PROG_BIN)
	for f in ${SERIVCE_FILES}; do \
		rm -f $(PREFIX)/lib/systemd/system/$$f; \
	done

clean:
	rm -rf $(BUILD_DIR) $(PROG_BIN)

clean-all: clean
	rm -rf paho-mqtt-build

# Include the .d makefiles. The - at the front suppresses the errors of missing
# Makefiles. Initially, all the .d files will be missing, and we don't want those
# errors to show up.
-include $(DEPS)
