import Foundation
import Core

public class ComputerPlayer {

    let numberOfTrials: Int

    public static var beginner: ComputerPlayer { .init(numberOfTrials: 100) }
    public static var advanced: ComputerPlayer { .init(numberOfTrials: 10_000) }

    private init(numberOfTrials: Int) {
        self.numberOfTrials = numberOfTrials
    }

    public func bestMove(_ board: ModelBoard) -> Move? {
        let move = Core.bestMove(&board.coreBoard)
        if Core.isMoveANoMove(move) {
            return nil
        } else {
            return Move(coreMove: move)
        }
    }
}
