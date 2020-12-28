import SwiftUI
import MixModel

struct GameBackgroundView: View {
    @ObservedObject var board: BoardViewModel
    @Namespace private var namespace

    var body: some View {
        ZStack {
            BoardBackgroundView()
            VStack(spacing: 0) {
                ForEach(0..<numberOfSquares) { line in
                    HStack(spacing: 0) {
                        ForEach(0..<numberOfSquares) { column in
                            let square = ModelSquare(column: column, line: line)
                            let stackVM = board.stackAtSquare(square)
                            ZStack {
                                if stackVM.pickedPart.pieces.count > 0 {
                                    PieceStackView(
                                        namespace: namespace,
                                        stackPart: stackVM.defaultPart,
                                        paddingFactor: 0.5
                                    )
                                    PickedPieceStackView(
                                        namespace: namespace,
                                        stackPart: stackVM.pickedPart,
                                        paddingFactor: 1.1 + Double(stackVM.defaultPart.pieces.count),
                                        board: board
                                    )
                                } else { // make normal stack draggable
                                    PickedPieceStackView(
                                        namespace: namespace,
                                        stackPart: stackVM.defaultPart,
                                        paddingFactor: 0.5,
                                        board: board
                                    )
                                }
                            }
                            .zIndex(board.zIndexForColumn(column))
                            .contentShape(Rectangle()) // to allow taps on empty views
                            .onTapGesture(count: stackVM.isEmpty ? 2 : 1) {
                                if stackVM.isEmpty {
                                    board.trySettingPieceTo(square)
                                } else {
                                    board.pickPieceFromSquare(square)
                                }
                            }
                        }
                    }
                    .zIndex(board.zIndexForLine(line))
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
