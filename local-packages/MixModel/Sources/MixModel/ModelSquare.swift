//
//  ModelSquare.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 26/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation
import Core

public struct ModelSquare {
    public var column, line: Int

    public init(column: Int, line: Int) {
        self.column = column
        self.line = line
    }

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


extension ModelSquare: Equatable {}

public func ==(lhs: ModelSquare, rhs: ModelSquare) -> Bool {
    return MIXCoreSquareIsEqualToSquare(lhs.coreSquare(), rhs.coreSquare())
}
