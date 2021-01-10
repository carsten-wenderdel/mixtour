import SwiftUI
import MixModel

struct ContentView: View {
    @StateObject private var board = BoardViewModel(board: .example)

    var body: some View {
        ZStack {
            MixColors.background
                .ignoresSafeArea()

            VStack {
                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        board.reset()
                    }) {
                        Image(systemName: "plus")
                            .font(Constants.buttonImageFont)
                        Text("Neues Spiel")
                            .font(Constants.buttonTextFont)
                    }

                    Spacer()
                    Button(action: {
                        board.undo()
                    }) {
                        Image(systemName: "arrow.uturn.backward")
                            .font(Constants.buttonImageFont)
                        Text("Rückgängig")
                            .font(Constants.buttonTextFont)
                    }
                    .disabled(!board.undoPossible)

                    Spacer()
                }
                Spacer()
                Text(board.gameOverText)

                Spacer()
                GameView(board: board)
                    .disabled(board.interactionDisabled)

                Spacer()
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .dark)
//            .previewLayout(.fixed(width: 667, height: 375))
    }
}
#endif
