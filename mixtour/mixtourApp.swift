import SwiftUI

@main
struct mixtourApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
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
