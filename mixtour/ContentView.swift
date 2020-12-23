import SwiftUI
import MixModel

struct ContentView: View {
    var body: some View {
        GameBackgroundView(board: ModelBoard())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
