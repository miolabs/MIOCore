# ``MIOCore``

Extend Foundation with cross-platform utilities that behave identically on Apple platforms and Linux.

## Overview

`MIOCore` adds the cross-platform utilities Foundation doesn't include, with the same behavior
whether your code runs in an Apple app or on a Swift server on Linux. Write your date parsing, money
math, JSON handling, and error types once, and use them on both sides without rewriting anything.

The part you'll reach for most is input coercion. Values from JSON bodies, database rows, and HTTP
parameters all arrive as `Any?` / `[String: Any?]`, and a plain `value as? Int` falls over the moment
a number shows up as the string `"42"`. Helpers like ``MIOCoreIntValue(_:_:)`` and
``MIOCoreParam(_:_:)`` take the value however it arrived and hand back a typed result, or throw a
clear error.

## Topics

### Type Coercion

Convert loosely-typed `Any?` values into concrete Swift types, falling back to a default instead of
throwing.

- ``MIOCoreBoolValue(_:_:)``
- ``MIOCoreIntValue(_:_:)``
- ``MIOCoreInt8Value(_:_:)``
- ``MIOCoreInt16Value(_:_:)``
- ``MIOCoreInt32Value(_:_:)``
- ``MIOCoreInt64Value(_:_:)``
- ``MCUInt16Value(_:_:)``
- ``MIOCoreUInt32Value(_:_:)``
- ``MIOCoreUInt64Value(_:_:)``
- ``MIOCoreDoubleValue(_:_:)``
- ``MIOCoreFloatValue(_:_:)``
- ``MCDecimalValue(_:_:)``
- ``MIOCoreUUIDValue(_:_:optional:)``
- ``MIOCoreIsIntValue(_:)``

### Request / Dictionary Parameters

Read typed values from a `[String: Any?]`, failing cleanly when a key is missing or invalid.

- ``MIOCoreParam(_:_:)``
- ``MIOCoreParam(_:_:_:)``
- ``MIOCoreSafeParam(_:_:_:)``
- ``optional_param(_:_:_:)``
- ``MIOCoreParamInt(_:_:_:)``
- ``MIOCoreParamInt16(_:_:_:)``
- ``MIOCoreParamInt32(_:_:_:)``
- ``MIOCoreParamInt64(_:_:_:)``
- ``MIOCoreParamDecimal(_:_:_:)``
- ``MIOCoreParamBool(_:_:_:)``
- ``MIOCoreParamSelect(_:_:_:)``

### Decimal (money-safe)

Build and round money-safe `Decimal` values, without `Double` rounding errors.

- ``MCDecimalValue(_:_:)``
- ``MIOCoreDecimalValue(_:_:)``
- ``Foundation/Decimal/rounding()``
- ``Foundation/Decimal/roundingBy(scale:roundingMode:)``

### Dates & Times

Parse and format dates in GMT0 and ISO8601, consistently across Apple platforms and Linux.

- ``parse_date(_:)``
- ``parse_date_or_nil(_:)``
- ``parse_time(_:)``
- ``parse_time_or_nil(_:)``
- ``format_date(_:)``
- ``format_time(_:)``
- ``format_date_time(_:)``
- ``format_date_time_t(_:)``
- ``MIOCoreDate(fromString:)``
- ``MCDateGMT0Parser(_:)``
- ``MCDateGMT0Format(_:)``
- ``MCTimeGMT0Format(_:)``
- ``MIOCoreDateGMT0Formatter()``
- ``MIOCoreDateCreateGMT0Formatter()``
- ``MIOCoreISO8601Formatter()``
- ``MIOCoreDateTDateTimeFormatter()``
- ``dateFormaterInGMT0()``

### JSON

Read and write JSON with cross-platform wrappers over `JSONSerialization`.

- ``MIOCoreJsonValue(withJSONObject:options:)``
- ``MIOCoreJsonStringify(withJSONObject:options:)``
- ``MIOCoreSerializableJSON(_:)``

### Errors

The shared error type for the coercion and parameter helpers, plus building blocks for
library-specific error codes.

- ``MIOCoreError``
- ``MIOErrorCode``
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

Make async and synchronous URL requests, decode JSON responses, and build multipart bodies.

- ``MIOCoreURLDataRequest(_:completion:)``
- ``MIOCoreURLDataRequest_sync(_:)``
- ``MIOCoreURLJSONRequest(_:completion:)``
- ``MIOCoreURLJSONRequest_sync(_:)``
- ``MIOCoreURLJSONRequestExecute(method:urlString:body:headers:)-(_,_,[String:Any]?,_)``
- ``MIOCoreURLJSONRequestExecute(method:urlString:body:headers:)-(_,_,Data?,_)``
- ``MultipartRequest``

### Context, globals & environment

Carry process and request globals, persist values in `UserDefaults`, and read environment variables.

- ``MIOCoreContextProtocol``
- ``MIOCoreContext``
- ``ContextUserDefaultVar``
- ``ContextUserDefaultOptionalVar``
- ``MCEnvironmentVar(_:)``

### Lexer (tokenizer)

Break a string into tokens (keywords, identifiers, symbols) for parsing. A small regex-driven
tokenizer used by the query builders.

- ``MIOCoreLexer``
- ``MIOCoreLexerToken``

### EAN barcodes

Generate EAN-8 and EAN-13 retail barcodes, including the check digit.

- ``EAN_TYPE``
- ``MIOCoreGenerateEAN(type:prefix:number:)``

### Threads & queues

Look up named dispatch queues and coordinate work with cooperative acquire and release.

- ``MIOCoreQueue(label:prefix:)``
- ``MIOCoreQueueAcquire(label:prefix:)``
- ``MIOCoreQueueRelease(label:prefix:)``
- ``MIOCoreQueueCacheStats()``
- ``MIOCoreQueueRunningInfo()``

### XML

Parse XML into a nested dictionary, `JSONSerialization`-style.

- ``XMLSerialization``

### Runtime

An autorelease-pool shim that is a no-op on Linux and WASI.

- ``MIOCoreAutoReleasePool(invoking:)``

### Geometry

A cross-platform width and height value for use where `CGSize` isn't available.

- ``MCSize``

### Keychain

Store `Codable` values in the Keychain (Apple platforms only). ``KeychainHelper`` is vendored MIT
code by Lee Kah Seng, kept pristine. Source:
`https://gist.github.com/LeeKahSeng/2452e90a57a5324de367907a36d88a49`

- ``KeychainHelper``
