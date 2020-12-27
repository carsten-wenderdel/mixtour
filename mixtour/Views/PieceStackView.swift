import SwiftUI
import MixModel

struct PieceStackView: View {
    var namespace: Namespace.ID
    let pieces: [PieceViewModel]
    let paddingFactor: Double
    let dragAnimation: Bool
    @State private var offset = CGSize.zero

    var body: some View {
        GeometryReader() { geometry in
            let pieceWidth = geometry.size.width * 0.8
            let pieceHeight = geometry.size.height * 0.18
            let bottomPadding = pieceHeight * CGFloat(paddingFactor)

            HStack() {
                VStack(spacing: 0) {
                    ForEach(pieces) { piece in
                        Rectangle()
                            .foregroundColor(piece.color == .black ? .red : .yellow)
                            .frame(width: pieceWidth, height: pieceHeight, alignment: .bottom)
                            .border(Color.black, width: 1)
                            .zIndex(piece.zIndex)
                            .matchedGeometryEffect(id: piece.id, in: namespace, properties: .frame)
                            .dragOrSetAnimation(drag: dragAnimation)
                    }
                }
//                .border(Color.green, width: 3)
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
                .onEnded { _ in
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

    static var previews: some View {
        VStack {
            PieceStackView(
                namespace: namespace,
                pieces: [black(0), white(1), white(2)],
                paddingFactor: 0,
                dragAnimation: false
            )
            .background(Color.blue)

            PieceStackView(
                namespace: namespace,
                pieces: [],
                paddingFactor: 0,
                dragAnimation: false
            )
            .background(Color.purple)

            PieceStackView(
                namespace: namespace,
                pieces: [white(0), black(1), white(2), black(3), black(4), black(5)],
                paddingFactor: 0,
                dragAnimation: false
            )
            .background(Color.blue)

            PieceStackView(
                namespace: namespace,
                pieces: [black(0)],
                paddingFactor: 0,
                dragAnimation: false
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
