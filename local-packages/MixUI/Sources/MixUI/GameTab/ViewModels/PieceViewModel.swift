import Foundation
import MixModel

struct PieceViewModel: Identifiable, Equatable {
    let color: PlayerColor
    let id: Int
    let zIndex: Double
}
