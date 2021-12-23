import SwiftUI
import MixModel

struct GameView: View {
    // Because of a bug in SwiftUI, we have to trigger reloading the view
    // when this view disappears and reappears. This happens for example
    // when switching tabs in a `TabView`.
    // In this case animations using matchedGeometryEffect don't work anymore.
    // They are not animated anymore - maybe `namespace` or `id` get's lost.
    // Somehow the connection between two (identical) views before and after
    // switching the tab is lost.
    // We now use a hacky workaround for that: when this view disappears we
    // trigger a reload later by putting new IDs into the views used by
    // matchedGeometryEffect. Then the view is redrawn and later animations
    // work again.
    // See also
    // https://stackoverflow.com/questions/69472212/broken-swiftui-animation-when-using-tabview
    @State private var idOffset = 1000

    @ObservedObject var board: BoardViewModel
    @Namespace var namespace

    private let ratio: CGFloat = 0.7
    
    var body: some View {
        GeometryReader() { geometry in
            VStack(alignment: .leading, spacing: 0) {
                PieceStoreView(
                    idOffset: idOffset,
                    namespace: namespace,
                    stackPart: board.unusedPiecesComputer()
                )
                .frame(height: geometry.size.width / 5 * 0.18)
                // Magic number: we add 1% of the screen width here, but not for the second PieceStoreView. This is because Pieces are not rendered symmetrically, they extend below their frame. This should be fixed some time, but then other margins also need to be adjusted. So let's go with this hack until then.
                .padding(.bottom, geometry.size.height / 30 + geometry.size.width * 0.01)
                .zIndex(8)

                ZStack() {
                    BoardBackgroundView()
                    BoardView(
                        board: board,
                        idOffset: idOffset,
                        namespace: namespace
                    ).environmentObject(AnimationConstants())

                    // We show both, otherwise animation will look funny because of changing text
                    GameOverView(text: board.computerHasWonText, show: board.computerHasWon)
                    GameOverView(text: board.humanHasWonText, show: board.humanHasWon)
                }
                .frame(width: geometry.size.width)
                // When the "New Game" or "Undo" button is hit, the pieces move
                // back to the unused stack. To make them visible while moving,
                // the board then needs to have a lower zIndex than those stacks.
                .zIndex(board.undoPossible ? 9 : 7)

                PieceStoreView(
                    idOffset: idOffset,
                    namespace: namespace,
                    stackPart: board.unusedPiecesHuman()
                )
                .frame(height: geometry.size.width / 5 * 0.18)
                .padding(.top, geometry.size.height / 30)
                .zIndex(8)
            }
        }
        .aspectRatio(ratio, contentMode: .fit)
        .onDisappear() {
            assert(abs(idOffset) >= 1000)
            idOffset *= -1
        }
    }
}

struct GameOverView: View {
    var text: String
    var show: Bool

    var body: some View {
        Text(text)
            .font(Constants.gameOverFont)
            .multilineTextAlignment(.center)
            // Will increase text size when showing
            .scaleEffect(show ? 1 : 0.5)
            .opacity(show ? 0.8 : 0)
            // Wait until move is made until text is shown
            .animation(Animation.default.speed(0.6).delay(show ? 1.1 : 0), value: show)
    }
}

#if DEBUG
struct GameView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        GameView(board: BoardViewModel(board: .example, computerVM: .dummy))
    }
}
#endif
