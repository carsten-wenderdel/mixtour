import Foundation
import MixModel

final class ComputerPlayerViewModel {
    let player: ComputerPlayer
    private let name: String

    private init(player: ComputerPlayer, name: String) {
        self.player = player
        self.name = name
    }

    convenience init(config: MCPlayerConfig) {
        self.init(player: CachePlayer(MonteCarloPlayer(config: config)), name: config.name)
    }

    static var dummy: ComputerPlayerViewModel {
        ComputerPlayerViewModel(player: DummyComputerPlayer(), name: "")
    }

    var description: String {
        return "Computer: " + LocalizedString(name)
    }
}
