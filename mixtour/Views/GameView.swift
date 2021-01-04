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
                .zIndex(80)

                ZStack() {
                    BoardBackgroundView()
                    BoardView(board: board, namespace: namespace)
                }
                .frame(width: geometry.size.width)
                .zIndex(90)

                PieceStoreView(namespace: namespace,
                               stackPart: board.unusedPiecesPartFor(.black),
                               paddingFactor: 0
                )
                .frame(height: geometry.size.width / 5 * 0.18)
                .padding(.top, geometry.size.height / 30)
                .zIndex(80)
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
