
//
//
//

import Foundation

var _mioCoreClassesByName:[String:AnyClass] = [:]

public func _MIOCoreRegisterClass(type:AnyClass, forKey key:String) {
    _mioCoreClassesByName[key] = type
}

public func _MIOCoreClassFromString(_ key:String) -> AnyClass? {
    return _mioCoreClassesByName[key]
}

#if os(Linux)
public func MIOCoreAutoReleasePool<Result>(invoking body: () throws -> Result) rethrows -> Result { try body() }
#else
public func MIOCoreAutoReleasePool<Result>(invoking body: () throws -> Result) rethrows -> Result { try autoreleasepool(invoking: body) }
#endif
