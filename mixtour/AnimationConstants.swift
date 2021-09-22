import SwiftUI

class AnimationConstants: ObservableObject {
    @Published var pieceAnimation: Animation? = Animation.default.speed(0.8)
}
