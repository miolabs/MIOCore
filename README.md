# MIOCore

Extend Foundation with cross-platform utilities that behave identically on Apple platforms and Linux.

## Overview

`MIOCore` adds the cross-platform utilities Foundation doesn't include, with the same behavior
whether your code runs in an Apple app or on a Swift server on Linux. Write your date parsing, money
math, JSON handling, and error types once, and use them on both sides without rewriting anything.

The part you'll reach for most is input coercion. Values from JSON bodies, database rows, and HTTP
parameters all arrive as `Any?` / `[String: Any?]`, and a plain `value as? Int` falls over the moment
a number shows up as the string `"42"`. Helpers like `MIOCoreIntValue(_:_:)` and
`MIOCoreParam(_:_:)` take the value however it arrived and hand back a typed result, or throw a
clear error.
