import SwiftUI
import MixModel

struct PieceView: View {
    let color: ModelPlayer

    var body: some View {
        GeometryReader() { geometry in
            Ellipse()
                .frame(width: geometry.size.width, height: geometry.size.height * 1.3, alignment: .center)
                .foregroundColor(color == .black ? MixColors.pieceBlack : MixColors.pieceWhite)
                .shadow(color: .blue, radius: 2)
                .shadow(color: .blue, radius: 2)
        }
    }
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack() {
            Color.gray
            PieceView(color: .black)
                .frame(width: 320, height: 72, alignment: .center)
        }
    }
}
