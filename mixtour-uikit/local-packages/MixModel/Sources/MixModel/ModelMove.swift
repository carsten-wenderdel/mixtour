//
// Created by Carsten Wenderdel on 2015-04-02.
// Copyright (c) 2015 Carsten Wenderdel. All rights reserved.
//

import Foundation
import Core

let kMoveSetIndicator = 6

public struct ModelMove {
    var from, to: ModelSquare
    var numberOfPieces: Int

    public init(from: ModelSquare, to: ModelSquare, numberOfPieces: Int) {
        self.from = from
        self.to = to
        self.numberOfPieces = numberOfPieces
    }

    func coreMove() -> MIXCoreMove {
        return MIXCoreMove(from: from.coreSquare(), to: to.coreSquare(), numberOfPieces: UInt8(numberOfPieces))
    }
    
    func isMoveDrag() -> Bool {
        return from.column != kMoveSetIndicator;
    }
}

// Second initializer in an extension to keep the default initializer.
// See "Initializer Delegation for Value Types" in "The Swift Programming Language"
extension ModelMove {

    public init(setPieceTo: ModelSquare) {
        from = ModelSquare(column:kMoveSetIndicator, line:0) // 0 is not important, just any number is fine
        to = setPieceTo
        numberOfPieces = 0
    }

    init(coreMove: MIXCoreMove) {
        from = ModelSquare(coreSquare: coreMove.from)
        to = ModelSquare(coreSquare: coreMove.to)
        numberOfPieces = Int(coreMove.numberOfPieces)
    }
}


extension ModelMove: Equatable {}

public func ==(lhs: ModelMove, rhs: ModelMove) -> Bool {
    return MIXCoreMoveEqualToMove(lhs.coreMove(), rhs.coreMove())
}
