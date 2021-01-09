import SwiftUI
import MixModel

struct GameView: View {
    @ObservedObject var board: BoardViewModel
    @Namespace var namespace

    private let ratio: CGFloat = 0.7
    
    var body: some View {
        GeometryReader() { geometry in
            VStack(alignment: .leading, spacing: 0) {
                PieceStoreView(
                    namespace: namespace,
                    stackPart: board.unusedPiecesPartFor(.white),
                    paddingFactor: 0
                )
                .frame(height: geometry.size.width / 5 * 0.18)
                .padding(.bottom, geometry.size.height / 30)
                .zIndex(8)

                ZStack() {
                    BoardBackgroundView()
                    BoardView(board: board, namespace: namespace)
                }
                .frame(width: geometry.size.width)
                // When the "New Game" or "Undo" button is hit, the pieces move
                // back to the unused stack. To make them visible while moving,
                // the board then needs to have a lower zIndex than those stacks.
                .zIndex(board.undoPossible ? 9 : 7)

                PieceStoreView(namespace: namespace,
                               stackPart: board.unusedPiecesPartFor(.black),
                               paddingFactor: 0
                )
                .frame(height: geometry.size.width / 5 * 0.18)
                .padding(.top, geometry.size.height / 30)
                .zIndex(8)
            }
        }
        .aspectRatio(ratio, contentMode: .fit)
    }
}

struct GameView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        GameView(board: BoardViewModel(board: .example))
    }
}
