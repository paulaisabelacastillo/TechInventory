set(FLUTTER_TRACKED_FILES
  "${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt"
  "${CMAKE_CURRENT_SOURCE_DIR}/generated_plugins.cmake"
)

add_custom_command(
  OUTPUT
    "${FLUTTER_LIBRARY}"
    "${FLUTTER_ICU_DATA_DIR}/icudtl.dat"
    ${FLUTTER_ADDITIONAL_OUTPUTS}
  COMMAND ${CMAKE_COMMAND} -E env
    "FLUTTER_ROOT=${FLUTTER_ROOT}"
    "TRACKED_FILES=${FLUTTER_TRACKED_FILES}"
    "${FLUTTER_ROOT}/packages/flutter_tools/bin/tool_backend.sh"
      "${FLUTTER_TARGET}"
      "${CMAKE_BUILD_TYPE}"
  DEPENDS
    ${FLUTTER_TRACKED_FILES}
)

add_custom_target(flutter_assemble DEPENDS
  "${FLUTTER_LIBRARY}"
  "${FLUTTER_ICU_DATA_DIR}/icudtl.dat"
  ${FLUTTER_ADDITIONAL_OUTPUTS}
)
