cmake_minimum_required(VERSION 3.14)
project(tech_inventory LANGUAGES CXX)

set(BINARY_NAME "tech_inventory")

cmake_policy(VERSION 3.14...3.25)

set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

add_subdirectory(${FLUTTER_MANAGED_DIR})
add_subdirectory("runner")
