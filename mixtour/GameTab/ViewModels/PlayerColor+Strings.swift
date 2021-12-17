import Foundation
import MixModel

extension PlayerColor {
    var labelText: String {
        switch self {
        case .white:
            return LocalizedString("Blue")
        case .black:
            return LocalizedString("Red")
        }
    }
}
