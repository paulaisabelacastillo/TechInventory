set(FLUTTER_PLUGIN_LIST)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(plugins/${plugin} plugins/${plugin})
endforeach()
