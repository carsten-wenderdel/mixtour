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
        case .expert2:
            name = "Expert 2"
        case .worldClass1:
            name = "World Class 1"
        case .worldClass2:
            name = "World Class 2"
        case .superNatural1:
            name = "Supernatural 1"
        case .superNatural2:
            name = "Supernatural 2"
        case .superNatural3:
            name = "Supernatural 3"
        }
        return "\(LocalizedString(name))"
//        return "\(LocalizedString(name)) (ELO \(self.eloRating))"
    }
}
