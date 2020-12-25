import Foundation
import MixModel

struct PieceViewModel: Identifiable {
    let color: ModelPlayer
    let id: String

    static let black = PieceViewModel(color: .black, id: "")
    static let white = PieceViewModel(color: .white, id: "")
}
