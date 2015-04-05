//
// Created by Carsten Wenderdel on 2015-04-02.
// Copyright (c) 2015 Carsten Wenderdel. All rights reserved.
//

import Foundation

let kMoveSetIndicator = 6

struct ModelMove {

    var from, to: ModelSquare

    func coreMove() -> MIXCoreMove {
        return MIXCoreMove(from: from.coreSquare(), to: to.coreSquare())
    }
    
    func isMoveDrag() -> Bool {
        return from.column != kMoveSetIndicator;
    }
}

// Second initializer in an extension to keep the default initializer.
// See "Initializer Delegation for Value Types" in "The Swift Programming Language"
extension ModelMove {

    init(setPieceTo: ModelSquare) {
        from = ModelSquare(column:kMoveSetIndicator, line:0) // 0 is not important, just any number is fine
        to = setPieceTo
    }

    init(coreMove: MIXCoreMove) {
        from = ModelSquare(coreSquare: coreMove.from)
        to = ModelSquare(coreSquare: coreMove.to)
    }
}
