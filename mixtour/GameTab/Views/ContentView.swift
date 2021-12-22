import SwiftUI
import MixModel

struct ContentView: View {
    @StateObject private var board = BoardViewModel(computer: CachePlayer(MonteCarloPlayer.beginner))

    var body: some View {
        ZStack {
            MixColors.background
                .ignoresSafeArea()

            VStack {
                Spacer()

                HStack {
                    Menu {
                        Section { Text("Your Color") }
                        Section {
                            ForEach([PlayerColor.white, PlayerColor.black]) { color in
                                Menu(color.labelText) {
                                    Section { Text("Strength of Computer Player") }
                                    Section {
                                        ForEach(MCPlayerConfig.allCases, id: \.self) { config in
                                            Button(config.labelText) {
                                                board.reset(color: color, computer: CachePlayer(MonteCarloPlayer(config: config)))
                                            }
                                        }
                                    }
                                }
                            }
//                            Button("Computer vs Computer") { board.startComputerPlay() }
                        }
                    }
                    label: {
                        Image(systemName: "plus")
                            .font(Constants.buttonImageFont)
                        Text("New Game")
                            .font(Constants.buttonTextFont)
                    }

                    Spacer()
                    Button(action: {
                        board.undo()
                    }) {
                        Image(systemName: "arrow.uturn.backward")
                            .font(Constants.buttonImageFont)
                        Text("Undo")
                            .font(Constants.buttonTextFont)
                    }
                    .disabled(!board.undoPossible)
                }
                
                Spacer()
                Text(board.computerPlayerInfo)
                    .foregroundColor(.secondary)
                    .padding(.top, 10)

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
