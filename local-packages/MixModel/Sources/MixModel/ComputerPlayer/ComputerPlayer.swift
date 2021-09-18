import Foundation
import Core

public protocol ComputerPlayer {
    func bestMove(_ board: Board) -> Move?
}

public class DummyComputerPlayer: ComputerPlayer {
    public init() {
    }

    public func bestMove(_ board: Board) -> Move? {
        assertionFailure("This class should not be used with user interaction")
        return nil
    }
}
