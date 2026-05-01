# Makefile for test
# Build and manage the C++ project with CMake.

# Usage:
# make build a
# make debug b
# make run a
DEFAULT_TARGET := a
CMD_TARGET := $(word 2,$(MAKECMDGOALS))
TARGET := $(if $(CMD_TARGET),$(CMD_TARGET),$(DEFAULT_TARGET))
FILE := $(TARGET).cpp
BUILD_DIR := build/$(TARGET)
BIN_PATH := ./bin/$(TARGET)

.PHONY: build run clear all debug

build:
	cmake -S . -B $(BUILD_DIR) -Wno-dev -DCMAKE_BUILD_TYPE=Release -DTARGET_CPP=$(FILE) > /dev/null
	cmake --build $(BUILD_DIR) --target $(TARGET) -- -s

debug:
	cmake -S . -B $(BUILD_DIR) -Wno-dev -DCMAKE_BUILD_TYPE=Debug -DTARGET_CPP=$(FILE) > /dev/null
	cmake --build $(BUILD_DIR) --target $(TARGET) -- -s

run:
	$(MAKE) build $(TARGET)
	$(BIN_PATH)

clear:
	rm -rf bin build

all: build run clear

# Swallow targets such as "a" in "make run a" so they are not treated as unknown targets.
%:
	@:
