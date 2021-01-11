import Foundation
import Core

public struct Square: Identifiable, Hashable {
    public var column, line: Int

    public var id: String { "\(line)-\(column)" }

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
extension Square {
    init(coreSquare: MIXCoreSquare) {
        column = Int(coreSquare.column)
        line = Int(coreSquare.line)
    }
}


extension Square: Equatable {}

public func ==(lhs: Square, rhs: Square) -> Bool {
    return MIXCoreSquareIsEqualToSquare(lhs.coreSquare(), rhs.coreSquare())
}
