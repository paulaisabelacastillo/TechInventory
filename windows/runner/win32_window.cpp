#include "win32_window.h"

Win32Window::Win32Window() : window_handle_(nullptr), child_content_(nullptr) {}

Win32Window::~Win32Window() {
  Destroy();
}

bool Win32Window::Create(const std::wstring& title, const Point& origin, const Size& size) {
  WNDCLASS window_class = {};
  window_class.lpfnWndProc = WndProc;
  window_class.hInstance = GetModuleHandle(nullptr);
  window_class.lpszClassName = L"FLUTTER_RUNNER_WIN32_WINDOW";
  RegisterClass(&window_class);

  window_handle_ = CreateWindowEx(0, L"FLUTTER_RUNNER_WIN32_WINDOW", title.c_str(),
                                  WS_OVERLAPPEDWINDOW, origin.x, origin.y,
                                  size.width, size.height, nullptr, nullptr,
                                  GetModuleHandle(nullptr), this);
  return window_handle_ != nullptr;
}

void Win32Window::Show(int show_command) {
  if (window_handle_) {
    ShowWindow(window_handle_, show_command);
    UpdateWindow(window_handle_);
  }
}

void Win32Window::SetChildContent(HWND content) {
  child_content_ = content;
  SetParent(child_content_, window_handle_);
  MoveWindow(child_content_, 0, 0, 1280, 720, TRUE);
}

RECT Win32Window::GetClientArea() {
  RECT rect;
  GetClientRect(window_handle_, &rect);
  return rect;
}

void Win32Window::Destroy() {
  if (window_handle_) {
    DestroyWindow(window_handle_);
    window_handle_ = nullptr;
  }
}

LRESULT CALLBACK Win32Window::WndProc(HWND hwnd, UINT const message, WPARAM const wparam, LPARAM const lparam) noexcept {
  if (message == WM_NCCREATE) {
    auto create_struct = reinterpret_cast<CREATESTRUCT*>(lparam);
    SetWindowLongPtr(hwnd, GWLP_USERDATA, reinterpret_cast<LONG_PTR>(create_struct->lpCreateParams));
  }
  auto window = reinterpret_cast<Win32Window*>(GetWindowLongPtr(hwnd, GWLP_USERDATA));
  if (window) {
    return window->MessageHandler(hwnd, message, wparam, lparam);
  }
  return DefWindowProc(hwnd, message, wparam, lparam);
}

LRESULT Win32Window::MessageHandler(HWND hwnd, UINT const message, WPARAM const wparam, LPARAM const lparam) noexcept {
  switch (message) {
    case WM_DESTROY:
      OnDestroy();
      PostQuitMessage(0);
      return 0;
  }
  return DefWindowProc(hwnd, message, wparam, lparam);
}

void Win32Window::OnDestroy() {}
bool Win32Window::OnCreate() { return true; }
