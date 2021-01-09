import SwiftUI
import MixModel

struct PieceView: View {
    let color: ModelPlayer

    var body: some View {
        GeometryReader() { geometry in
            let shadowWidth = 12 * geometry.size.height / 100
            Ellipse()
                .frame(width: geometry.size.width, height: geometry.size.height * 1.3, alignment: .center)
                .foregroundColor(color == .black ? MixColors.pieceBlack : MixColors.pieceWhite)
                .innerShadow(using: Ellipse(), width: shadowWidth, blur: shadowWidth)
//                .shadow(color: .blue, radius: 1)
        }
    }
}

extension View {
    // Stolen from https://www.hackingwithswift.com/plus/swiftui-special-effects/shadows-and-glows
    func innerShadow<S: Shape>(using shape: S, angle: Angle = .degrees(0), color: Color = .black, width: CGFloat = 6, blur: CGFloat = 6) -> some View {
        let finalX = CGFloat(cos(angle.radians - .pi / 2))
        let finalY = CGFloat(sin(angle.radians - .pi / 2))

        return self
            .overlay(
                shape
                    .stroke(color, lineWidth: width)
                    .offset(x: finalX * width * 0.6, y: finalY * width * 0.6)
                    .blur(radius: blur)
                    .mask(shape)
            )
    }
}

#if DEBUG
struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack() {
            Color.gray
            PieceView(color: .black)
                .frame(width: 320, height: 72, alignment: .center)
        }
    }
}
#endif
