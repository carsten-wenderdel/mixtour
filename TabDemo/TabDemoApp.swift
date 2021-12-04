import SwiftUI

@main
struct AnimationTestApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                BlaView()
                    .tabItem {
                        Text("Tab 1")
                    }
                Text("Content 2")
                    .tabItem {
                        Text("Tab 2")
                    }
            }
        }
    }
}

struct BlaView: View {
    var body: some View {
        ContentView()
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @Namespace var namespace

    var body: some View {
        VStack {
            Button(action: {
                viewModel.move()
            }) {
                Text("Move")
            }

            ZStack() {
                Rectangle()
                    .fill(.gray)
                    .frame(width: 300, height: 300, alignment: .center)
                if viewModel.moved {
                    RectView()
//                        .animation(Animation.default.speed(0.5))
                        .matchedGeometryEffect(id: 0, in: namespace, properties: .frame)
                        .offset(x: 0, y: -130)

                } else {
                    RectView()
//                        .animation(Animation.default.speed(0.5))
                        .matchedGeometryEffect(id: 0, in: namespace, properties: .frame)
                        .offset(x: 0, y: 130)
                }
            }
        }
    }
}

struct RectView: View {
    var body: some View {
        Rectangle()
            .frame(width: 100, height: 30, alignment: .center)
    }
}


final class ViewModel: ObservableObject {
    @Published var moved = false

    func move() {
        withAnimation(Animation.default.speed(0.5)) {
            moved.toggle()
        }
    }
}
