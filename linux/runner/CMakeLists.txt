cmake_minimum_required(VERSION 3.14)

add_executable(${BINARY_NAME}
  "main.cc"
  "my_application.cc"
  "../flutter/generated_plugin_registrant.cc"
)

apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::GTK)

add_dependencies(${BINARY_NAME} flutter_assemble)
