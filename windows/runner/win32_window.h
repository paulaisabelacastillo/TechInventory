#ifndef RUNNER_WIN32_WINDOW_H_
#define RUNNER_WIN32_WINDOW_H_

#include <windows.h>
#include <string>

class Win32Window {
 public:
  struct Point { int x; int y; };
  struct Size { int width; int height; };

  Win32Window();
  virtual ~Win32Window();

  bool Create(const std::wstring& title, const Point& origin, const Size& size);
  void Show(int show_command);
  void SetChildContent(HWND content);
  RECT GetClientArea();
  void Destroy();

 protected:
  virtual bool OnCreate();
  virtual void OnDestroy();

 private:
  static LRESULT CALLBACK WndProc(HWND hwnd, UINT const message, WPARAM const wparam, LPARAM const lparam) noexcept;
  LRESULT MessageHandler(HWND hwnd, UINT const message, WPARAM const wparam, LPARAM const lparam) noexcept;

  HWND window_handle_;
  HWND child_content_;
};

#endif
