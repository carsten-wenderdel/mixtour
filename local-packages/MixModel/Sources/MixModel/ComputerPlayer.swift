import Foundation
import Core

public class ComputerPlayer {

    let numberOfTrials: Int

    public static var beginner: ComputerPlayer { .init(numberOfTrials: 1) }
    public static var advanced: ComputerPlayer { .init(numberOfTrials: 8_000) }

    init(numberOfTrials: Int) {
        self.numberOfTrials = numberOfTrials
    }

    public func bestMove(_ board: Board) -> Move? {
        let move = Core.bestMove(&board.coreBoard, Int32(numberOfTrials))
        if Core.isMoveANoMove(move) {
            return nil
        } else {
            return Move(coreMove: move)
        }
    }
}

// MARK: Unit tests
extension ComputerPlayer {
    func isNumberOfTrialsSmallEnough() -> Bool {
        return Core.isNumberOfTrialsSmallEnough(Int32(numberOfTrials))
    }
}
