import SwiftUI
import MixModel

struct PieceStackView: View {
    let pieces: [ModelPlayer]

    var body: some View {
        GeometryReader() { geometry in
            let pieceWidth = geometry.size.width * 0.8
            let pieceHeight = geometry.size.height * 0.18
            let bottomPadding = geometry.size.height * 0.1

            HStack() {
                VStack(spacing: 0) {
                    ForEach(pieces) { piece in
                        Rectangle()
                            .foregroundColor(piece == ModelPlayer.black ? .red : .yellow)
                            .frame(width: pieceWidth, height: pieceHeight, alignment: .bottom)
                            .border(Color.black, width: 1)
                            .transition(AnyTransition.scale(scale: 0.01).animation(.easeInOut(duration: 1)))
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
    static var previews: some View {
        VStack {
            PieceStackView(pieces: [.black, .white, .white])
                .background(Color.blue)
            PieceStackView(pieces: [])
                .background(Color.purple)
            PieceStackView(pieces: [.white, .black, .white, .black, .black, .black])
                .background(Color.blue)
            PieceStackView(pieces: [.black])
                .background(Color.purple)
        }
    }
}
