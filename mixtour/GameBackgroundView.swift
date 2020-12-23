import SwiftUI
import MixModel

struct GameBackgroundView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                ForEach(0..<numberOfSquares) { line in
                    HStack(spacing: 0) {
                        ForEach(0..<numberOfSquares) { column in
                            let color = (line + column) % 2 == 0
                                ? Color(red: 0.9, green: 0.93, blue: 1.0)
                                : Color(red: 0.8, green: 0.85, blue: 1.0)
                            Rectangle()
                                .foregroundColor(color)
                        }
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct GameBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        GameBackgroundView()
    }
}
