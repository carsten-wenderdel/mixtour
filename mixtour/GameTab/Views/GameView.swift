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
                .padding(.bottom, geometry.size.height / 30)
                .zIndex(8)

                ZStack() {
                    BoardBackgroundView()
                    BoardView(
                        board: board,
                        idOffset: idOffset,
                        namespace: namespace
                    )
                    .environmentObject(AnimationConstants())
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

#if DEBUG
struct GameView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        GameView(board: BoardViewModel(board: .example))
    }
}
#endif
