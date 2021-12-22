import Foundation
import MixModel

final class BestMoveVM: ObservableObject {

    var iterations = 0
    var timeSum = 0.0
    var seconds = [Double]()

    private var isMeasuring = false

    var average: String {
        "Average after \(iterations): \(1000.0 * timeSum / Double(iterations))"
    }
    var fastest: String {
        "Fastest: \(1000.0 * (seconds.min() ?? 0))"
    }

    func startMeasuring() {
        if (isMeasuring) {
            return
        } else {
            iterations = -1
            timeSum = 0
            seconds = [Double]()
            isMeasuring = true
            measure()
        }
    }

    func measure() {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            let computer = MonteCarloPlayer.measuring
            let board = Board()
            let before = Date()
            _ = computer.bestMove(board)
            let after = Date()

            iterations += 1
            if iterations > 0 {
                let time = after.timeIntervalSince(before)
                timeSum += time
                seconds.append(time)
            }

            DispatchQueue.main.async { [self] in
                objectWillChange.send()
                if iterations < 20 {
                    measure()
                } else {
                    isMeasuring = false
                }
            }
        }
    }
}
