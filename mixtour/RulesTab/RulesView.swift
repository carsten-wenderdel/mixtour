import SwiftUI
import MixModel

fileprivate let standardPadding = 5.0

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
//            .multilineTextAlignment(.leading)
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
            Text("Rules_Text1-1").subheadline()

            // Material
            Text("Rules_Title2").title()
            Text("Rules_Text2-1").listItem()
            Text("Rules_Text2-2").listItem().padding(.bottom, standardPadding)

            BoardIllustrationView(Board()).frame(width: 250)
            Text("Rules_Text2-3").illustration()

            // Objective
            Text("Rules_Title3").title()
            Text("Rules_Text3-1").regular()
        }
        Group {
            // Preparation
            Text("Rules_Title4").title()
            Text("Rules_Text4-1").regular()
            Text("Rules_Text4-2").regular()

            // Play
            Text("Rules_Title5").title()
            Text("Rules_Text5-1").illustration()
            Text("Rules_Text5-2").regular()
            Text("Rules_Text5-3").listItem()
            Text("Rules_Text5-4").listItem().padding(.bottom, standardPadding)

            // Enter a piece
            Text("Rules_Title6").headline()
            Text("Rules_Text6-1").regular()
        }
        Group {
            // Move a stack
            Text("Rules_Title7").headline()
            Text("Rules_Text7-1").regular()
            Text("Rules_Text7-2").listItem()
            Text("Rules_Text7-3").listItem()
            Text("Rules_Text7-4").listItem()
            Text("Rules_Text7-5").listItem()
            Text("Rules_Text7-6").listItem()
        }
        Group {
            Text("Rules_Text7-7").listItem()
            Text("Rules_Text7-8").listItem()
            Text("Rules_Text7-9").listItem()
            Text("Rules_Text7-10").listItem()
            Text("Rules_Text7-11").listItem().padding(.bottom, standardPadding)
            Text("Rules_Text7-12").regular()
            Text("Rules_Text7-13").listItem()
            Text("Rules_Text7-14").listItem().padding(.bottom, standardPadding)
        }
        Group {
            // Examples
            Text("Rules_Title8").headline()
            BoardIllustrationView(.figure1).frame(width: 250)
            Text("Rules_Text8-1").illustration()
            BoardIllustrationView(.figure2).frame(width: 250)
            Text("Rules_Text8-2").illustration()

            // Pass
            Text("Rules_Title9").headline()
            Text("Rules_Text9-1").regular()
        }
        Group {
            // End of the game
            Text("Rules_Title10").title()
            Text("Rules_Text10-1").regular()
            Text("Rules_Text10-2").regular()
            Text("Rules_Text10-3").illustration()
        }
    }
}


extension Text {

    func illustration() -> some View {
        foregroundColor(.secondary)
            .padding(.bottom, standardPadding)
    }

    func title() -> some View {
        font(.title)
            .padding(.top, 2 * standardPadding)
            .padding(.bottom, 2 * standardPadding)
    }

    func headline() -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
            .font(.headline)
            .padding(.top, standardPadding)
            .padding(.bottom, standardPadding)
    }

    func subheadline() -> some View {
        foregroundColor(.secondary)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.top, standardPadding)
            .padding(.bottom, standardPadding)
    }

    func regular() -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, standardPadding)
    }

    func listItem() -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text("\u{2022}  ")
            self.frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 1)
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
            .environment(\.colorScheme, .dark)
            .background(.black)
    }
}
