import SwiftUI
import MixModel

struct PieceStackView: View {
    var namespace: Namespace.ID
    let stackPart: PieceStackPart
    let paddingFactor: Double
    @State private var offset = CGSize.zero

    var body: some View {
        GeometryReader() { geometry in
            let pieceWidth = geometry.size.width * 0.8
            let pieceHeight = geometry.size.height * 0.18
            let bottomPadding = pieceHeight * CGFloat(paddingFactor)

            HStack() {
                VStack(spacing: 0) {
                    ForEach(stackPart.pieces) { piece in
                        Rectangle()
                            .foregroundColor(piece.color == .black ? .red : .yellow)
                            .frame(width: pieceWidth, height: pieceHeight, alignment: .bottom)
                            .border(Color.black, width: 1)
                            .zIndex(piece.zIndex)
                            .matchedGeometryEffect(id: piece.id, in: namespace, properties: .frame)
                            .dragOrSetAnimation(drag: stackPart.useDrag)
                    }
                }
                .padding(.bottom, bottomPadding)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
        }
        .aspectRatio(1, contentMode: .fit)
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    self.offset = .zero
                }
        )
    }
}

private extension View {
    func dragOrSetAnimation(drag: Bool) -> some View {
        if drag {
            return AnyView(self.animation(Animation.default.speed(0.5)))
        } else {
            let insertion = AnyTransition.scale(scale: 0.001).animation(.easeInOut(duration: 0.8))
            return AnyView(self.transition(.asymmetric(insertion: insertion, removal: .identity)))
        }
    }
}

struct PieceStackView_Previews: PreviewProvider {
    @Namespace static var namespace

    static func dummyPartForPieces(_ pieceColors: [ModelPlayer]) -> PieceStackPart {
        let pieces = pieceColors.enumerated().map { (index, color) in
            PieceViewModel(color: color, id: index, zIndex: 1.0)
        }
        return PieceStackPart(
            pieces: pieces,
            square: ModelSquare(column: 0, line: 0),
            useDrag: false
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
    }

    static func black(_ id: Int) -> PieceViewModel {
        return PieceViewModel(color: .black, id: id, zIndex: 0)
    }

    static func white(_ id: Int) -> PieceViewModel {
        return PieceViewModel(color: .white, id: id, zIndex: 0)
    }
}
