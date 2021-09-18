import SwiftUI
import MixModel

struct GameSnapshotView: View {

    private let textBoardRatio = 0.15
    private var board = BoardViewModel(board: .example, computer: DummyComputerPlayer())
    @Namespace var namespace

    var body: some View {
        GeometryReader() { geometry in
            // height and width are identical because aspectRatio is 1
            let cornerLength = geometry.size.height * textBoardRatio
            let boardLength = geometry.size.width * (1 - 2 * textBoardRatio)

            VStack(spacing: 0) {
                TopBottomDescription()
                .frame(width: boardLength, height: cornerLength)

                HStack(spacing: 0) {
                    LeftRightDescription()
                    .frame(width: cornerLength, height: boardLength)

                    ZStack() {
                        BoardBackgroundView()
                        BoardView(board: board, namespace: namespace)
                    }
                    .frame(width: boardLength, height: boardLength)

                    LeftRightDescription()
                    .frame(width: cornerLength, height: boardLength)
                }
                TopBottomDescription()
                .frame(width: boardLength,height: cornerLength)
            }
            .disabled(true)
        }
        .background(.background)
        .aspectRatio(1, contentMode: .fit)
    }

    private struct TopBottomDescription: View {
        var body: some View {
            HStack(spacing: 0) {
                ExpandedText("a")
                ExpandedText("b")
                ExpandedText("c")
                ExpandedText("d")
                ExpandedText("e")
            }
            .tint(.purple)
        }
    }

    private struct LeftRightDescription: View {
        var body: some View {
            VStack(spacing: 0) {
                ExpandedText("1")
                ExpandedText("2")
                ExpandedText("3")
                ExpandedText("4")
                ExpandedText("5")
            }
        }
    }

    private struct ExpandedText: View {
        let string: String

        init(_ string: String) {
            self.string = string
        }

        var body: some View {
            Text(string)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(Constants.gameSnapshotFont)
                .foregroundColor(.secondary)
        }
    }
}

#if DEBUG
struct GameSnapshotView_Previews: PreviewProvider {
    static var previews: some View {
        GameSnapshotView()
            .environment(\.colorScheme, .dark)
    }
}
#endif
