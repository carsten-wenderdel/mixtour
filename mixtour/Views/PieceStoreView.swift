import SwiftUI
import MixModel

struct PieceStoreView: View {
    var namespace: Namespace.ID
    let stackPart: PieceStackPart
    let paddingFactor: Double

    var body: some View {
        GeometryReader() { geometry in
            let pieceHeight = geometry.size.height
            let pieceWidth = pieceHeight * 0.8 / 0.18

            ForEach(stackPart.pieces.reversed()) { piece in
                let index = piece.id % 100
                PieceView(color: piece.color)
                    .frame(width: pieceWidth, height: pieceHeight, alignment: .bottom)
                    .matchedGeometryEffect(id: piece.id, in: namespace, properties: .frame)
                    .offset(x: pieceWidth * (CGFloat(index) - 10) * 0.25)
                    .zIndex(piece.zIndex)
                    .animation(Animation.default.speed(0.8))
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
        }
    }
}

#if DEBUG
struct PieceStoreView_Previews: PreviewProvider {
    @Namespace static var namespace

    static func dummyPartForPieces(_ pieceColors: [ModelPlayer]) -> PieceStackPart {
        let pieces = pieceColors.enumerated().map { (index, color) in
            PieceViewModel(color: color, id: index, zIndex: Double(index))
        }
        return PieceStackPart(
            pieces: pieces,
            square: ModelSquare(column: 0, line: 0),
            useDrag: false
        )
    }

    static var previews: some View {
        VStack {
            Spacer()
            PieceStoreView(
                namespace: namespace,
                stackPart: dummyPartForPieces([ModelPlayer].init(repeating: .white, count: 20)),
                paddingFactor: 0.5
            )
            .background(Color.black)
            .frame(height: 13.5)

            Spacer()
            PieceStoreView(
                namespace: namespace,
                stackPart: dummyPartForPieces([ModelPlayer].init(repeating: .black, count: 20)),
                paddingFactor: 0.5
            )
            .background(Color.black)
            .frame(height: 27)
            Spacer()
        }
        .background(Color.gray)
        .frame(height: 200)
    }
}
#endif
