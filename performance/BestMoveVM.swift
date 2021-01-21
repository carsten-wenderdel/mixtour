import Foundation
import MixModel

final class BestMoveVM: ObservableObject {

    var iterations = 0
    var timeSum = 0.0
    var seconds = [Double]()

    var average: String {
        "Average after \(iterations): \(timeSum/Double(iterations))"
    }

    func startMeasuring() {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            let computer = MonteCarloPlayer.measuring
            let board = Board()
            let before = Date()
            _ = computer.bestMove(board)
            let after = Date()

            iterations += 1
            let time = after.timeIntervalSince(before)
            timeSum += time
            seconds.append(time)

            DispatchQueue.main.async { [self] in
                objectWillChange.send()
                if iterations < 20 {
                    startMeasuring()
                }
            }
        }
    }
}
