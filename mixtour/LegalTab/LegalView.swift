import SwiftUI

struct LegalView: View {

//    let title: AttributedString = AttributedString(title)

    var body: some View {
        ZStack {
            MixColors.background
                .ignoresSafeArea()

            VStack(spacing: 10) {
                Group {
                    Text("ToDo").font(.title)
                    Text("Legal/Impressum")
                    Text("Link to Spielstein")
                    Text("German Rules")
                    Text("Web page")
                    Text("Privacy Web Page")
                    Text("Privacy Statement")
                    Text("App Icons")
                }
                Group {
                    Text("Screenshots for App Store")
                    Text("App Store Texts")

                    Text("Known Bugs").font(.title)
                    Text("Margin between board and unused pieces is different")
                    Text("During Undo some pieces get hidden behind other pieces during movement")
                }

//                Text("Large Title").font(.largeTitle)
//                Text("Title").font(.title)
//
//                Text("Some more Text 1, so long that it ")
//                    + Text("should wrap into multiple lines")
//                Text("Some more Text 2").font(.body)
//                Text("Title2").font(.title2).foregroundColor(.secondary)
//                Text("Title3").font(.title3).foregroundColor(.secondary)
//                Text("Headline").font(.headline)
//                Text("Subheadline").font(.subheadline)
//                Text("Callout").font(.callout)
////                Text("Visit: ")
////                + Text ("[www.spiegel.de](https://www.spiegel.de)")
//                Text("Caption: Tel: ")
//                + Text("[+49 123 456 789](tel:+49123456789)")
//                    .font(.caption)
            }
            .multilineTextAlignment(.center)
            .textSelection(.enabled)
        }
    }
}

struct LegalView_Previews: PreviewProvider {
    static var previews: some View {
        LegalView()
    }
}
