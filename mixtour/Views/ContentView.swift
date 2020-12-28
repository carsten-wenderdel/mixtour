import SwiftUI
import MixModel

struct ContentView: View {
    @StateObject private var board = BoardViewModel(board: .example)

    var body: some View {
        Button("New Game") {
            board.reset()
        }

        Button("Undo") {
            board.undo()
        }
        .disabled(!board.undoPossible)
        
        GameBackgroundView(board: board)
            .disabled(board.interactionDisabled)

        Text(board.gameOverText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
