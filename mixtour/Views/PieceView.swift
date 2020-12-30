import SwiftUI
import MixModel

struct PieceView: View {
    let color: ModelPlayer

    var body: some View {
        Rectangle()
            .foregroundColor(color == .black ? MixColors.pieceBlack : MixColors.pieceWhite)
            .border(Color.black, width: 1)

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
