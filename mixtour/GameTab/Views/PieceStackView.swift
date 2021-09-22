import SwiftUI
import MixModel

struct PieceStackView: View {
    @EnvironmentObject var animationConstants: AnimationConstants
    var namespace: Namespace.ID
    let stackPart: PieceStackPart
    let paddingFactor: Double

    var body: some View {
        GeometryReader() { geometry in
            let pieceWidth = geometry.size.width * 0.8
            let pieceHeight = geometry.size.height * 0.18
            let bottomPadding = pieceHeight * CGFloat(paddingFactor)

            HStack() {
                VStack(spacing: 0) {
                    ForEach(stackPart.pieces) { piece in
                        PieceView(color: piece.color)
                            .frame(width: pieceWidth, height: pieceHeight, alignment: .bottom)
                            .zIndex(piece.zIndex)
                            .matchedGeometryEffect(id: piece.id, in: namespace)
                            .animation(animationConstants.pieceAnimation)
                    }
                }
                .padding(.bottom, bottomPadding)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#if DEBUG
struct PieceStackView_Previews: PreviewProvider {
    @Namespace static var namespace

    static func dummyPartForPieces(_ pieceColors: [PlayerColor]) -> PieceStackPart {
        let pieces = pieceColors.enumerated().map { (index, color) in
            PieceViewModel(color: color, id: index, zIndex: 1.0)
        }
        return PieceStackPart(
            pieces: pieces,
            square: Square(column: 0, line: 0)
        )
    }

    static var previews: some View {
        VStack {
            PieceStackView(
                namespace: namespace,
                stackPart: dummyPartForPieces([.black, .white, .white]),
                paddingFactor: 0.5
            )
            .background(Color.blue)

            PieceStackView(
                namespace: namespace,
                stackPart: dummyPartForPieces([]),
                paddingFactor: 0.5
            )
            .background(Color.purple)

            PieceStackView(
                namespace: namespace,
                stackPart: dummyPartForPieces([.white, .black, .white, .black, .black, .black]),
                paddingFactor: 0.5
            )
            .background(Color.blue)

            PieceStackView(
                namespace: namespace,
                stackPart: dummyPartForPieces([.black]),
                paddingFactor: 0.5
            )
            .background(Color.purple)
        }
        .environmentObject(AnimationConstants())
    }
}
#endif
