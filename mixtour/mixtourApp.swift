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
                ContentView()
                    .tabItem {
                        Label("Rules", systemImage: "list.bullet.rectangle.portrait.fill")
//                        Label("Rules", systemImage: "list.bullet")
                    }
                ContentView()
                    .tabItem {
                        Label("Legal", systemImage: "info.circle.fill")
                    }
            }
        }
    }
}
