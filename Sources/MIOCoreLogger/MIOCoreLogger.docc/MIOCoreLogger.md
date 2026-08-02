# ``MIOCoreLogger``

One simple way to log, built on swift-log.

## Overview

Instead of scattering `print` calls around, everything logs through one type, ``Log``, with a method
for each severity level (from `trace` up to `critical`). The point is consistency: the same call
style everywhere, output you can filter by level, and log lines that cost nothing when their level is
switched off.

A few conveniences come for free:

- Each call records where it came from (`#fileID` / `#function` / `#line`), so you don't pass that in.
- The message is an `@autoclosure`, so if its level is disabled the string is never even built.
- The log level comes from the calling file's name, and you can set it per file or path with an
  environment variable (for example `MyModule_LogLevel=debug`).

It re-exports swift-log (`@_exported import Logging`), so string interpolation into a `Logger.Message`
works at the call site without importing `Logging` yourself.

```swift
import MIOCoreLogger

Log.info("Server listening on :\(port)")
Log.error("Couldn't load the file: \(error.localizedDescription)")
```

## Topics

### Logging

The single entry point. Call the static method that matches the severity you want.

- ``Log``
