import SwiftUI

@main
struct mixtourApp: App {

    let tabBar = UITabBar.appearance()

    init() {
        // TODO: This is an ugly workaround. It used to work out of the box in iOS 12.
        // Also the 1 pixel line above is gone. Checkout the launch screen how it is supposed to look like.
        UITabBar.appearance().backgroundColor = UIColor(MixColors.tabViewBackground)
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                RulesView()
                    .tabItem {
                        Label("Rules", systemImage: "list.bullet.rectangle.portrait.fill")
//                        Label("Rules", systemImage: "list.bullet")
                    }
                ContentView()
                    .tabItem {
                        Label("Game", systemImage: "checkerboard.rectangle")
//                        Label("Game", systemImage: "checkerboard.shield")
                    }
                RulesWebView()
                    .tabItem {
                        Label("Rules", systemImage: "list.bullet.rectangle.portrait.fill")
//                        Label("Rules", systemImage: "list.bullet")
                    }
                LegalView()
                    .tabItem {
                        Label("Legal", systemImage: "info.circle.fill")
                    }
            }
        }
    }
}
