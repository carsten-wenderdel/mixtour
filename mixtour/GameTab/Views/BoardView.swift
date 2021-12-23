import SwiftUI
import MixModel

struct BoardView: View {
    @ObservedObject var board: BoardViewModel
    var idOffset: Int
    var namespace: Namespace.ID
    @State private var draggedSquare: Square?

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<numberOfSquares) { line in
                HStack(spacing: 0) {
                    ForEach(0..<numberOfSquares) { column in
                        let square = Square(column: column, line: line)
                        let stackVM = board.stackAtSquare(square)

                        let emptyPart = PieceStackPart(pieces: [], square: square)
                        let bottomPart = stackVM.pickedPart.pieces.count > 0 ? stackVM.defaultPart : emptyPart
                        let topPart = stackVM.pickedPart.pieces.count > 0 ? stackVM.pickedPart : stackVM.defaultPart
                        let topPaddingFactor = stackVM.pickedPart.pieces.count > 0
                            ? 1.1 + Double(stackVM.defaultPart.pieces.count)
                            : 0.5

                        ZStack {
                            PieceStackView(
                                idOffset: idOffset,
                                namespace: namespace,
                                stackPart: bottomPart,
                                paddingFactor: 0.5
                            )
                            PickedPieceStackView(
                                namespace: namespace,
                                idOffset: idOffset,
                                stackPart: topPart,
                                paddingFactor: topPaddingFactor,
                                draggedSquare: $draggedSquare,
                                board: board
                            )
                        }
                        .zIndex(square == draggedSquare ? 10 : board.zIndexForColumn(column))
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
                .zIndex(line == draggedSquare?.line ? 10 :board.zIndexForLine(line))
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#if DEBUG
struct BoardView_Previews: PreviewProvider {
    @Namespace static var namespace
    @State static var idOffset = 1000

    static var previews: some View {
        Group {
            ZStack() {
                MixColors.background
                BoardView(board: BoardViewModel(board: .example, computerVM: .dummy), idOffset: idOffset, namespace: namespace)
                    .environmentObject(AnimationConstants())
            }
            .environment(\.colorScheme, .light)


            ZStack {
                MixColors.background
                BoardView(board: BoardViewModel(board: .example, computerVM: .dummy), idOffset: idOffset, namespace: namespace)
                    .environmentObject(AnimationConstants())
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
#endif
