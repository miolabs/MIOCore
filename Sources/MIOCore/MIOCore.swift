
//
//
//

import Foundation

private let _mioCoreClassesLock = NSLock()
private nonisolated(unsafe) var _mioCoreClassesByName: [String: AnyClass] = [:]

public func _MIOCoreRegisterClass( type:AnyClass, forKey key:String ) {
    _mioCoreClassesLock.withLock {
        _mioCoreClassesByName[key] = type
    }
}

public func _MIOCoreClassFromString( _ key:String ) -> AnyClass? {
    _mioCoreClassesLock.withLock {
        _mioCoreClassesByName[key]
    }
}

#if os(Linux) || os(WASI)
public func MIOCoreAutoReleasePool<Result>(invoking body: () throws -> Result) rethrows -> Result { try body() }
#else
public func MIOCoreAutoReleasePool<Result>(invoking body: () throws -> Result) rethrows -> Result { try autoreleasepool(invoking: body) }
#endif
