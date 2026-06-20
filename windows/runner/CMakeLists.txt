cmake_minimum_required(VERSION 3.14)

add_executable(${BINARY_NAME}
  "main.cpp"
  "flutter_window.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "Runner.rc"
  "../flutter/generated_plugin_registrant.cc"
)

apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter)
target_link_libraries(${BINARY_NAME} PRIVATE flutter_wrapper_app)

add_dependencies(${BINARY_NAME} flutter_assemble)
