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

    init(pieces: [PieceViewModel], numberOfPickedPieces: Int, square: ModelSquare) {
        let pickedPieces = Array(pieces.prefix(numberOfPickedPieces))
        let defaultPieces = Array(pieces.suffix(pieces.count - numberOfPickedPieces))
        let useDrag = defaultPieces.count + pickedPieces.count > 1 || pickedPieces.count > 0
        defaultPart = PieceStackPart(pieces: defaultPieces, square: square, useDrag: useDrag)
        pickedPart = PieceStackPart(pieces: pickedPieces, square: square, useDrag: useDrag)
    }
}

struct PieceStackPart {
    let pieces: [PieceViewModel]
    let square: ModelSquare
    let useDrag: Bool
}
