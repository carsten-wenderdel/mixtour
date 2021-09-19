import SwiftUI
import MixModel

struct BoardBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<numberOfSquares) { line in
                    HStack(spacing: 0) {
                        ForEach(0..<numberOfSquares) { column in
                            let color = (line + column) % 2 == 0
                                ? MixColors.fieldSecondary
                                : MixColors.fieldPrimary
                            Rectangle()
                                .cornerRadius(geometry.size.height * 0.028)
                                .foregroundColor(color)
                        }
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .background(MixColors.fieldPrimary)
    }
}

#if DEBUG
struct BoardBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BoardBackgroundView()
    }
}
#endif
