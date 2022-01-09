import SwiftUI

/// Works only on big screens like iPad
/// This is rendered into a png during a unit / snapshot test. Then all other icons are derived from it.
struct AppStoreIconView: View {

    let pieces = [
        PieceViewModel(color: .black, id: 4, zIndex: 5),
        PieceViewModel(color: .white, id: 5, zIndex: 4),
        PieceViewModel(color: .white, id: 1, zIndex: 3),
        PieceViewModel(color: .black, id: 2, zIndex: 2),
        PieceViewModel(color: .white, id: 3, zIndex: 1),
    ]
    @Namespace var iconNamespace

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(MixColors.fieldSecondary)
                        Rectangle()
                            .foregroundColor(MixColors.fieldPrimary)
                    }
                    HStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(MixColors.fieldPrimary)
                        Rectangle()
                            .foregroundColor(MixColors.fieldSecondary)
                    }
                }

                PieceStackView(
                    idOffset: 0,
                    namespace: iconNamespace,
                    stackPart: PieceStackPart(pieces: pieces, square: .init(column: 0, line: 0 )),
                    paddingFactor: 0
                )
                .environmentObject(AnimationConstants())
                .frame(width: 380, height: 380, alignment: .topLeading)
                .offset(y: -25)
            }
        }
        // We need a 1024 x 1024 image for the App Store Icon.
        // Let's use a 2x screen, so 1024 pixels are 512 points.
        .frame(width: 512, height: 512, alignment: .topLeading)
    }
}

#if DEBUG
struct AppStoreIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppStoreIconView()
    }
}
#endif
