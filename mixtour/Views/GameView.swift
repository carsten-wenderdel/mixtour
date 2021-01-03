import SwiftUI
import MixModel

struct GameView: View {
    @ObservedObject var board: BoardViewModel
    @Namespace var namespace
    
    var body: some View {
        GeometryReader() { geometry in
            HStack(alignment: .bottom, spacing: 0) {
                PieceStackView(
                    namespace: namespace,
                    stackPart: board.unusedPiecesPartFor(.white),
                    paddingFactor: 0
                )
                .frame(width: geometry.size.width / 7)
                .padding(.bottom, geometry.size.height / 30)

                ZStack() {
                    BoardBackgroundView()
                    BoardView(board: board, namespace: namespace)
                }
                .frame(width: 5 * geometry.size.width / 7)

                PieceStackView(namespace: namespace,
                               stackPart: board.unusedPiecesPartFor(.black),
                               paddingFactor: 0
                )
                .frame(width: geometry.size.width / 7)
                .padding(.bottom, geometry.size.height / 30)
            }
        }
        .aspectRatio(1.4, contentMode: .fit)
    }
}

struct GameView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        GameView(board: BoardViewModel(board: .example))
    }
}
