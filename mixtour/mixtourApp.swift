import SwiftUI

@main
struct mixtourApp: App {

    let tabBar = UITabBar.appearance()

//    init() {
        // TODO: This is an ugly workaround. It used to work out of the box in Xcode 12.
        // Also the 1 pixel line above is gone. Checkout the launch screen how it is supposed to look like.
        // Hm, pixel line is back and background colors work again (Xcode 13.2)
//        UITabBar.appearance().backgroundColor = UIColor(MixColors.tabViewBackground)
//    }

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Game", systemImage: "checkerboard.rectangle")
//                        Label("Game", systemImage: "checkerboard.shield")
                    }
                RulesView()
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
