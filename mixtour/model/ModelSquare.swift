//
//  ModelSquare.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 26/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation

struct ModelSquare {
    var column, line: Int
    
    func coreSquare() -> MIXCoreSquare {
        return MIXCoreSquare(column: UInt8(column), line: UInt8(line))
    }
}

// It's done in an extension to keep the default initializer.
// See "Initializer Delegation for Value Types" in "The Swift Programming Language"
extension ModelSquare {
    init(coreSquare: MIXCoreSquare) {
        column = Int(coreSquare.column)
        line = Int(coreSquare.line)
    }
}

