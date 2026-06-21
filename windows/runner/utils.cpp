#include "utils.h"
#include <iostream>

bool CreateAndAttachConsole() {
  if (::AllocConsole()) {
    FILE* unused;
    if (freopen_s(&unused, "CONOUT$", "w", stdout) == 0) {
      std::clog.clear();
      std::cout.clear();
    }
    return true;
  }
  return false;
}
