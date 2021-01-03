import SwiftUI
import MixModel

struct BoardView: View {
    @ObservedObject var board: BoardViewModel
    var namespace: Namespace.ID

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<numberOfSquares) { line in
                HStack(spacing: 0) {
                    ForEach(0..<numberOfSquares) { column in
                        let square = ModelSquare(column: column, line: line)
                        let stackVM = board.stackAtSquare(square)

                        let emptyPart = PieceStackPart(pieces: [], square: square, useDrag: false)
                        let bottomPart = stackVM.pickedPart.pieces.count > 0 ? stackVM.defaultPart : emptyPart
                        let topPart = stackVM.pickedPart.pieces.count > 0 ? stackVM.pickedPart : stackVM.defaultPart
                        let topPaddingFactor = stackVM.pickedPart.pieces.count > 0
                            ? 1.1 + Double(stackVM.defaultPart.pieces.count)
                            : 0.5

                        ZStack {
                            PieceStackView(
                                namespace: namespace,
                                stackPart: bottomPart,
                                paddingFactor: 0.5
                            )
                            PickedPieceStackView(
                                namespace: namespace,
                                stackPart: topPart,
                                paddingFactor: topPaddingFactor,
                                board: board
                            )
                        }
                        .zIndex(board.zIndexForColumn(column))
                        .contentShape(Rectangle()) // to allow taps on empty views
                        .onTapGesture(count: stackVM.isEmpty ? 2 : 1) {
                            if stackVM.isEmpty {
                                board.trySettingPieceTo(square)
                            } else {
                                if (stackVM.totalNumberOfPieces > 1) {
                                    board.pickPieceFromSquare(square)
                                }
                            }
                        }
                    }
                }
                .zIndex(board.zIndexForLine(line))
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct BoardView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        Group {
            ZStack() {
                MixColors.background
                BoardView(board: BoardViewModel(board: .example), namespace: namespace)
            }
            .environment(\.colorScheme, .light)


            ZStack {
                MixColors.background
                BoardView(board: BoardViewModel(board: .example), namespace: namespace)
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
