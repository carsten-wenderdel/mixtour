import Foundation

struct PieceStackViewModel {
    let defaultPieces: [PieceViewModel]
    let pickedPieces: [PieceViewModel]

    var isEmpty: Bool {
        defaultPieces.isEmpty && pickedPieces.isEmpty
    }

    var useDrag: Bool {
        defaultPieces.count + pickedPieces.count > 1 || pickedPieces.count > 0
    }
}
