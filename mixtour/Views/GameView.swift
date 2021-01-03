import SwiftUI
import MixModel

struct GameView: View {
    @ObservedObject var board: BoardViewModel
    @Namespace var namespace
    
    var body: some View {
        ZStack() {
            BoardBackgroundView()
            BoardView(board: board, namespace: namespace)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        GameView(board: BoardViewModel(board: .example))
    }
}
