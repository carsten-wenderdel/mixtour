import SwiftUI
import MixModel

struct ContentView: View {
    @StateObject private var board = BoardViewModel()

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
                            Menu(LocalizedStringKey("White")) {
                                Section { Text("Strength of Computer Player") }
                                Section {
                                    Button(LocalizedStringKey("Anfänger")) { board.reset(color: .white, computer: .beginner) }
                                    Button(LocalizedStringKey("Fortgeschritten")) { board.reset(color: .white, computer: .advanced) }
                                }
                            }
                            Menu(LocalizedStringKey("Red")) {
                                Section { Text("Strength of Computer Player") }
                                Section {
                                    Button(LocalizedStringKey("Beginner")) { board.reset(color: .black, computer: .beginner) }
                                    Button(LocalizedStringKey("Advanced")) { board.reset(color: .black, computer: .advanced) }
                                }
                            }
                            Button(LocalizedStringKey("Computer vs Computer")) { board.startComputerPlay() }
                        }
                    }
                    label: {
                        Image(systemName: "plus")
                            .font(Constants.buttonImageFont)
                        Text(LocalizedStringKey("New Game"))
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
