import SwiftUI
import MixModel

struct PickedPieceStackView: View {
    var namespace: Namespace.ID
    let stackPart: PieceStackPart
    let paddingFactor: Double

    @ObservedObject var board: BoardViewModel
    @State private var offset = CGSize.zero

    var body: some View {
        GeometryReader() { geometry in
            PieceStackView(
                namespace: namespace,
                stackPart: stackPart,
                paddingFactor: paddingFactor
            )
            .opacity(0.6)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.offset = gesture.translation
                    }
                    .onEnded { gesture in
                        if let target = squareOn(gesture.translation, in: geometry.size) {
                            let success = board.tryDrag(
                                stackPart.pieces.count,
                                from: stackPart.square,
                                to: target
                            )
                            if (!success) {
                                self.offset = .zero
                            }
                        } else {
                            self.offset = .zero
                        }
                    }
            )
        }
    }

    func squareOn(_ translation: CGSize, in geometrySize: CGSize) -> ModelSquare? {
        let line = stackPart.square.line + Int(round(translation.height / geometrySize.height))
        let column = stackPart.square.column + Int(round(translation.width / geometrySize.width))
        if (0...4).contains(line) && (0...4).contains(column) {
            return ModelSquare( column: column, line: line)
        } else {
            return nil
        }
    }
}
