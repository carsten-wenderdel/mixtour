import Foundation
import MixModel

extension MCPlayerConfig {

    var labelText: String {
        let name: String
        switch self {
        case .beginner1:
            name = LocalizedString("Beginner 1")
        case .beginner2:
            name = LocalizedString("Beginner 2")
        case .advanced1:
            name = LocalizedString("Advanced 1")
        case .advanced2:
            name = LocalizedString("Advanced 2")
        case .expert1:
            name = LocalizedString("Expert 1")
        }
        return "\(name) (ELO \(self.eloRating))"
    }
}
