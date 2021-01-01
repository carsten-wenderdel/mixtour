import SwiftUI
import MixModel

struct GameView: View {
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
//                            .opacity(stackVM.isEmpty ? 0.1 : 1)

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
        }
        .aspectRatio(1, contentMode: .fit)
//        .rotation3DEffect(
//            Angle(degrees: 25),
//            axis: (x: 1, y: 0, z: 0),
//            anchor: UnitPoint(x: 0.5, y: 0),
//            anchorZ: 0,
//            perspective: 0.5
//        )
//        .transformEffect(.init(a: 1, b: 0, c: 0, d: 1.3, tx: 1, ty: 1))
//        .scaleEffect(0.9)
        .offset(.init(width: 0, height: -20))
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack() {
                MixColors.background
                GameView(board: BoardViewModel(board: .example))
            }
            .environment(\.colorScheme, .light)


            ZStack {
                MixColors.background
                GameView(board: BoardViewModel(board: .example))
            }
            .environment(\.colorScheme, .dark)
        }
    }
}