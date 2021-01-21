import SwiftUI
import MixModel

struct ContentView: View {
    @StateObject private var bestMove = BestMoveVM()

    var body: some View {
        Button(action: {
            bestMove.startMeasuring()
        }) {
            Text("Start")
        }

        Text(bestMove.average)
        Text(bestMove.fastest)

        List {
            ForEach(bestMove.seconds, id: \.self) { second in
                Text("\(second)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
