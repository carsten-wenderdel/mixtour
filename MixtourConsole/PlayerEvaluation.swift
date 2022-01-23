import Foundation
import MixModel

class PlayerEvaluation {

    func run() {
        var exploration = 0.61
        while true {
            let factor = 1.02
            let value = evaluate(c1: exploration * factor, c2: exploration / factor)
            let change = 1.005
            if value == 0 {
                let randomChange = (change + 1.0) / 2.0
                exploration = Double.random(in: exploration/randomChange...exploration*randomChange)
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
        let player1 = MonteCarloPlayer(numberOfIterations: iterations, explorationConstant: c1)
        let player2 = MonteCarloPlayer(numberOfIterations: iterations, explorationConstant: c2)

        let result1 = winner(white: player1, black: player2)
        let result2 = winner(white: player2, black: player1)

        return result1 - result2
    }

    // 1 if white wins, 0 for draw, -1 for black
    func winner(white: MonteCarloPlayer, black: MonteCarloPlayer) -> Int {
        let board = Board()
        var iteration = 0
        while (!board.isGameOver()) {
            if iteration > 500 {
                return 0
            }
            iteration += 1
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

    func compete() {
//        let player1 = MonteCarloPlayer(numberOfIterations: 8_000)
        let player1 = MonteCarloPlayer(timeToThink: 0.17)
//        let player2 = MonteCarloPlayer(numberOfIterations: 8_000)
        let player2 = MonteCarloPlayer(timeToThink: 0.17)



        var iterations = 0.0
        var whiteWins = 0.0
        var blackWins = 0.0

        while true {
            iterations += 1
            whiteWins += 0.5 * Double((1 + winner(white: player1, black: player2)))
            blackWins += 1 - 0.5 * Double((1 + winner(white: player2, black: player1)))

            print("\(iterations) iterations")
            print("white wins: \(100 * whiteWins / iterations)")
            print("black wins: \(100 * blackWins / iterations)")
            print("combined: \(50 * (blackWins + whiteWins) / iterations)")
        }
    }

}
