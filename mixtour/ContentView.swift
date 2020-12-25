import SwiftUI
import MixModel

struct ContentView: View {
    @StateObject private var board = ModelBoard.example

    var body: some View {
        GameBackgroundView(board: .example)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
