//
//  MIOHTTPStatusError.swift
//  MIOCore
//

import Foundation


/// An error that knows which HTTP status it should be answered with.
///
/// Lets a library that has no business depending on a server framework still
/// say "this is a 401, not a 500". A server layer checks for this conformance
/// when turning a thrown error into a response; anything that does not conform
/// keeps whatever default that layer applies.
///
/// Conform where the *error* determines the status — an expired credential is
/// always unauthorized, wherever it is raised. Leave it off errors whose status
/// depends on context.
///
///     extension DLTKError : MIOHTTPStatusError {
///         public var httpStatusCode: Int {
///             switch self {
///             case .tokenExpired: return 401
///             ...
///             }
///         }
///     }
public protocol MIOHTTPStatusError : Error
{
    /// Status to answer with, e.g. 401.
    var httpStatusCode: Int { get }
}
