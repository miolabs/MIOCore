# ``MIOCore``

Extend Foundation with cross-platform utilities that behave identically on Apple platforms and Linux.

## Overview

`MIOCore` adds the cross-platform utilities Foundation doesn't include, with the same behavior
whether your code runs in an Apple app or on a Swift server on Linux. Write your date parsing, money
math, JSON handling, and error types once, and use them on both sides without rewriting anything.

The part you'll reach for most is input coercion. Values from JSON bodies, database rows, and HTTP
parameters all arrive as `Any?` / `[String: Any?]`, and a plain `value as? Int` falls over the moment
a number shows up as the string `"42"`. Helpers like ``MCCast/int(_:default:)`` and
``MCParam/require(_:from:)`` take the value however it arrived and hand back a typed result, or throw
a clear error.

## Topics

### Value Coercion

Coerce loosely-typed `Any?` values into concrete Swift types, falling back to a `default` instead of
throwing. ``MCCast`` groups the family, one method per target type.

- ``MCCast``

### Request / Dictionary Parameters

Read typed values from a `[String: Any?]`, failing cleanly when a key is missing or invalid.
``MCParam`` groups the family: strict generic accessors (`require`/`optional`) plus the coercing
typed getters (`int`/`decimal`/`bool`/...).

- ``MCParam``

### Decimal (money-safe)

Build and round money-safe `Decimal` values, without `Double` rounding errors.

- ``MCCast/decimal(_:default:)``
- ``Foundation/Decimal/rounding()``
- ``Foundation/Decimal/roundingBy(scale:roundingMode:)``

### Dates & Times

Parse and format dates in local time and UTC (and ISO8601), consistently across Apple platforms and
Linux. ``MCDate`` groups the family, with the timezone regime explicit in each member name (plain =
local, `UTC` suffix = UTC).

- ``MCDate``
- ``Foundation/ISO8601DateFormatter/microsecondsDate(from:)``

### JSON

Read and write JSON with cross-platform wrappers over `JSONSerialization`. ``MCJSON`` groups the
family (`data`/`string` encoders plus the `serializable` sanitizer).

- ``MCJSON``

### Errors

The shared error type for the coercion and parameter helpers, plus building blocks for
library-specific error codes.

- ``MCError``
- ``MCErrorCode``
- ``E_CORE``
- ``E_DB``
- ``E_DB_MYSQL``
- ``E_DB_POSTGRES``
- ``E_PERSISTENT_STORE``
- ``E_CORE_DATA``

### Strings

String conveniences for templating, case conversion, subscripting, and C interop.

- ``Swift/String/replacing(withParams:)``
- ``Swift/String/camelCaseToSnakeCase()``
- ``Swift/String/snakeCaseToCamelCase()``
- ``Swift/String/cString()``

### Networking

Make async and synchronous URL requests, decode JSON responses, and build multipart bodies. ``MCNetwork``
groups the request helpers.

- ``MCNetwork``
- ``MCMultipartRequest``

### Context, globals & environment

Carry process and request globals, persist values in `UserDefaults`, and read environment variables.

- ``MCContextProtocol``
- ``MCContext``
- ``MCUserDefault``
- ``MCUserDefaultOptional``
- ``MCEnvironment``

### Lexer (tokenizer)

Break a string into tokens (keywords, identifiers, symbols) for parsing. A small regex-driven
tokenizer used by the query builders.

- ``MCLexer``
- ``MCLexer/Token``

### EAN barcodes

Generate EAN-8 and EAN-13 retail barcodes, including the check digit. ``MCEAN`` groups the generator
and its ``MCEAN/Standard`` enum.

- ``MCEAN``

### Threads & queues

Look up named dispatch queues and coordinate work with cooperative acquire and release. ``MCQueue``
groups the registry (`named`) and the cooperative locking (`acquire`/`release`).

- ``MCQueue``

### XML

Parse XML into a nested dictionary, `JSONSerialization`-style.

- ``XMLSerialization``

### Runtime

An autorelease-pool shim that is a no-op on Linux and WASI.

- ``MCRuntime``

### Geometry

A cross-platform width and height value for use where `CGSize` isn't available.

- ``MCSize``

### Keychain

Store `Codable` values in the Keychain (Apple platforms only). ``KeychainHelper`` is vendored MIT
code by Lee Kah Seng, kept pristine. Source:
`https://gist.github.com/LeeKahSeng/2452e90a57a5324de367907a36d88a49`

- ``KeychainHelper``
