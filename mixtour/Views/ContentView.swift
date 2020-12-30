import SwiftUI
import MixModel

struct ContentView: View {
    @StateObject private var board = BoardViewModel(board: .example)

    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.93, blue: 1.0)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Button("New Game") {
                        board.reset()
                    }

                    Spacer()

                    Button("Undo") {
                        board.undo()
                    }
                    .disabled(!board.undoPossible)

                    Spacer()

                    Text(board.gameOverText)
                }

                Spacer()

                GameBackgroundView(board: board)
                    .disabled(board.interactionDisabled)

                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 667, height: 375))
    }
}
