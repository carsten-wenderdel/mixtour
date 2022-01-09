import Foundation
import MixModel

struct PieceStackViewModel {
    let defaultPart: PieceStackPart
    let pickedPart: PieceStackPart

    var isEmpty: Bool {
        defaultPart.pieces.isEmpty && pickedPart.pieces.isEmpty
    }
    var totalNumberOfPieces: Int {
        return defaultPart.pieces.count + pickedPart.pieces.count
    }

    init(pieces: [PieceViewModel], numberOfPickedPieces: Int, square: Square) {
        let pickedPieces = Array(pieces.prefix(numberOfPickedPieces))
        let defaultPieces = Array(pieces.suffix(pieces.count - numberOfPickedPieces))
        defaultPart = PieceStackPart(pieces: defaultPieces, square: square)
        pickedPart = PieceStackPart(pieces: pickedPieces, square: square)
    }
}

struct PieceStackPart: Equatable {
    let pieces: [PieceViewModel]
    let square: Square
}
