import SwiftUI
import MixModel

struct ContentView: View {
    @StateObject private var board = BoardViewModel(board: .example)

    var body: some View {
        GameBackgroundView(board: board)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
