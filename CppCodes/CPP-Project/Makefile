# Makefile for a multi-file C++ project
# Build and manage the C++ project with CMake.


.PHONY: build run clear all debug

build:
	cmake -S . -B build -Wno-dev -DCMAKE_BUILD_TYPE=Release > /dev/null
	cmake --build build -- -s

debug:
	cmake -S . -B build -Wno-dev -DCMAKE_BUILD_TYPE=Debug > /dev/null
	cmake --build build -- -s

run:
	$(MAKE) build
	./bin/test

clear:
	rm -rf bin build

all: build run clear
