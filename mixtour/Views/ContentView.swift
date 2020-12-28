import SwiftUI
import MixModel

struct ContentView: View {
    @StateObject private var board = BoardViewModel(board: .example)

    var body: some View {
        HStack {
            VStack {
                Button("New Game") {
                    board.reset()
                }

                Button("Undo") {
                    board.undo()
                }
                .disabled(!board.undoPossible)

                Text(board.gameOverText)
            }
            Spacer()
            GameBackgroundView(board: board)
                .disabled(board.interactionDisabled)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 667, height: 375))
    }
}
