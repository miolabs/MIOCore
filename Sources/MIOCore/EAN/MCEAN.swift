//
//  MCEAN.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

/// Generates EAN retail barcodes (EAN-8 / EAN-13), including the check digit.
public enum MCEAN {

    /// The EAN standard to generate, whose raw value is its total digit count.
    public enum Standard: Int16 {
        /// EAN-8: 8 digits total.
        case ean8 = 8
        /// EAN-13: 13 digits total.
        case ean13 = 13
    }

    /// Generates a complete EAN barcode string, computing and appending the check digit.
    ///
    /// Left-pads `number` with zeros so that `prefix` + number + check digit fills the width required
    /// by `type`.
    ///
    /// ```swift
    /// let code = MCEAN.generate(type: .ean13, prefix: "840", number: 1234567)
    /// ```
    ///
    /// - Parameters:
    ///   - type: The EAN standard (``Standard/ean8`` or ``Standard/ean13``).
    ///   - prefix: A leading prefix (e.g. a country/company code); may be empty.
    ///   - number: The item number that fills the remaining digits.
    /// - Returns: The full barcode string including its trailing check digit.
    public static func generate(type: Standard, prefix: String, number: Int64) -> String {
        var code = prefix
        let number_str = "\(number)"
        let padding = Int(type.rawValue) - 1 - number_str.count - code.count

        code += String(repeating: "0", count: padding) + number_str

        return code + "\(_calculate_ean_crc( code ))"
    }

    private static func _calculate_ean_crc(_ code: String) -> UInt32 {
        var odd: UInt32 = 0
        var even: UInt32 = 0
        var i = 0

        for index in code.indices {
            let c = code[index]

            if (i % 2) != 0 {
                odd += MCCast.uint32(String(c))!
            } else {
                even += MCCast.uint32(String(c))!
            }

            i += 1
        }

        let crc = (((odd * 3) + even) % 10)
        if crc == 0 { return UInt32(crc) }

        return UInt32(10) - UInt32(crc)
    }
}
