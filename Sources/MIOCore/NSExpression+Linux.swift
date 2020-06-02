//
//  File.swift
//  
//
//  Created by Javier Segura Perez on 01/06/2020.
//

import Foundation


//#if os(Linux)

struct NSExpressionAssociatedKeys {
    static var keyPath: String?
}

extension NSExpression
{
    private var _keyPath: String {
        get {
            return objc_getAssociatedObject(self, &NSExpressionAssociatedKeys.keyPath) as! String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &NSExpressionAssociatedKeys.keyPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
     open var keyPath: String {
        return _keyPath
    }
    
    public convenience init(forKeyPath keyPath: String) {
        self.init()
        _keyPath = keyPath
    }
        
}

//#endif

