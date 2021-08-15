import Foundation
import MixModel

extension MCPlayerConfig {

    var labelText: String {
        let name: String
        switch self {
        case .beginner1:
            name = "Beginner 1"
        case .beginner2:
            name = "Beginner 2"
        case .casualPlayer1:
            name = "Casual Player 1"
        case .casualPlayer2:
            name = "Casual Player 2"
        case .advanced1:
            name = "Advanced 1"
        case .advanced2:
            name = "Advanced 2"
        case .expert1:
            name = "Expert 1"
        }
        return "\(LocalizedString(name)) (ELO \(self.eloRating))"
    }
}
