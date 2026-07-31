//
//  MIOCoreSize.swift
//  
//
//  Created by Javier Segura Perez on 15/2/22.
//

import Foundation


/// A simple width/height pair, a cross-platform, `CoreGraphics`-free size value.
///
/// Uses `Float` so it is available identically on Apple platforms and Linux, where `CGSize` is not.
public struct MCSize
{
    /// The horizontal extent.
    public var width : Float = 0
    /// The vertical extent.
    public var height: Float = 0

    /// Creates a size from a width and height.
    ///
    /// - Parameters:
    ///   - width: The horizontal extent. Defaults to `0`.
    ///   - height: The vertical extent. Defaults to `0`.
    public init( width: Float = 0, height: Float = 0 ) {
        self.width  = width
        self.height = height
    }
}
