cmake_minimum_required(VERSION 3.16)
project(test LANGUAGES CXX)


set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Build all cpp files under the src directory.
file(GLOB SRC_FILES CONFIGURE_DEPENDS src/*.cpp)
add_executable(test ${SRC_FILES})

# Output the executable to the bin directory.
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
