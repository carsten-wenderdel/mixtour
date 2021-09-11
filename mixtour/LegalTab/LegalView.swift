import SwiftUI

struct LegalView: View {

//    let title: AttributedString = AttributedString(title)

    var body: some View {
        ZStack {
            MixColors.background
                .ignoresSafeArea()

            VStack(spacing: 10) {

                Text("Large Title").font(.largeTitle)
                Text("Title").font(.title)
                Text("Some more Text 1, so long that it should wrap into multiple lines")
                Text("Some more Text 2").font(.body)
                Text("Title2").font(.title2)
                Text("Headline").font(.headline)
                Text("Subheadline").font(.subheadline)
                Text("Visit: [www.spiegel.de](https://www.spiegel.de)")
                Text("Tel: [+49 123 456 789](tel:+49123456789)")
            }
            .multilineTextAlignment(.center)
        }
    }
}

struct LegalView_Previews: PreviewProvider {
    static var previews: some View {
        LegalView()
    }
}
