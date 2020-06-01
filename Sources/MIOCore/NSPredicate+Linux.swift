//
//  File.swift
//  
//
//  Created by Javier Segura Perez on 01/06/2020.
//

import Foundation

#if os(Linux)

extension NSPredicate
{
    public convenience init(format predicateFormat: String, _ args: CVarArg...) {
        self.init()
    }
}

#endif
