//
//  MIOErrorCode.swift
//
//  Created by MIO Research Labs on 24/09/2020.
//

import Foundation

/// Protocol for package-specific error types that expose a numeric error `code`.
///
/// Conform your library's error enum to this and derive its codes from the layer base offsets below
/// (``E_CORE``, ``E_DB``, …) so codes stay unique across libraries. The low three hex digits identify
/// the specific error; the higher digits identify the layer/library.
public protocol MIOErrorCode: Error
{
    /// The numeric error code, typically `layerBase + localOffset`.
    var code: Int32 { get }
}

// ..000: last 3 hex digits for errors
// XX000: the rest is used for layer/libraries. Higher number means high layer
//        Example:
//          network  0x100
//          coredate 0x200
//          sync     0x300

/// Base error-code offset for the MIOCore layer (`0x01000`).
public let E_CORE             = 0x01000

/// Base error-code offset for the database layer (`0x03000`).
public let E_DB               = 0x03000

/// Base error-code offset for the MySQL database backend (`0x04000`).
public let E_DB_MYSQL         = 0x04000

/// Base error-code offset for the PostgreSQL database backend (`0x05000`).
public let E_DB_POSTGRES      = 0x05000

/// Base error-code offset for the persistent-store layer (`0x08000`).
public let E_PERSISTENT_STORE = 0x08000

/// Base error-code offset for the Core Data layer (`0x09000`).
public let E_CORE_DATA        = 0x09000
