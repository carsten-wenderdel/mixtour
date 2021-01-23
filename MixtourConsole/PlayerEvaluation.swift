import Foundation
import MixModel

class PlayerEvaluation {

    func run() {
        var exploration = 0.57
        while true {
            let factor = 1.1
            let value = evaluate(c1: exploration * factor, c2: exploration / factor)
            let change = 1.02
            if value == 0 {
                exploration = Double.random(in: exploration/change...exploration*change)
            } else {
                if value > 0 {
                    exploration *= change
                } else {
                    exploration /= change
                }
            }
            print("exploration is \(exploration), value is \(value)")
        }
    }

    // 2 if c1 wins both games, -2 if c1 loses both games
    func evaluate(c1: Double, c2: Double) -> Int {
        let iterations = 60_000
        let player1 = MonteCarloPlayer(numberOfIterations: iterations, explorationConstant: Float(c1))
        let player2 = MonteCarloPlayer(numberOfIterations: iterations, explorationConstant: Float(c2))

        let result1 = winner(white: player1, black: player2)
        let result2 = winner(white: player2, black: player1)

        return result1 - result2
    }

    // 1 if white wins, 0 for draw, -1 for black
    func winner(white: MonteCarloPlayer, black: MonteCarloPlayer) -> Int {
        let board = Board()
        while (!board.isGameOver()) {
            let player = (board.playerOnTurn() == PlayerColor.white) ? white : black
            let move = player.bestMove(board)!
            board.makeMoveIfLegal(move)
        }
        switch board.winner() {
        case .white:
            return 1
        case .black:
            return -1
        case nil:
            return 0
        }
    }

}
