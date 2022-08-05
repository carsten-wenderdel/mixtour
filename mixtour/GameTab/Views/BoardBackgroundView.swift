import SwiftUI
import MixModel

struct BoardBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // "5" is the number of rows/columns. No global variable without compiler warning, see
                // https://forums.swift.org/t/how-for-swiftui-foreach-init-data-range-int-viewbuilder-content-escaping-int-content-compiler-is-able-to-warn-if-range-is-not-constant/55233
                ForEach(0..<5) { line in
                    HStack(spacing: 0) {
                        ForEach(0..<5) { column in
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
