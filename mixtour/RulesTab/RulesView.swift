import SwiftUI
import MixModel

struct RulesView: View {
    var body: some View {
        NavigationView {
            ScrollView([.vertical]) {
                RulesTextView()
                    .frame(maxWidth: 500) // Biggest phone is 428 points wide. On iPads don't use whole screen for text.
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    .frame(maxWidth: .infinity) // On iPads push the scrollingIndicator to the left edge of the screen
                // It's a bit strange to call `.frame` twice - but it works.
            }
            .multilineTextAlignment(.leading)
            .environmentObject(AnimationConstants())
            .navigationBarTitle("Mixtour")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // full screen on iPad
    }
}

private struct RulesTextView: View {
    var body: some View {
        Group {
            // Mixtour
            Text("Rules_Text1-1")
                .font(.headline)

            // Material
            Text("Rules_Title2")
                .font(.title)
            Text("Rules_Text2-1")
            Text("Rules_Text2-2")

            BoardIllustrationView(Board()).frame(width: 250)
            Text("Rules_Text2-3")

            // Objective
            Text("Rules_Title3")
                .font(.title)
            Text("Rules_Text3-1")
        }
        Group {
            // Preparation
            Text("Rules_Title4")
                .font(.title)
            Text("Rules_Text4-1")
            Text("Rules_Text4-2")

            // Play
            Text("Rules_Title5")
                .font(.title)
            Text("Rules_Text5-1")
            Text("Rules_Text5-2")
            Text("Rules_Text5-3")
            Text("Rules_Text5-4")
        }
        Group {
            // Enter a piece
            Text("Rules_Title6")
                .font(.title)
            Text("Rules_Text6-1")

            // Move a stack
            Text("Rules_Title7")
                .font(.title)
            Text("Rules_Text7-1")
            Text("Rules_Text7-2")
            Text("Rules_Text7-3")
            Text("Rules_Text7-4")
            Text("Rules_Text7-5")
            Text("Rules_Text7-6")
        }
        Group {
            // Examples
            Text("Rules_Title8")
                .font(.title)
            BoardIllustrationView(.figure1).frame(width: 250)
            Text("Rules_Text8-1")
            BoardIllustrationView(.figure2).frame(width: 250)
            Text("Rules_Text8-2")

            // Pass
            Text("Rules_Title9")
                .font(.title)
            Text("Rules_Text9-1")
        }
        Group {
            // End of the game
            Text("Rules_Title10")
                .font(.title)
            Text("Rules_Text10-1")
            Text("Rules_Text10-2")
            Text("Rules_Text10-3")
        }
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
            .environment(\.colorScheme, .dark)
            .background(.black)
    }
}
