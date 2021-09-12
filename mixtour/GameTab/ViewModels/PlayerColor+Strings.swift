import Foundation
import MixModel

extension PlayerColor {
    var labelText: String {
        switch self {
        case .white:
            return LocalizedString("White")
        case .black:
            return LocalizedString("Red")
        }
    }
}
