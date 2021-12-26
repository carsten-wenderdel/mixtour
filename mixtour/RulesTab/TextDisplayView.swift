//
//  TextDisplayView.swift
//  mixtour
//
//  Created by Carsten Wenderdel on 26.12.21.
//  Copyright © 2021 Carsten Wenderdel. All rights reserved.
//

import SwiftUI


struct TextDisplayView<TextContent>: View where TextContent: View {
    let standardPadding = 5.0
    let textContentView: TextContent
    let title: String

    var body: some View {
        NavigationView {
            ScrollView([.vertical]) {
                textContentView
                    .frame(maxWidth: 500) // Biggest phone is 428 points wide. On iPads don't use whole screen for text.
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    .frame(maxWidth: .infinity) // On iPads push the scrollingIndicator to the left edge of the screen
                // It's a bit strange to call `.frame` twice - but it works.
            }
//            .multilineTextAlignment(.leading)
            .environmentObject(AnimationConstants())
            .navigationBarTitle(LocalizedString(title))
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // full screen on iPad
    }
}

#if DEBUG
struct TextDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        TextDisplayView(
            textContentView: Text("Some Text"),
            title: "Mixtour"
        )
    }
}
#endif
