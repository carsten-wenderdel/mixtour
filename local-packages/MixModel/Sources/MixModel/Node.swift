import Foundation

final class Node {

    var numberOfSimulations = 0.0
    var numberOfWins = 0.0
    var childNodes = [Node]()

    func selectedNodeForNextVisit(_ explorationConstant: Double) -> Node? {
        return childNodes.max { (node1, node2) -> Bool in
            node1.upc(explorationConstant, totalNumberOfSimulations: numberOfSimulations)
                < node2.upc(explorationConstant, totalNumberOfSimulations: numberOfSimulations)
        }
    }

    // Upper Confidence Bound applied to trees
    private func upc(_ explorationConstant: Double, totalNumberOfSimulations: Double) -> Double {
        return (numberOfWins / numberOfSimulations)
            + explorationConstant * sqrt(log(totalNumberOfSimulations) / numberOfSimulations)
    }
}
