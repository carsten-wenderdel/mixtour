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
            Headline(text: "Rules_Text1-1")

            // Material
            Title(text: "Rules_Title2")
            ListItem(text: "Rules_Text2-1")
            ListItem(text: "Rules_Text2-2")

            BoardIllustrationView(Board()).frame(width: 250)
            IllustrationText(text: "Rules_Text2-3")
            Text("Rules_Text2-3")

            // Objective
            Title(text: "Rules_Title3")
            MixText(text: "Rules_Text3-1")
        }
        Group {
            // Preparation
            Title(text: "Rules_Title4")
            Text("Rules_Text4-1")
            Text("Rules_Text4-2")

            // Play
            Title(text: "Rules_Title5")
            Text("Rules_Text5-1")
            Text("Rules_Text5-2")
            Text("Rules_Text5-3")
            Text("Rules_Text5-4")
        }
        Group {
            // Enter a piece
            Headline(text: "Rules_Title6")
            Text("Rules_Text6-1")

            // Move a stack
            Headline(text: "Rules_Title7")
            Text("Rules_Text7-1")
            Text("Rules_Text7-2")
            Text("Rules_Text7-3")
            Text("Rules_Text7-4")
            Text("Rules_Text7-5")
            Text("Rules_Text7-6")
        }
        Group {
            // Examples
            Headline(text: "Rules_Title8")
            BoardIllustrationView(.figure1).frame(width: 250)
            Text("Rules_Text8-1")
            BoardIllustrationView(.figure2).frame(width: 250)
            Text("Rules_Text8-2")

            // Pass
            Headline(text: "Rules_Title9")
            Text("Rules_Text9-1")
        }
        Group {
            // End of the game
            Title(text: "Rules_Title10")
            Text("Rules_Text10-1")
            Text("Rules_Text10-2")
            Text("Rules_Text10-3")
        }
    }
}

fileprivate struct Title: View {
    var text: String
    var body: some View {
        Text("\(LocalizedString(text))")
            .font(.title)
    }
}

fileprivate struct Headline: View {
    var text: String
    var body: some View {
        Text("\(LocalizedString(text))")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.headline)
    }
}

fileprivate struct MixText: View {
    var text: String
    var body: some View {
        Text("\(LocalizedString(text))")
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

fileprivate struct ListItem: View {
    var text: String
    var body: some View {
        Text("\u{2022} \(LocalizedString(text))")
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

fileprivate struct IllustrationText: View {
    var text: String
    var body: some View {
        Text("**Bla** Bla")

//        Text("\(LocalizedString(text))")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.secondary)
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
            .environment(\.colorScheme, .dark)
            .background(.black)
    }
}
