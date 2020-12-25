import SwiftUI
import MixModel

struct PieceStackView: View {
    var namespace: Namespace.ID
    let pieces: [PieceViewModel]

    var body: some View {
        GeometryReader() { geometry in
            let pieceWidth = geometry.size.width * 0.8
            let pieceHeight = geometry.size.height * 0.18
            let bottomPadding = geometry.size.height * 0.1

            HStack() {
                VStack(spacing: 0) {
                    ForEach(pieces) { piece in
                        Rectangle()
                            .foregroundColor(piece.color == .black ? .red : .yellow)
                            .frame(width: pieceWidth, height: pieceHeight, alignment: .bottom)
                            .border(Color.black, width: 1)
                            .matchedGeometryEffect(id: piece.id, in: namespace, properties: .frame)
                            .animation(.easeInOut(duration: 0.5))
//                            .transition(AnyTransition.scale(scale: 0.01).animation(.easeInOut(duration: 1)))
                    }
                }
                .padding(.bottom, bottomPadding)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PieceStackView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        VStack {
            PieceStackView(namespace: namespace, pieces: [black(0), white(1), white(2)])
                .background(Color.blue)
            PieceStackView(namespace: namespace, pieces: [])
                .background(Color.purple)
            PieceStackView(namespace: namespace, pieces: [white(0), black(1), white(2), black(3), black(4), black(5)])
                .background(Color.blue)
            PieceStackView(namespace: namespace, pieces: [black(0)])
                .background(Color.purple)
        }
    }

    static func black(_ id: Int) -> PieceViewModel {
        return PieceViewModel(color: .black, id: "\(id)")
    }

    static func white(_ id: Int) -> PieceViewModel {
        return PieceViewModel(color: .white, id: "\(id)")
    }
}
