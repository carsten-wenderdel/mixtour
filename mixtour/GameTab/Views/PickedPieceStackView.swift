import SwiftUI
import MixModel

struct PickedPieceStackView: View {
    var namespace: Namespace.ID
    var idOffset: Int
    let stackPart: PieceStackPart
    let paddingFactor: Double
    @Binding var draggedSquare: Square?

    @ObservedObject var board: BoardViewModel
    @GestureState private var translation = CGSize.zero
    @State private var opacity = 1.0

    var body: some View {
        GeometryReader() { geometry in
            PieceStackView(
                idOffset: idOffset,
                namespace: namespace,
                stackPart: stackPart,
                paddingFactor: paddingFactor
            )
            .contentShape(Rectangle()) // to allow dragging when starting a bit above the pieces
            .opacity(opacity)
            .offset(translation)
            .gesture(
                DragGesture()
                    .updating($translation) { (gesture, translation, transaction) in
//                        print("updating: \(gesture.translation.width), \(gesture.translation.height)")
                        translation = adjustedTranslation(gesture, in: geometry.size)
                        if let square = squareOn(gesture, in: geometry.size) {
                            print("\(square.column), \(square.line)")
                        }
                    }
                    .onChanged() { gesture in
//                        print("onChanged: \(gesture.translation.width), \(gesture.translation.height)")
                        if opacity == 1.0 {
                            // Dragging starts
                            draggedSquare = stackPart.square
                            board.stopPickingOtherThan(stackPart.square)
                        }
                        self.opacity = 0.6
                    }
                    .onEnded { gesture in
//                        print("onEnded: \(gesture.translation.width), \(gesture.translation.height)")
                        self.opacity = 1.0
                        if let target = squareOn(gesture, in: geometry.size) {
                            board.tryDrag(
                                stackPart.pieces.count,
                                from: stackPart.square,
                                to: target
                            )
                        }
                    }
            )
        }
    }

    /// We need to adjust translation because of two reasons:
    /// 1. To compensate the gesture not starting in the center of a tile
    /// 2. To compensate different number of pieces and their position within the tile
    private func adjustedTranslation(_ gesture: DragGesture.Value, in geometrySize: CGSize) -> CGSize {
        // 1. adjust translation so that it's as if it had started at the center of this view
        let width = gesture.translation.width + gesture.startLocation.x - geometrySize.width / 2
        var height = gesture.translation.height + gesture.startLocation.y - geometrySize.height / 2

        // 2. Adjusting for different positioning of tiles prior to drag gesture:
        // Move pieces a bit above the finger instead of below
        var heightAdjust: CGFloat = -0.7 // the smaller, the higher the piece
        // Finger has always same position relative to center of stack as to center of single piece
        heightAdjust += 0.5 * PieceStackView.pieceHeightRatio * CGFloat(stackPart.pieces.count)
        // Adjust if there is non moving stack of pieces below
        heightAdjust += paddingFactor * PieceStackView.pieceHeightRatio
        // Adding to that variable instead of having a sum in multiple lines helps the compiler -> shorter compile times

        // Adjusting was relative to height of tile - translate into points
        height += geometrySize.height * heightAdjust
        return CGSize(width: width, height: height)
    }

    private func squareOn(_ gesture: DragGesture.Value, in geometrySize: CGSize) -> Square? {
        // Now we do the opposite of the 1st part of adjustedTranslation:
        // We don't have to add half of the size of the tile (geometry.width/2) because Int() already rounds down.
        let column = Int(CGFloat(stackPart.square.column) + (gesture.translation.width + gesture.startLocation.x) / geometrySize.width)
        let line = Int(CGFloat(stackPart.square.line)  + (gesture.translation.height + gesture.startLocation.y) / geometrySize.height)
        if (0...4).contains(line) && (0...4).contains(column) {
            return Square(column: column, line: line)
        } else {
            return nil
        }
    }
}
