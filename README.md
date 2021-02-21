# Drive Daemon

A simple daemon that autostarts on launch so you get notified when a drive is connected.

## Building and Installation

You'll need the following dependencies:

- glib-2.0
- meson
- valac

Run `meson build` to configure the build environment. Change to the build directory and run `ninja` to build
```bash
meson build --prefix=/usr
cd build
ninja
```

To install, use `ninja install`, then execute with `com.github.pongloongyeat.drive-daemon`

```bash
ninja install
com.github.pongloongyeat.drive-daemon
```
