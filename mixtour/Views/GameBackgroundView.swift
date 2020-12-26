import SwiftUI
import MixModel

struct GameBackgroundView: View {
    @ObservedObject var board: BoardViewModel
    @Namespace private var namespace

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                BoardBackgroundView()
                VStack(spacing: 0) {
                    ForEach(0..<numberOfSquares) { line in
                        HStack(spacing: 0) {
                            ForEach(0..<numberOfSquares) { column in
                                let square = ModelSquare(column: column, line: line)
                                PieceStackView(namespace: namespace, pieces: board.piecesAtSquare(square))
                                    .zIndex(board.zIndexForColumn(column))
                                    .contentShape(Rectangle()) // to allow taps on empty views
                                    .onTapGesture(count: 2) {
                                        board.trySettingPieceTo(square)
                                    }
                            }
                        }
                        .zIndex(board.zIndexForLine(line))
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct GameBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        GameBackgroundView(board: BoardViewModel(board: .example))
    }
}
